// LXHTabBarPageViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTabBarPageViewController.h"
//#import "LXHBalanceViewController.h"
#import "LXHSendViewController.h"
#import "LXHCurrentReceivingAddressViewController.h"
#import "LXHMineViewController.h"
#import "LXHWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHTabBarPageViewController()<UITabBarControllerDelegate>
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

    viewController = [[LXHSendViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_1inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_1inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"发送", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];

    viewController = [LXHCurrentReceivingAddressViewController sharedInstance];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_2inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_2inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"接收", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];

//    viewController = [[LXHBalanceViewController alloc] init];
//    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_unselected_icon"];
//    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_selected_icon"];
//    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"余额", nil) image:itemImage selectedImage:itemSelectedImage];
//    navigationController.tabBarItem = item;
//    [self addChildViewController:navigationController];

    viewController = [[LXHMineViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_4inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_4inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"我的", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];
    self.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *rootViewController = navigationController.viewControllers[0];
    if (rootViewController == [LXHCurrentReceivingAddressViewController sharedInstance]) { //refresh current receiving address
        //TODO 暂时留着 [[LXHCurrentReceivingAddressViewController sharedInstance] refreshViewWithCurrentReceivingAddress];
    }
    return YES;
}

@end
