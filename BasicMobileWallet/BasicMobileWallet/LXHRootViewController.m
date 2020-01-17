//
//  ViewController.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHRootViewController.h"
#import "LXHWelcomeViewController.h"
#import "LXHWallet.h"
#import "LXHTabBarPageViewController.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHValidatePINViewController.h"
#import "AppDelegate.h"

@interface LXHRootViewController ()

@end

@implementation LXHRootViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _showValidatePINViewControllerIfNeeded = YES;//默认值
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self pushMainController];
}

- (void)pushMainController {
    BOOL walletDataInitialized = [LXHWallet walletDataGenerated];
    if (!walletDataInitialized) {
        [self pushInitWalletWelcomeViewController];
    } else {
        BOOL hasPIN = [LXHWallet hasPIN];
        if (hasPIN && _showValidatePINViewControllerIfNeeded) {//需要输入PIN码
            [self pushValidatePINViewController];
        } else {//没有设置PIN码就直接进入TabBarController
            [self pushTabBarController];
        }
    }
}

- (void)pushValidatePINViewController {
    __weak typeof(self) weakSelf = self;
    LXHValidatePINViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [weakSelf popViewControllerAnimated:NO];
        [weakSelf pushTabBarController];//如果成功进入TabBarController
    }];
    [self pushViewController:validatePINViewController animated:NO];
}

- (void)pushTabBarController {
    LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
    UIViewController *controller = [[LXHTabBarPageViewController alloc] initWithViewModel:viewModel];
    [self pushViewController:controller animated:YES];
}

- (void)pushInitWalletWelcomeViewController {
    UIViewController *controller = [[LXHWelcomeViewController alloc] init];
    [self pushViewController:controller animated:NO];
}

+ (void)reEnter {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    LXHRootViewController *rootViewController = [[LXHRootViewController alloc] init];
    rootViewController.showValidatePINViewControllerIfNeeded = NO;//重置的时候不用重复输入PIN
    appDelegate.window.rootViewController = rootViewController;
}


@end
