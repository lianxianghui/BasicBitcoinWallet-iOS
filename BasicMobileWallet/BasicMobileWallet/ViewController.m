//
//  ViewController.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "ViewController.h"
#import "LXHWelcomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LXHWelcomeViewController *controller = [LXHWelcomeViewController new];
    [self pushViewController:controller animated:NO];
}


@end
