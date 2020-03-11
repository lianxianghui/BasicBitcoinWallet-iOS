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
@property UINavigationController *navigationControllerForValidatingPIN;
@property LXHValidatePINViewController *validatePINViewController;
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
            //[self showValidatePINViewControllerAndEnterTabBarIfSucceed];
            [self pushValidatePINViewControllerAndEnterTabBarIfSucceed];
        } else {//没有设置PIN码就直接进入TabBarController
            [self pushTabBarController];
        }
    }
}

- (void)pushValidatePINViewControllerAndEnterTabBarIfSucceed {
    LXHValidatePINViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [LXHRootViewController reEnter];//重进入不会再次显示validatePINViewController
    }];
    self.validatePINViewController = validatePINViewController;
    [self pushViewController:validatePINViewController animated:YES];
}

- (void)pushValidatePINViewControllerIfNeeded {
    if (self.validatePINViewController)
        return;
    __weak typeof(self) weakSelf = self;
    LXHValidatePINViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [weakSelf popViewControllerAnimated:YES];
        weakSelf.validatePINViewController = nil;
    }];
    self.validatePINViewController = validatePINViewController;
    [self pushViewController:validatePINViewController animated:YES];
}

- (void)popValidatePINViewController {
    [self popToViewController:self.validatePINViewController animated:NO];
    [self popViewControllerAnimated:NO];
    self.validatePINViewController = nil;
}

//只会在初始的时候会被调用
- (void)showValidatePINViewControllerAndEnterTabBarIfSucceed {
    __weak typeof(self) weakSelf = self;
    LXHValidatePINViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [weakSelf removeFromParentViewController];
        weakSelf.navigationControllerForValidatingPIN = nil;
        [weakSelf pushTabBarController];//如果成功进入TabBarController
    }];
    _navigationControllerForValidatingPIN = [[UINavigationController alloc] initWithRootViewController:validatePINViewController];
    //[self pushViewController:validatePINViewController animated:NO];
    //[self pushViewController:navigationContoller animated:NO];
    //这里不能push，只能add
    [self addChildViewController:_navigationControllerForValidatingPIN];
}

- (void)presentValidatePINViewController {
//    if (_navigationControllerForValidatingPIN)
//        return;
    __weak typeof(self) weakSelf = self;
    LXHValidatePINViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        weakSelf.navigationControllerForValidatingPIN = nil;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    _navigationControllerForValidatingPIN = [[UINavigationController alloc] initWithRootViewController:validatePINViewController];
    [self presentViewController:_navigationControllerForValidatingPIN animated:NO completion:nil];
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

+ (LXHRootViewController *)currentRootViewController {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    return (LXHRootViewController *)appDelegate.window.rootViewController;
}

@end
