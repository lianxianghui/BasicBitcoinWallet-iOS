//
//  LXHControllerUtils.m
//  BasicMobileWallet
//
//  Created by lian on 2020/3/11.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHControllerUtils.h"
#import "LXHTabBarPageViewController.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHWelcomeViewController.h"
#import "LXHValidatePINViewController.h"
#import "LXHMaskViewController.h"
#import "LXHWallet.h"
#import "AppDelegate.h"

@implementation LXHControllerUtils

+ (UIViewController *)createRootViewController {
    UIViewController *controller;
    BOOL walletDataInitialized = [LXHWallet walletDataGenerated];
    if (!walletDataInitialized) {
        controller = [[LXHWelcomeViewController alloc] init];//Welcome page for init wallet data
    } else {
        LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
        controller = [[LXHTabBarPageViewController alloc] initWithViewModel:viewModel];
    }
    return controller;
}

+ (void)presentValidatePINViewController {
    __weak UIViewController *rootViewController = [AppDelegate currentRootViewController];
    UIViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:validatePINViewController];
    [rootViewController presentViewController:navigationController animated:NO completion:nil];
}

+ (void)presentMaskViewController {
    LXHMaskViewController *controller = [[LXHMaskViewController alloc] init];
    UIViewController *rootViewController = [AppDelegate currentRootViewController];
    [rootViewController presentViewController:controller animated:NO completion:nil];
}

+ (void)presentMaskOrValidatePINController {
    if ([LXHWallet hasPIN])
        [self presentValidatePINViewController];
    else
        [self presentMaskViewController];
}

+ (void)dismissCurrentPresentedMaskViewController {
    UIViewController *rootViewController = [AppDelegate currentRootViewController];
    if ([rootViewController.presentedViewController isMemberOfClass:[LXHMaskViewController class]]) {
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

+ (void)dismissCurrentPresentedValidatePINViewController {
    UIViewController *rootViewController = [AppDelegate currentRootViewController];
    if ([rootViewController.presentedViewController isMemberOfClass:[LXHValidatePINViewController class]]) {
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

//+ (void)rootViewControllerPresentViewControllerWithPushingAnimation:(UIViewController *)controller {
//    CATransition *transition = [[CATransition alloc] init];
//    transition.duration = 0.5;
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    UIViewController *rootViewController = [AppDelegate currentRootViewController];
//    [rootViewController.view.window.layer addAnimation:transition forKey:kCATransition];
//    [rootViewController presentViewController:controller animated:false completion:nil];
//}
//
//+ (void)rootViewControllerDismissViewControllerWithPopingAnimation:(UIViewController *)controller {
//    CATransition *transition = [[CATransition alloc] init];
//    transition.duration = 0.5;
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    UIViewController *rootViewController = [AppDelegate currentRootViewController];
//    [rootViewController.view.window.layer addAnimation:transition forKey:kCATransition];
//    [rootViewController presentViewController:controller animated:false completion:nil];
//}

@end
