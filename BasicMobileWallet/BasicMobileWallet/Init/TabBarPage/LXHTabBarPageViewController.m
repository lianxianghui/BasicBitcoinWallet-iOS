// LXHTabBarPageViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTabBarPageViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHTabBarPageViewController()
@end

@implementation LXHTabBarPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBar.barTintColor = UIColorFromRGBA(0xFAFAFAE5);
    self.tabBar.tintColor = UIColorFromRGBA(0x0076FFFF);
    self.tabBar.unselectedItemTintColor = UIColorFromRGBA(0xA4AAB3FF);
    UITabBarItem *item = nil;
    UIImage *itemImage = nil;
    UIImage *itemSelectedImage = nil;
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;





}


@end
