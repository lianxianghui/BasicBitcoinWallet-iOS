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

@implementation LXHControllerUtils

+ (UIViewController *)createRootViewController {
    LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
    UIViewController *controller = [[LXHTabBarPageViewController alloc] initWithViewModel:viewModel];
    return controller;
}

@end
