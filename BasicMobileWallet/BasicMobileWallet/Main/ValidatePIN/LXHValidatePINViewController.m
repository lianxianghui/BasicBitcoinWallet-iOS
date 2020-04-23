// LXHValidatePINViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-01-11
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHValidatePINViewController.h"
#import "Masonry.h"
#import "LXHValidatePINView.h"
#import "UIViewController+LXHBasicMobileWallet.h"
#import "UIUtils.h"
#import "UIViewController+LXHAlert.h"
#import "LXHWallet.h"
#import "LXHKeychainStore.h"
#import "LXHForgotPINAfterWalletDataGeneratedViewController.h"
#import "LXHForgotPINBeforeWalletDataGeneratedViewController.h"
#import "AppDelegate.h"
#import "LXHForgotPINAfterWalletDataGeneratedViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHValidatePINViewController()
@property (nonatomic) LXHValidatePINView *contentView;
@property (nonatomic, copy) LXHValidatePINSuccessBlock successBlock;
@end

@implementation LXHValidatePINViewController

- (instancetype)initWithValidatePINSuccessBlock:(LXHValidatePINSuccessBlock)successBlock {
    self = [super init];
    if (self) {
        _successBlock = successBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHValidatePINView alloc] init];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showValidatePINAlertIfNeeded];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
}

- (void)setDelegates {
}


- (void)showValidatePINAlertIfNeeded {
    if ([LXHWallet hasPIN]) {
         __weak typeof(self) weakSelf = self;
        UIAlertController *pinCodeInput = [UIUtils pinCodeInputOKAndForgotPINAlertWithMessage:nil textBlock:^(NSString *text) {
            if ([[LXHKeychainStore sharedInstance] string:text isEqualToEncryptedStringForKey:kLXHKeychainStorePIN]) {
                if (weakSelf.successBlock) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    weakSelf.successBlock();
                }
            } else {
                [self showOkAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"PIN码不正确", nil) handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf showValidatePINAlertIfNeeded];//确定后再次显示
                }];
            }
        } forgotPINBlock:^{
            if ([LXHWallet walletDataGenerated]) {
                id viewModel = [[LXHForgotPINAfterWalletDataGeneratedViewModel alloc] init];
                UIViewController *viewController = [[LXHForgotPINAfterWalletDataGeneratedViewController alloc] initWithViewModel:viewModel];
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            } else {
                UIViewController *viewController = [[LXHForgotPINBeforeWalletDataGeneratedViewController alloc] init];
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            }
            
        }];
        [self presentViewController:pinCodeInput animated:YES completion:nil];
    }
}

@end
