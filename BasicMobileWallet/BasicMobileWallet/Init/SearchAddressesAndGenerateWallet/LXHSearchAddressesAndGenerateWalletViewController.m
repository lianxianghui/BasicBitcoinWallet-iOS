// LXHSearchAddressesAndGenerateWalletViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-01-15
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHSearchAddressesAndGenerateWalletViewController.h"
#import "Masonry.h"
#import "LXHSearchAddressesAndGenerateWalletView.h"
#import "LXHSearchAddressesAndGenerateWalletViewModel.h"
#import "UIViewController+LXHAlert.h"
#import "LXHTabBarPageViewController.h"
#import "LXHTabBarPageViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSearchAddressesAndGenerateWalletViewController()
@property (nonatomic) LXHSearchAddressesAndGenerateWalletView *contentView;
@property (nonatomic) LXHSearchAddressesAndGenerateWalletViewModel *viewModel;
@end

@implementation LXHSearchAddressesAndGenerateWalletViewController

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
    self.contentView = [[LXHSearchAddressesAndGenerateWalletView alloc] init];
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
    [self.contentView.button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)button2Clicked:(UIButton *)sender {
    if([_viewModel generateExistWalletData]) {
        [self pushTabBarViewController];
    } else {
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"发生了无法处理的错误，如果方便请联系并告知开发人员", nil) handler:nil];
    }
}

- (void)button1Clicked:(UIButton *)sender {
    [self.contentView.indicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    [_viewModel searchUsedAddressesAndGenerateExistWalletDataWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        [weakSelf.contentView.indicatorView startAnimating];
        [weakSelf pushTabBarViewController];
    } failureBlock:^(NSString * _Nonnull errorPrompt) {
        [weakSelf.contentView.indicatorView stopAnimating];
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(errorPrompt, nil) handler:nil];
    }];
}

- (void)leftImageButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    sender.alpha = 1;
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)pushTabBarViewController {
    LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
    UIViewController *controller = [[LXHTabBarPageViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
