// LXHTransactionDetailViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTransactionDetailViewController.h"
#import "Masonry.h"
#import "LXHTransactionDetailView.h"
#import "LXHTransactionCell.h"
#import "LXHTextCell.h"
#import "LXHTitleCell.h"
#import "LXHTransDetailLeftRightTextCell.h"
#import "LXHTransaction.h"
#import "LXHGlobalHeader.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHTransactionDetailViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHTransactionDetailView *contentView;
@property (nonatomic) LXHTransaction *transaction;
@property (nonatomic) NSMutableArray *dataForCells;
@end

@implementation LXHTransactionDetailViewController

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        _transaction = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHTransactionDetailView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Actions
- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (!_dataForCells) {
        NSMutableArray *dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            //txid
            NSMutableDictionary *dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransactionCell", @"title":@"交易ID: "}.mutableCopy;
            NSDictionary *transactionDic = _transaction.dic;
            dataForCell[@"content"] = transactionDic[@"txid"];
            [dataForCells addObject:dataForCell];
            //time
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            static NSDateFormatter *formatter = nil;
            if (!formatter) {
                formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
            }
            NSInteger time = [transactionDic[@"time"] integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *dateString = [formatter stringFromDate:date];
            dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"发起时间", nil), dateString];
            [dataForCells addObject:dataForCell];
            //type
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            LXHTransactionSendOrReceiveType sendType = [_transaction sendOrReceiveType];
            NSString *typeString = nil;
            if (sendType == LXHTransactionSendOrReceiveTypeSend) {
                typeString = @"发送";
            } else if (sendType == LXHTransactionSendOrReceiveTypeReceive) {
                typeString = @"接收";
            } else {
                typeString = @"";
            }
            typeString = NSLocalizedString(typeString, nil);
            dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"交易类型", nil), typeString];
            [dataForCells addObject:dataForCell];
            //confirmations
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            id confirmation = transactionDic[@"confirmations"];
            if (confirmation)
                dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"确认数", nil), confirmation];
            else 
                dataForCell[@"text"] = @"";
            [dataForCells addObject:dataForCell];
            //block
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"区块", nil), transactionDic[@"blockheight"]];
            [dataForCells addObject:dataForCell];
            //valueIn
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输入数量", nil), transactionDic[@"valueIn"]];
            [dataForCells addObject:dataForCell];        
            //valueOut
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输出数量", nil), transactionDic[@"valueOut"]];
            [dataForCells addObject:dataForCell];             

            //fees 
            dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"}.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"手续费", nil), _transaction.fees];
            [dataForCells addObject:dataForCell];  

            //in count
            dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
            NSArray *vin = transactionDic[@"vin"];
            dataForCell[@"title"] = [NSString stringWithFormat: @"%@: %ld", NSLocalizedString(@"输入数", nil), vin.count];
            [dataForCells addObject:dataForCell]; 
            
            //TODO
            dataForCell = @{@"text1":@"1. mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"isSelectable":@"1", @"text2":@"0.00000001BTC", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
            [dataForCells addObject:dataForCell];
            
            //out count
            dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
            NSArray *vout = transactionDic[@"vout"];
            dataForCell[@"title"] = [NSString stringWithFormat: @"%@: %ld", NSLocalizedString(@"输出数", nil), vout.count];
            [dataForCells addObject:dataForCell]; 
            
            //TODO 
            dataForCell = @{@"text1":@"1. mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"isSelectable":@"1", @"text2":@"0.00000001BTC", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
            [dataForCells addObject:dataForCell];
        }
        _dataForCells = dataForCells;
    }
    return _dataForCells;
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self dataForTableView:tableView];
    if (indexPath.row < dataForTableView.count)
        return [dataForTableView objectAtIndex:indexPath.row];
    else
        return nil;
}


- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self dataForTableView:tableView];
        if (indexPath.row < data.count) {
            NSDictionary *cellData = [data objectAtIndex:indexPath.row];
            return [cellData valueForKey:@"cellType"];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHTransactionCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHTextCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHTitleCell"])
        return 102;
    if ([cellType isEqualToString:@"LXHTransDetailLeftRightTextCell"])
        return 103;
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView cellContentViewClassStingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    NSString *classString = cellType;
    return classString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataForTableView:tableView].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    NSInteger tag = [self tableView:tableView viewTagAtIndexPath:indexPath];
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
        NSString *viewClass = [self tableView:tableView cellContentViewClassStingAtIndexPath:indexPath];
        UIView *view = [[NSClassFromString(viewClass) alloc] init];
        view.tag = tag;
        [cell.contentView addSubview:view];
        //if view.backgroudColor is clearColor, need to set backgroundColor of contentView and cell.
        //cell.contentView.backgroundColor = view.backgroundColor;
        //cell.backgroundColor = view.backgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
        if ([isSelectable isEqualToString:@"0"])
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell.contentView viewWithTag:tag];
    if ([cellType isEqualToString:@"LXHTransactionCell"]) {
        LXHTransactionCell *cellView = (LXHTransactionCell *)view;
        NSString *content = [dataForRow valueForKey:@"content"];
        if (!content)
            content = @"";
        NSMutableAttributedString *contentAttributedString = [cellView.content.attributedText mutableCopy];
        [contentAttributedString.mutableString setString:content];
        cellView.content.attributedText = contentAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHTextCell"]) {
        LXHTextCell *cellView = (LXHTextCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    if ([cellType isEqualToString:@"LXHTitleCell"]) {
        LXHTitleCell *cellView = (LXHTitleCell *)view;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHTransDetailLeftRightTextCell"]) {
        LXHTransDetailLeftRightTextCell *cellView = (LXHTransDetailLeftRightTextCell *)view;
        NSString *text2 = [dataForRow valueForKey:@"text2"];
        if (!text2)
            text2 = @"";
        NSMutableAttributedString *text2AttributedString = [cellView.text2.attributedText mutableCopy];
        [text2AttributedString.mutableString setString:text2];
        cellView.text2.attributedText = text2AttributedString;
        NSString *text1 = [dataForRow valueForKey:@"text1"];
        if (!text1)
            text1 = @"";
        NSMutableAttributedString *text1AttributedString = [cellView.text1.attributedText mutableCopy];
        [text1AttributedString.mutableString setString:text1];
        cellView.text1.attributedText = text1AttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTransactionCell"])
            return 60;
        if ([cellType isEqualToString:@"LXHTextCell"])
            return 46.7400016784668;
        if ([cellType isEqualToString:@"LXHTitleCell"])
            return 36.34000015258789;
        if ([cellType isEqualToString:@"LXHTransDetailLeftRightTextCell"])
            return 49.50999832153332;
    }
    return 0;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
    if ([isSelectable isEqualToString:@"0"])
        return nil;
    else
        return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch(indexPath.row) {
        case 0:
            {
            }
            break;
        case 1:
            {
            }
            break;
        case 2:
            {
            }
            break;
        case 3:
            {
            }
            break;
        case 4:
            {
            }
            break;
        case 5:
            {
            }
            break;
        case 6:
            {
            }
            break;
        case 7:
            {
            }
            break;
        case 8:
            {
            }
            break;
        case 9:
            {
            }
            break;
        case 10:
            {
            }
            break;
        case 11:
            {
            }
            break;
        default:
            break;
    }
}

@end
