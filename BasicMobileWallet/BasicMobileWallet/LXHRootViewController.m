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

@interface LXHRootViewController ()

@end

@implementation LXHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    [self pushMainController];
}

- (void)pushMainController {
    UIViewController *controller = nil;
    if ([LXHWallet walletDataGenerated]) {
        controller = [LXHTabBarPageViewController new];
    } else {
        controller = [LXHWelcomeViewController new];
    }
    [self pushViewController:controller animated:NO];
}

- (void)clearAndPushMainController {
    [self popViewControllerAnimated:NO];
    [self pushMainController];
}


@end
