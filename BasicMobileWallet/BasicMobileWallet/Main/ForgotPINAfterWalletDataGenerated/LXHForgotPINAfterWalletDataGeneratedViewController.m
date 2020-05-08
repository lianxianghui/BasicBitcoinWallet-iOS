// LXHForgotPINAfterWalletDataGeneratedViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-03-6
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHForgotPINAfterWalletDataGeneratedViewController.h"
#import "Masonry.h"
#import "LXHForgotPINAfterWalletDataGeneratedView.h"
#import "LXHScanQRViewController.h"
#import "LXHWallet.h"
#import "Toast.h"
#import "LXHSelectMnemonicWordLengthViewController.h"
#import "LXHForgotPINAfterWalletDataGeneratedViewModel.h"
#import "LXHSetPinViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHForgotPINAfterWalletDataGeneratedViewController()
@property (nonatomic) LXHForgotPINAfterWalletDataGeneratedView *contentView;
@property (nonatomic) LXHForgotPINAfterWalletDataGeneratedViewModel *viewModel;
@end

@implementation LXHForgotPINAfterWalletDataGeneratedViewController

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
    self.contentView = [[LXHForgotPINAfterWalletDataGeneratedView alloc] init];
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
    id viewModel = [_viewModel inputMnemonicWordButtonClicked];
    LXHSelectMnemonicWordLengthViewController *controller = [[LXHSelectMnemonicWordLengthViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

//scan extendedPublicKey
- (void)button1Clicked:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    UIViewController *controller = [[LXHScanQRViewController alloc] initWithDetectionBlock:^(NSString *message) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if ([weakSelf.viewModel checkExtendedPublicKeyWithQRString:message]) {
            UIViewController *controller = [[LXHSetPinViewController alloc] initWithViewModel:nil];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self.view makeToast:NSLocalizedString(@"您扫描的扩展公钥与当前钱包的不符或者您选择的重置PIN码方式不对。", nil)];
        }
    }];
    controller.hidesBottomBarWhenPushed = YES;
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
