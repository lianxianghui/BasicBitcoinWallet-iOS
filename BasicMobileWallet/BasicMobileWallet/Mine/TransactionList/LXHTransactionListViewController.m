// LXHTransactionListViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTransactionListViewController.h"
#import "Masonry.h"
#import "LXHTransactionListView.h"
#import "LXHTransactionDetailViewController.h"
#import "LXHTransactionInfoCell.h"
#import "LXHTransactionDataManager.h"
#import "LXhTransaction.h"
#import "LXHGlobalHeader.h"
#import "MJRefresh.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHTransactionListViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHTransactionListView *contentView;
@property (nonatomic) NSMutableArray *dataForCells;

@end

@implementation LXHTransactionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHTransactionListView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(listViewRefresh)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
 //   header.automaticallyChangeAlpha = YES;
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.contentView.listView.mj_header = header;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)listViewRefresh {
    [[LXHTransactionDataManager sharedInstance] requestDataWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        [self.contentView.listView.mj_header endRefreshing];
        [self reloadListView];
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        //TODO 显示提示
    }];
}

- (void)reloadListView {
    self.dataForCells = nil;
    [self.contentView.listView reloadData];
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
            NSArray *transactionList = [LXHTransactionDataManager sharedInstance].transactionList;  
            for (NSDictionary *transactionDic in transactionList) {
//                NSDictionary *dic = @{@"value":@"0.00000001BTC", @"isSelectable":@"1", @"confirmation":@"确认数：2", @"InitializedTime":@"发起时间：2019-05-16  12：34", @"cellType":@"LXHTransactionInfoCell", @"type":@"交易类型：发送"};
                
                NSMutableDictionary *dic = @{@"isSelectable":@"1", @"cellType":@"LXHTransactionInfoCell"}.mutableCopy;
                LXHTransaction *transaction = [[LXHTransaction alloc] initWithDic:transactionDic];
                
                id confirmation = transactionDic[@"confirmations"];
                if (confirmation)
                    dic[@"confirmation"] = [NSString stringWithFormat: @"%@:%@", NSLocalizedString(@"确认数", nil), confirmation];
                else 
                    dic[@"confirmation"] = @"";
                static NSDateFormatter *formatter = nil;
                if (!formatter) {
                    formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
                }
                NSInteger time = [transactionDic[@"time"] integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSString *dateString = [formatter stringFromDate:date];
                dic[@"InitializedTime"] = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"发起时间", nil), dateString];
                
                LXHTransactionSendOrReceiveType sendType = [transaction sendOrReceiveType];
                NSString *typeString = nil;
                NSDecimalNumber *btcValue = nil;
                if (sendType == LXHTransactionSendOrReceiveTypeSend) {
                    typeString = @"发送";
                    btcValue = [transaction sentValueSumFromLocalAddress];
                } else if (sendType == LXHTransactionSendOrReceiveTypeReceive) {
                    typeString = @"接收";
                    btcValue = [transaction receivedValueSumFromLocalAddress];
                } else {
                    typeString = @"";
                    btcValue = [transaction sentValueSumFromLocalAddress];
                }
                typeString = NSLocalizedString(typeString, nil);
                dic[@"type"] = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"交易类型", nil), typeString];
                dic[@"value"] = [NSString stringWithFormat:@"%@ BTC", btcValue];
                [_dataForCells addObject:dic];
            }
        }
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
    if ([cellType isEqualToString:@"LXHTransactionInfoCell"])
        return 100;
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
    if ([cellType isEqualToString:@"LXHTransactionInfoCell"]) {
        LXHTransactionInfoCell *cellView = (LXHTransactionInfoCell *)view;
        NSString *confirmation = [dataForRow valueForKey:@"confirmation"];
        if (!confirmation)
            confirmation = @"";
        NSMutableAttributedString *confirmationAttributedString = [cellView.confirmation.attributedText mutableCopy];
        [confirmationAttributedString.mutableString setString:confirmation];
        cellView.confirmation.attributedText = confirmationAttributedString;
        NSString *type = [dataForRow valueForKey:@"type"];
        if (!type)
            type = @"";
        NSMutableAttributedString *typeAttributedString = [cellView.type.attributedText mutableCopy];
        [typeAttributedString.mutableString setString:type];
        cellView.type.attributedText = typeAttributedString;
        NSString *value = [dataForRow valueForKey:@"value"];
        if (!value)
            value = @"";
        NSMutableAttributedString *valueAttributedString = [cellView.value.attributedText mutableCopy];
        [valueAttributedString.mutableString setString:value];
        cellView.value.attributedText = valueAttributedString;
        NSString *InitializedTime = [dataForRow valueForKey:@"InitializedTime"];
        if (!InitializedTime)
            InitializedTime = @"";
        NSMutableAttributedString *InitializedTimeAttributedString = [cellView.InitializedTime.attributedText mutableCopy];
        [InitializedTimeAttributedString.mutableString setString:InitializedTime];
        cellView.InitializedTime.attributedText = InitializedTimeAttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTransactionInfoCell"])
            return 65;
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
            UIViewController *controller = [[LXHTransactionDetailViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
}

@end
