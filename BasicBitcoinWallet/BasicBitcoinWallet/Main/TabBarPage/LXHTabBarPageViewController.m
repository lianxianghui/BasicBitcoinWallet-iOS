// LXHTabBarPageViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTabBarPageViewController.h"
#import "LXHBalanceViewController.h"
#import "LXHAddressViewController.h"
#import "LXHOthersViewController.h"
#import "LXHSelectWayOfSendingBitcoinViewController.h"
#import "AppDelegate.h"

#import "LXHSelectWayOfSendingBitcoinViewModel.h"
#import "LXHOthersViewModel.h"
#import "LXHBalanceViewModel.h"
#import "LXHCurrentReceivingAddressViewModel.h"

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
    //self.tabBar.unselectedItemTintColor = UIColorFromRGBA(0xA4AAB3FF);
    UITabBarItem *item = nil;
    UIImage *itemImage = nil;
    UIImage *itemSelectedImage = nil;
    UIViewController *viewController = nil;
    UINavigationController *navigationController = nil;
    
    id viewModel = [[LXHSelectWayOfSendingBitcoinViewModel alloc] init];
    viewController = [[LXHSelectWayOfSendingBitcoinViewController alloc] initWithViewModel:viewModel];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_1inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_1inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"发送", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];

    viewModel = [[LXHCurrentReceivingAddressViewModel alloc] init];
    viewController = [[LXHAddressViewController alloc] initWithViewModel:viewModel];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_2inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_2inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"接收", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];

    viewModel = [[LXHBalanceViewModel alloc] init];
    viewController = [[LXHBalanceViewController alloc] initWithViewModel:viewModel];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"余额", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];
    
    viewModel = [[LXHOthersViewModel alloc] init];
    viewController = [[LXHOthersViewController alloc] initWithViewModel:viewModel];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_4inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_4inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"其它", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];
    
    self.tabBar.translucent = NO;
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LXHRootControllerAppear object:self];
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    UINavigationController *navigationController = (UINavigationController *)viewController;
//    UIViewController *rootViewController = navigationController.viewControllers[0];
//    if (rootViewController == [LXHCurrentReceivingAddressViewController sharedInstance]) { //refresh current receiving address
//        //TODO 暂时留着 [[LXHCurrentReceivingAddressViewController sharedInstance] refreshViewWithCurrentReceivingAddress];
//    }
//    return YES;
//}

@end
