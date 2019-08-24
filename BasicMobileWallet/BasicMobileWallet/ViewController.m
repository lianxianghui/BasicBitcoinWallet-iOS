//
//  ViewController.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "ViewController.h"
#import "LXHWelcomeViewController.h"
#import "LXHWallet.h"
#import "LXHTabBarPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *controller = nil;
    if ([[LXHWallet sharedInstance] walletDataGenerated]) {
        controller = [LXHTabBarPageViewController new];
    } else {
        controller = [LXHWelcomeViewController new];
    }
    [self pushViewController:controller animated:NO];
}


@end
