// LXHSelectFeeRateViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSelectFeeRateViewController.h"
#import "Masonry.h"
#import "LXHSelectFeeRateView.h"
#import "LXHFeeOptionCell.h"
#import "UIViewController+LXHAlert.h"
#import "LXHBitcoinfeesNetworkRequest.h"
#import "MJRefresh.h"
#import "LXHGlobalHeader.h"
#import "UIView+Toast.h"
#import "LXHSelectFeeRateViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSelectFeeRateViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSelectFeeRateView *contentView;
@property (nonatomic) LXHSelectFeeRateViewModel *viewModel;
@property (nonatomic, copy) dataChangedCallback dataChangedCallback;
@end

@implementation LXHSelectFeeRateViewController

- (instancetype)initWithViewModel:(id)viewModel
              dataChangedCallback:(dataChangedCallback)dataChangedCallback {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _dataChangedCallback = dataChangedCallback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSelectFeeRateView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setContentViewProperties];
    [self addActions];
    [self requestFeeRate];
}

- (void)setContentViewProperties {
    //set refreshing header
    LXHWeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestFeeRate)];
    header.lastUpdatedTimeText = ^(NSDate *lastUpdatedTime) {
        return [weakSelf.viewModel updateTimeText];
    };
    self.contentView.listView.mj_header = header;
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

- (void)refreshListView {
    [_viewModel resetCellDataListForListView];
    [self.contentView.listView reloadData];
}

- (void)showPromptLabel {
    self.contentView.promptLabel.hidden = NO;
}

- (void)requestFeeRate {
    [self.contentView.indicatorView startAnimating];
    __weak __typeof(self)weakSelf = self;
    [_viewModel requestFeeRateWithSuccessBlock:^{
        [weakSelf.contentView.indicatorView stopAnimating];
        [weakSelf.contentView.listView.mj_header endRefreshing];
        [weakSelf setDelegates];
        [weakSelf refreshListView];
        [weakSelf showPromptLabel];
    } failureBlock:^(NSString * _Nonnull errorPrompt) {
        [weakSelf.contentView.indicatorView stopAnimating];
        [weakSelf.contentView.listView.mj_header endRefreshing];
        [weakSelf setDelegates];
        [weakSelf refreshListView];
        [weakSelf showPromptLabel];
        [weakSelf.view makeToast:errorPrompt];
    }];
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
    return _viewModel.cellDataListForListView;
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
    if ([cellType isEqualToString:@"LXHFeeOptionCell"])
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
    if ([cellType isEqualToString:@"LXHFeeOptionCell"]) {
        LXHFeeOptionCell *cellView = (LXHFeeOptionCell *)view;
        NSString *feeRate = [dataForRow valueForKeyPath:@"feeRate"];
        if (!feeRate)
            feeRate = @"";
        NSMutableAttributedString *feeRateAttributedString = [cellView.feeRate.attributedText mutableCopy];
        [feeRateAttributedString.mutableString setString:feeRate];
        cellView.feeRate.attributedText = feeRateAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
        NSString *circleImageImageName = [dataForRow valueForKey:@"circleImage"];
        if (circleImageImageName)
            cellView.circleImage.image = [UIImage imageNamed:circleImageImageName];
        NSString *checkedImageImageName = [dataForRow valueForKey:@"checkedImage"];
        if (checkedImageImageName)
            cellView.checkedImage.image = [UIImage imageNamed:checkedImageImageName];
        BOOL isChecked = [[dataForRow valueForKey:@"isChecked"] boolValue];
        cellView.checkedImage.hidden = !isChecked;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHFeeOptionCell"])
            return 60;
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
    [_viewModel checkRowAtIndex:indexPath.row];
    [tableView reloadData];
    _dataChangedCallback();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
