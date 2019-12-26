// LXHOthersViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHOthersViewController.h"
#import "Masonry.h"
#import "LXHOthersView.h"
#import "LXHAddressListViewController.h"
#import "LXHSettingViewController.h"
#import "LXHTransactionListViewController.h"
#import "LXHScanQRViewController.h"
#import "LXHLineCell.h"
#import "LXHTextRightIconCell.h"
#import "LXHShowWalletMnemonicWordsViewController.h"
#import "UIViewController+LXHBasicMobileWallet.h"
#import "Toast.h"
#import "LXHOthersViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHOthersViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHOthersView *contentView;
@property (nonatomic) LXHOthersViewModel *viewModel;
@end

@implementation LXHOthersViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHOthersView alloc] init];
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
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    static NSMutableArray *dataForCells = nil;
    if (!dataForCells) {
        dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            NSDictionary *dic = nil;
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHLineCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"交易列表", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"本地地址列表", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"扫描二维码", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell"};
            [dataForCells addObject:dic];
            dic = @{@"text":@"设置", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell"};
            [dataForCells addObject:dic];
        }
    }
    return dataForCells;
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
    if ([cellType isEqualToString:@"LXHLineCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHTextRightIconCell"])
        return 101;
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
    if ([cellType isEqualToString:@"LXHTextRightIconCell"]) {
        LXHTextRightIconCell *cellView = (LXHTextRightIconCell *)view;
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
        if ([cellType isEqualToString:@"LXHLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHTextRightIconCell"])
            return 56;
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
            id viewModel = [_viewModel transactionListViewModel];
            UIViewController *controller = [[LXHTransactionListViewController alloc] initWithViewModel:viewModel];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            UIViewController *controller = [[LXHAddressListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
#if TARGET_IPHONE_SIMULATOR
            [self.view makeToast:NSLocalizedString(@"模拟器上无法使用该功能", nil)];
#else
            UIViewController *controller = [[LXHScanQRViewController alloc] initWithDetectionBlock:^(NSString *message) {
                __weak typeof(self) weakSelf = self;
                [weakSelf.navigationController popToViewController:self animated:NO];
                NSString *errorMessage = [weakSelf.viewModel checkScannedText:message];
                if (errorMessage) {
                    [weakSelf.view makeToast:errorMessage];
                } else {
                    NSDictionary *dataForNavigation = [weakSelf.viewModel dataForNavigationWithScannedText:message];
                    if (dataForNavigation) {
                        NSString *controllerClassName = dataForNavigation[@"controllerClassName"];
                        id viewModel = dataForNavigation[@"viewModel"];
                        UIViewController *controller = [[NSClassFromString(controllerClassName) alloc] initWithViewModel:viewModel];
                        controller.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    } else {
                       [weakSelf.view makeToast:NSLocalizedString(@"不支持该数据类型", nil)];
                    }
                }
            }];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
#endif
        }
            break;
        case 4:
        {
            UIViewController *controller = [[LXHSettingViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
