// LXHTabBarPageViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHTabBarPageViewController.h"
#import "LXHBalanceViewController.h"
#import "LXHCurrentReceivingAddressViewController.h"
#import "LXHOthersViewController.h"
#import "LXHSelectWayOfSendingBitcoinViewController.h"
#import "LXHTabBarPageViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHTabBarPageViewController()<UITabBarControllerDelegate>
@property (nonatomic) LXHTabBarPageViewModel *viewModel;
@end

@implementation LXHTabBarPageViewController

- (instancetype)initWithViewModel:(id)viewModel {
    //这里比较特殊，因为UITabBarController会在init方法里调用viewDidLoad，而viewDidLoad由需要用到viewModel，
    //所以在[super init]之前设置好_viewModel
    _viewModel = viewModel;
    self = [super init];
    if (self) {
 
    }
    return self;
}

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
    
    id viewModel = [_viewModel selectWayOfSendingBitcoinViewModel];
    viewController = [[LXHSelectWayOfSendingBitcoinViewController alloc] initWithViewModel:viewModel];
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

    viewModel = [_viewModel balanceViewModel];
    viewController = [[LXHBalanceViewController alloc] initWithViewModel:viewModel];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    itemImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_unselected_icon"];
    itemSelectedImage = [UIImage imageNamed:@"main_tabbarpage_item_3inner_selected_icon"];
    item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"余额", nil) image:itemImage selectedImage:itemSelectedImage];
    navigationController.tabBarItem = item;
    [self addChildViewController:navigationController];
    
    viewModel = [_viewModel othersViewModel];
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


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *rootViewController = navigationController.viewControllers[0];
    if (rootViewController == [LXHCurrentReceivingAddressViewController sharedInstance]) { //refresh current receiving address
        //TODO 暂时留着 [[LXHCurrentReceivingAddressViewController sharedInstance] refreshViewWithCurrentReceivingAddress];
    }
    return YES;
}

@end
