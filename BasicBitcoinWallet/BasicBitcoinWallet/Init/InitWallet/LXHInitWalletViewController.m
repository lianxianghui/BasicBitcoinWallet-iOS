// LXHInitWalletViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInitWalletViewController.h"
#import "Masonry.h"
#import "LXHInitWalletView.h"
#import "LXHScanQRViewController.h"
#import "LXHSelectMnemonicWordLengthViewController.h"
#import "LXHWallet.h"
#import "AppDelegate.h"
#import "Toast.h"
#import "LXHInitWalletViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInitWalletViewController()
@property (nonatomic) LXHInitWalletView *contentView;
@property (nonatomic) LXHInitWalletViewModel *viewModel;
@end

@implementation LXHInitWalletViewController

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
    self.contentView = [[LXHInitWalletView alloc] init];
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
    [self.contentView.importWatchOnlyWalletButton addTarget:self action:@selector(importWatchOnlyWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.restoreWalletButton addTarget:self action:@selector(restoreWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.createWalletButton addTarget:self action:@selector(createWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)importWatchOnlyWalletButtonClicked:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    UIViewController *controller = [[LXHScanQRViewController alloc] initWithDetectionBlock:^(NSString *message) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [weakSelf.contentView.indicatorView startAnimating];
        [LXHWallet importReadOnlyWalletWithAccountExtendedPublicKey:message successBlock:^(NSDictionary * _Nonnull resultDic) {
            [weakSelf.contentView.indicatorView stopAnimating];
            [AppDelegate reEnterRootViewController];
         } failureBlock:^(NSDictionary * _Nonnull resultDic) {
             [weakSelf.contentView.indicatorView stopAnimating];
             [weakSelf.view makeToast:NSLocalizedString(@"导入只读钱包失败", nil)];
         }];
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

- (void)restoreWalletButtonClicked:(UIButton *)sender {
    id viewModel = [_viewModel restoreWalletButtonClicked];
    LXHSelectMnemonicWordLengthViewController *controller = [[LXHSelectMnemonicWordLengthViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createWalletButtonClicked:(UIButton *)sender {
    id viewModel = [_viewModel createWalletButtonClicked];
    LXHSelectMnemonicWordLengthViewController *controller = [[LXHSelectMnemonicWordLengthViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}


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

@end
