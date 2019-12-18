// LXHSettingViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSettingViewController.h"
#import "Masonry.h"
#import "LXHSettingView.h"
#import "LXHSetPinViewController.h"
#import "LXHAboutViewController.h"
#import "LXHCurrentAccountInfoViewController.h"
#import "LXHTextRightIconCell.h"
#import "UIUtils.h"
#import "LXHKeychainStore.h"
#import "UIViewController+LXHAlert.h"
#import "LXHWallet.h"
#import "AppDelegate.h"
#import "LXHRootViewController.h"
#import "UIViewController+LXHBasicMobileWallet.h"
#import "LXHTransactionDataManager.h"
#import "LXHShowWalletMnemonicWordsViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSettingViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSettingView *contentView;
@property (nonatomic) NSMutableArray *dataForCells;
@end

@implementation LXHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSettingView alloc] init];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
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
            NSDictionary *dic = nil;
            dic = @{@"text":@"重置钱包", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(0)};
            [dataForCells addObject:dic];
            
            NSString *text = [self hasPin] ? NSLocalizedString(@"修改PIN码", nil) : NSLocalizedString(@"设置PIN码", nil);
            dic = @{@"text":text, @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(1)};
            [dataForCells addObject:dic];
            if ([self hasPin]) {
                dic = @{@"text":@"清除PIN码", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(2)};
                [dataForCells addObject:dic];
            }
            dic = @{@"text":@"钱包助记词", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(3)};
            [dataForCells addObject:dic];
            dic = @{@"text":@"账户信息", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(4)};
            [dataForCells addObject:dic];
            dic = @{@"text":@"关于", @"isSelectable":@"1", @"cellType":@"LXHTextRightIconCell", @"id":@(5)};
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
    if ([cellType isEqualToString:@"LXHTextRightIconCell"])
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
    NSDictionary *cellData = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSInteger cellId = [cellData[@"id"] integerValue];
    switch(cellId) {
        case 0:
        {
            [self validatePINWithPassedHandler:^{
                [self resetWallet];
            }];
        }
            break;
        case 1:
        {
            [self validatePINWithPassedHandler:^{
                [self enterSetPinViewController];
            }];
        }
            break;
        case 2:
        {
            [self validatePINWithPassedHandler:^{
                [self clearPin];
            }];
        }
        case 3:
        {
            [self validatePINWithPassedHandler:^{
                UIViewController *controller = [[LXHShowWalletMnemonicWordsViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
            break;
        case 4:
        {
            UIViewController *controller = [[LXHCurrentAccountInfoViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            UIViewController *controller = [[LXHAboutViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)enterSetPinViewController {
    UIViewController *controller = [[LXHSetPinViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resetWallet {
    [self showOkCancelAlertViewWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"重置将会清除本地的钱包数据，务必要保证已经备份了钱包助记词。您确定现在要重置吗？", nil) okHandler:^(UIAlertAction * _Nonnull action) {
        //clear data
        [LXHWallet clearAccount];
        [[LXHTransactionDataManager sharedInstance] clearCachedData];
        //show welcome page
        AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
        LXHRootViewController *rootViewController = (LXHRootViewController *)appDelegate.window.rootViewController;
        [rootViewController clearAndPushMainController];
    } cancelHandler:nil];
}

- (BOOL)hasPin {
    return [[LXHKeychainStore sharedInstance].store contains:kLXHKeychainStorePIN];
}

- (void)refreshData {
    _dataForCells = nil;
    [self.contentView.listView reloadData];
}

- (void)clearPin {
    [self showOkCancelAlertViewWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"清除PIN码将会带来一定的安全隐患，您确定吗？", nil) okHandler:^(UIAlertAction * _Nonnull action) {
        [[LXHKeychainStore sharedInstance].store setData:nil forKey:kLXHKeychainStorePIN];
        [self refreshData];
    } cancelHandler:nil];
}

@end
