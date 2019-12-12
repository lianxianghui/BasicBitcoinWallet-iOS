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
#import "LXHInputDetailViewController.h"
#import "LXHOutputDetailViewController.h"

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
            LXHTransaction *transaction = _transaction;
            dataForCell[@"content"] = transaction.txid;
            [dataForCells addObject:dataForCell];
            
            NSDictionary *lxhTextCellDataDic = @{@"isSelectable":@"1", @"cellType":@"LXHTextCell"};
            //type
            dataForCell = lxhTextCellDataDic.mutableCopy;
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
            
            //交易发起时间
            dataForCell = lxhTextCellDataDic.mutableCopy;
            static NSDateFormatter *formatter = nil;
            if (!formatter) {
                formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
            }
            
            NSInteger firstSeen = [transaction.firstSeen integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:firstSeen];
            NSString *dateString = [formatter stringFromDate:date];
            
            dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"发起时间", nil), dateString];
            [dataForCells addObject:dataForCell];
            
            //打包时间
            dataForCell = lxhTextCellDataDic.mutableCopy;
            NSInteger time = [transaction.time integerValue];
            NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *dateString1 = time ? [formatter stringFromDate:date1] : NSLocalizedString(@"尚未打包进区块", nil);
            dataForCell[@"text"] = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"打包时间", nil), dateString1];
            [dataForCells addObject:dataForCell];
            
            //confirmations
            dataForCell = lxhTextCellDataDic.mutableCopy;
            id confirmation = transaction.confirmations;
            if (confirmation)
                dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"确认数", nil), confirmation];
            else 
                dataForCell[@"text"] = @"";
            [dataForCells addObject:dataForCell];
            
            //block
            dataForCell = lxhTextCellDataDic.mutableCopy;
            NSString *block = transaction.block ?: NSLocalizedString(@"尚未打包进区块", nil);
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"区块", nil), block];
            [dataForCells addObject:dataForCell];
            //valueIn
            dataForCell = lxhTextCellDataDic.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输入数量", nil), transaction.inputAmount];
            [dataForCells addObject:dataForCell];        
            //valueOut
            dataForCell = lxhTextCellDataDic.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"输出数量", nil), transaction.outputAmount];
            [dataForCells addObject:dataForCell];             

            //fees 
            dataForCell = lxhTextCellDataDic.mutableCopy;
            dataForCell[@"text"] = [NSString stringWithFormat: @"%@: %@ BTC", NSLocalizedString(@"手续费", nil), _transaction.fees];
            [dataForCells addObject:dataForCell];  

            //in title
            dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
            dataForCell[@"title"] = NSLocalizedString(@"输入", nil);
            [dataForCells addObject:dataForCell]; 
            //vin
            for (NSInteger i = 0; i < [_transaction.inputs count]; i++) {
                LXHTransactionInput *input = [_transaction.inputs objectAtIndex:i];
                dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
                dataForCell[@"text1"] = [NSString stringWithFormat:@"%ld. %@", i+1, input.address];
                dataForCell[@"text2"] = [NSString stringWithFormat:@"%@ BTC", input.value];
                dataForCell[@"data"] = input;
                [dataForCells addObject:dataForCell];
            }
            
            //out title
            dataForCell = @{@"isSelectable":@"0", @"cellType":@"LXHTitleCell"}.mutableCopy;
            dataForCell[@"title"] = NSLocalizedString(@"输出", nil);
            [dataForCells addObject:dataForCell]; 
            
            //vout
            for (NSInteger i = 0; i < [_transaction.outputs count]; i++) {
                LXHTransactionOutput *output = [_transaction.outputs objectAtIndex:i];
                dataForCell = @{@"isSelectable":@"1", @"cellType":@"LXHTransDetailLeftRightTextCell"}.mutableCopy;
                dataForCell[@"text1"] = [NSString stringWithFormat:@"%ld. %@", i+1, output.address];
                dataForCell[@"text2"] = [NSString stringWithFormat:@"%@ BTC", output.value];
                dataForCell[@"data"] = output;
                [dataForCells addObject:dataForCell];
            }
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
            return 47;
        if ([cellType isEqualToString:@"LXHTitleCell"])
            return 27;
        if ([cellType isEqualToString:@"LXHTransDetailLeftRightTextCell"])
            return 50;
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
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    id data = [dataForRow valueForKey:@"data"];
    UIViewController *controller = nil;
    if ([data isKindOfClass:[LXHTransactionInput class]]) {
        LXHTransactionInput *input = (LXHTransactionInput *)data;
        controller = [[LXHInputDetailViewController alloc] initWithInput:input];
    } else if ([data isKindOfClass:[LXHTransactionOutput class]]) {
        LXHTransactionOutput *output = (LXHTransactionOutput *)data;
        controller = [[LXHOutputDetailViewController alloc] initWithOutput:output];
    }
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
}

@end
