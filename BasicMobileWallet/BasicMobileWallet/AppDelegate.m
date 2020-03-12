//
//  AppDelegate.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "AppDelegate.h"
#import "LXHWallet.h"
#import "LXHValidatePINViewController.h"
#import "LXHMaskViewController.h"
#import "LXHTabBarPageViewController.h"
#import "LXHTabBarPageViewModel.h"
#import "LXHWelcomeViewController.h"
#import "LXHValidatePINViewController.h"
#import "LXHMaskViewController.h"
#import "LXHWallet.h"

@interface AppDelegate ()
@property UIViewController *rootViewController;
@end

@implementation AppDelegate

#pragma mark -- default events

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [LXHPreference sharedInstance];//init default preference
    //application.statusBarStyle = UIStatusBarStyleLightContent;
    //disable cache for privacy
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self appLaunchedLogicForViewController];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self appWillResignActiveLogicForViewController];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self appDidBecomeActiveLogicForViewController];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- 界面流程相关的自定义事件处理方法

- (void)appLaunchedLogicForViewController {
    //先注册rootViewController加载完成的逻辑，以便接下来必要的流程（目前是判断是否要显示验证PIN码的ViewController)
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(rootViewControllerLoadedForPINValidation:) name:LXHRootControllerLoaded object:nil];
    
    //执行进入rootViewController的流程
    [self enterRootViewController];
}

- (void)rootViewControllerLoadedForPINValidation:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter removeObserver:self name:LXHRootControllerLoaded object:nil];
    //如果是当前rootViewContrller就进入显示验证PIN码的ViewController的流程
    if (notification.object == [AppDelegate currentRootViewController]) {
        [self presentPINValidationViewControllerIfNeeded];
    }
}

//App离开活动状态（进入后台等情况）
- (void)appWillResignActiveLogicForViewController {
    //为了隐私
    //进入后台时，ios系统会截屏，这里在截屏前先把原有的界面挡住(防止敏感信息被截屏，进而泄露出去)
    //如果当前设置了PIN码，进入PIN码验证页面（从后台返回时需要先输入PIN码），如果没设置PIN码就只显示一个遮挡页面
    if ([LXHWallet hasPIN]) {
        [self presentPINValidationViewController];
    } else {
        [self presentMaskViewController];
    }
}

//App恢复为活动状态
- (void)appDidBecomeActiveLogicForViewController {
    //如果是Mask, dismiss
    UIViewController *rootViewController = [AppDelegate currentRootViewController];
    if ([rootViewController.presentedViewController isMemberOfClass:[LXHMaskViewController class]]) {
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark -- 显示界面逻辑

- (void)enterRootViewController {
    BOOL walletDataInitialized = [LXHWallet walletDataGenerated];
    if (!walletDataInitialized) {
        UIViewController *welcomeController = [[LXHWelcomeViewController alloc] init];//Welcome page for init wallet data
        self.rootViewController = [[UINavigationController alloc] initWithRootViewController:welcomeController];
    } else {
        LXHTabBarPageViewModel *viewModel = [[LXHTabBarPageViewModel alloc] init];
        self.rootViewController = [[LXHTabBarPageViewController alloc] initWithViewModel:viewModel];
    }
    
    self.window = self.window ? : [[UIWindow alloc] init];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
}

- (void)presentPINValidationViewControllerIfNeeded {
    BOOL hasPIN = [LXHWallet hasPIN];
    if (hasPIN) {// && _showValidatePINViewControllerIfNeeded) {//需要输入PIN码
        [self presentPINValidationViewController];
    }
}

- (void)presentPINValidationViewController {
    if ([AppDelegate pinValidationViewControllerPresented])
        return;
    __weak UIViewController *rootViewController = [AppDelegate currentRootViewController];
    UIViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        //验证成功, dismiss
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:validatePINViewController];
    [rootViewController presentViewController:navigationController animated:NO completion:nil];
}

- (void)presentMaskViewController {
    LXHMaskViewController *controller = [[LXHMaskViewController alloc] init];
    UIViewController *rootViewController = [AppDelegate currentRootViewController];
    [rootViewController presentViewController:controller animated:NO completion:nil];
}

#pragma mark -- tool methods

+ (void)reEnterRootViewController {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    [appDelegate enterRootViewController];
}

+ (UIViewController *)currentRootViewController {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    return appDelegate.rootViewController;
}

+ (BOOL)pinValidationViewControllerPresented {
    UIViewController *presentedViewController = [AppDelegate currentRootViewController].presentedViewController;
    if ([presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)presentedViewController;
        if (navigationController.viewControllers.count >= 1) {
            if ([navigationController.viewControllers[0] isMemberOfClass:[LXHValidatePINViewController class]])
                return YES;
        }
    }
    return NO;
}

@end
