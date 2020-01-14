// LXHCurrentAccountInfoViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHCurrentAccountInfoViewController.h"
#import "Masonry.h"
#import "LXHCurrentAccountInfoView.h"
#import "LXHQRCodeAndTextViewController.h"
#import "LXHTwoColumnTextCell.h"
#import "LXHEmptyWithSeparatorCell.h"
#import "LXHSmallSizeTextRightIconCell.h"
#import "LXHCurrentAccountInfoViewModel.h"
#import "UIViewController+LXHBasicMobileWallet.h"
#import "Toast.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHCurrentAccountInfoViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHCurrentAccountInfoView *contentView;
@property (nonatomic) NSMutableArray *dataForCells;
@property (nonatomic) LXHCurrentAccountInfoViewModel *viewModel;
@end

@implementation LXHCurrentAccountInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [LXHCurrentAccountInfoViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHCurrentAccountInfoView alloc] init];
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
            NSDictionary *dic = @{@"title":@"网络类型", @"isSelectable":@"1", @"cellType":@"LXHTwoColumnTextCell", @"text":[_viewModel netTypeText]};
            [dataForCells addObject:dic];
            dic = @{@"title":@"Watch only", @"isSelectable":@"1", @"cellType":@"LXHTwoColumnTextCell", @"text":[_viewModel isWatchOnlyText]};
            [dataForCells addObject:dic];
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"账户扩展公钥(xpub)", @"isSelectable":@"1", @"cellType":@"LXHSmallSizeTextRightIconCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"重新搜索当前地址", @"isSelectable":@"1", @"cellType":@"LXHSmallSizeTextRightIconCell"};
            [dataForCells addObject:dic];
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
    if ([cellType isEqualToString:@"LXHTwoColumnTextCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHSmallSizeTextRightIconCell"])
        return 102;
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
    if ([cellType isEqualToString:@"LXHTwoColumnTextCell"]) {
        LXHTwoColumnTextCell *cellView = (LXHTwoColumnTextCell *)view;
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
    if ([cellType isEqualToString:@"LXHSmallSizeTextRightIconCell"]) {
        LXHSmallSizeTextRightIconCell *cellView = (LXHSmallSizeTextRightIconCell *)view;
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
        if ([cellType isEqualToString:@"LXHTwoColumnTextCell"])
            return 47;
        if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
            return 18.00000000000011;
        if ([cellType isEqualToString:@"LXHSmallSizeTextRightIconCell"])
            return 47.00000000000011;
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
        case 3:
        {
            [self validatePINWithPassedHandler:^{
                id viewModel = [self.viewModel qrCodeAndTextViewModel];
                UIViewController *controller = [[LXHQRCodeAndTextViewController alloc] initWithViewModel:viewModel];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
            break;
        case 4:
        {
            __weak typeof(self) weakSelf = self;
            [self validatePINWithPassedHandler:^{
                [weakSelf.contentView.indicatorView startAnimating];
                [weakSelf.viewModel searchAndUpdateCurrentAddressIndexWithSuccessBlock:^(NSString * _Nonnull prompt) {
                    [weakSelf.contentView.indicatorView stopAnimating];
                    [weakSelf.view makeToast:prompt];
                } failureBlock:^(NSString * _Nonnull errorPrompt) {
                    [weakSelf.contentView.indicatorView stopAnimating];
                    [weakSelf.view makeToast:errorPrompt];
                }];
            }];
        }
            break;
        default:
            break;
    }
}

@end

