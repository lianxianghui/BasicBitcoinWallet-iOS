// LXHOutputDetailViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHOutputDetailViewController.h"
#import "Masonry.h"
#import "LXHOutputDetailView.h"
#import "LXHTransactionDetailViewController.h"
#import "LXHAddressDetailCell.h"
#import "LXHLockingScriptCell.h"
#import "LXHEmptyWithSeparatorCell.h"
#import "LXHOutputDetailTextRightIconCell.h"
#import "LXHTransactionOutput.h"
#import "LXHTransactionDataManager.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHOutputDetailViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHOutputDetailView *contentView;
@property (nonatomic) LXHTransactionOutput *model;
@property (nonatomic) NSMutableArray *dataForCells;

@end

@implementation LXHOutputDetailViewController
- (instancetype)initWithOutput:(LXHTransactionOutput *)output
{
    self = [super init];
    if (self) {
        _model = output;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHOutputDetailView alloc] init];
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
        _dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            NSDictionary *dic = nil;
            dic = @{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": _model.address.base58String ?: @""};
            [_dataForCells addObject:dic];
            NSString *valueText = _model.value ? [NSString stringWithFormat:@"%@ BTC", _model.value] : @"";
            dic = @{@"title":@"输出数量 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": valueText};
            [_dataForCells addObject:dic];
            dic = @{@"content":_model.lockingScript ?: @"", @"isSelectable":@"1", @"title":@"锁定脚本", @"cellType":@"LXHLockingScriptCell"};
            [_dataForCells addObject:dic];
            dic = @{@"title":@"脚本类型 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text": [self scriptTypeText]};
            [_dataForCells addObject:dic];
            dic = @{@"title":@"使用情况", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell",
                    @"text": [_model isUnspent] ? @"未花费" : @"已花费"};
            [_dataForCells addObject:dic];
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
            [_dataForCells addObject:dic];
            dic = @{@"text":@"所在交易", @"isSelectable":@"1", @"cellType":@"LXHOutputDetailTextRightIconCell"};
            [_dataForCells addObject:dic];
        }
    }
    return _dataForCells;
}

- (NSString *)scriptTypeText {
    switch (_model.scriptType) {
        case LXHLockingScriptTypeUnSupported:
            return NSLocalizedString(@"无法识别", nil);
            break;
        case LXHLockingScriptTypeP2PKH:
            return NSLocalizedString(@"P2PKH (Pay-to-Public-Key-Hash)", nil);
            break;
        case LXHLockingScriptTypeP2SH:
            return NSLocalizedString(@"Pay-to-Script-Hash (P2SH)", nil);
            break;
        default:
            return NSLocalizedString(@"无法识别", nil);
            break;
    }
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHLockingScriptCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
        return 102;
    if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"])
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"]) {
        LXHAddressDetailCell *cellView = (LXHAddressDetailCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHLockingScriptCell"]) {
        LXHLockingScriptCell *cellView = (LXHLockingScriptCell *)view;
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
    if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"]) {
        LXHOutputDetailTextRightIconCell *cellView = (LXHOutputDetailTextRightIconCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHAddressDetailCell"])
            return 47;
        if ([cellType isEqualToString:@"LXHLockingScriptCell"])
            return 60;
        if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
            return 18;
        if ([cellType isEqualToString:@"LXHOutputDetailTextRightIconCell"])
            return 47;
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
        case 6:
        {
            if (!_model.txid)
                return;
            LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:_model.txid];
            if (!transaction)
                return;
            UIViewController *controller = [[LXHTransactionDetailViewController alloc] initWithModel:transaction];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
