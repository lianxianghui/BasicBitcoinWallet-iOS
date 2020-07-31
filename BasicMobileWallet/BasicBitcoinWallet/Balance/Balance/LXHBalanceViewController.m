// LXHBalanceViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHBalanceViewController.h"
#import "Masonry.h"
#import "LXHBalanceView.h"
#import "LXHOutputDetailViewController.h"
#import "LXHLineCell.h"
#import "LXHBalanceLeftRightTextCell.h"
#import "LXHTransactionDataManager.h"
#import "UILabel+LXHText.h"
#import "BlocksKit.h"
#import "MJRefresh.h"
#import "LXHGlobalHeader.h"
#import "UIView+Toast.h"
#import "LXHBalanceViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHBalanceViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHBalanceView *contentView;
@property (nonatomic) NSString *observerToken;
@property (nonatomic) LXHBalanceViewModel *viewModel;
@end

@implementation LXHBalanceViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)dealloc
{
    [_viewModel removeObserverForUpdatedTransactinList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHBalanceView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    [self addActions];
    [self setDelegates];
    [self setContentViewProperties];
    [self addObservers];
}

- (void)addActions {
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

- (void)setContentViewProperties {
    [self refreshBalance];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(listViewRefresh)];
    self.contentView.listView.mj_header = header;
    LXHWeakSelf
    header.lastUpdatedTimeText = ^(NSDate *lastUpdatedTime) {
        return [weakSelf.viewModel updatedTimeText];
    };
}

- (void)refreshBalance {
    [self.contentView.balanceValue updateAttributedTextString:[_viewModel balanceValueText]];
}

- (void)refreshContentView {
    [self refreshBalance];
    [self reloadListView];
}

- (void)addObservers {
    //观察transactionList, 有变化时刷新列表
    __weak __typeof(self)weakSelf = self;
    [_viewModel addObserverForUpdatedTransactinListWithCallback:^{
        [weakSelf refreshContentView];
    }];
}

- (void)listViewRefresh {
    [_viewModel updateTransactionListDataWithSuccessBlock:^{
        [self.contentView.listView.mj_header endRefreshing];
    } failureBlock:^(NSString * _Nonnull errorPrompt) {
        [self.contentView.listView.mj_header endRefreshing];
        [self.view makeToast:errorPrompt];
    }];
}

- (void)reloadListView {
    [_viewModel resetDataForCells];
    [self.contentView.listView reloadData];
}

//Delegate Methods
- (nullable NSArray *)cellDataListForTableView:(UITableView *)tableView {
    return [_viewModel dataForCells];
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self cellDataListForTableView:tableView];
    if (indexPath.row < dataForTableView.count)
        return [dataForTableView objectAtIndex:indexPath.row];
    else
        return nil;
}

- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self cellDataListForTableView:tableView];
        if (indexPath.row < data.count) {
            NSDictionary *cellData = [data objectAtIndex:indexPath.row];
            return [cellData valueForKey:@"cellType"];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHLineCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHBalanceLeftRightTextCell"])
        return 101;
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView cellContentViewClassStingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    NSString *classString = cellType;
    return classString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellDataListForTableView:tableView].count;
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
    if ([cellType isEqualToString:@"LXHBalanceLeftRightTextCell"]) {
        LXHBalanceLeftRightTextCell *cellView = (LXHBalanceLeftRightTextCell *)view;
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
        if ([cellType isEqualToString:@"LXHLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHBalanceLeftRightTextCell"])
            return 49.5;
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
    id viewModel = [_viewModel outputDetailViewModelAtIndex:indexPath.row];
    if (viewModel) {
        UIViewController *controller = [[LXHOutputDetailViewController alloc] initWithViewModel:viewModel];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

@end
