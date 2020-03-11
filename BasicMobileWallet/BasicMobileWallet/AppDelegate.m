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
#import "LXHControllerUtils.h"

@interface AppDelegate ()
@property (nonatomic) LXHMaskViewController *maskViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [LXHPreference sharedInstance];//init default preference
    //application.statusBarStyle = UIStatusBarStyleLightContent;
    //disable cache for privacy
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    self.window = self.window ? : [[UIWindow alloc] init];
    self.window.rootViewController = [LXHControllerUtils createRootViewController];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //为了隐私
    //1.进入后台时，ios系统会截屏，这里把原有的界面挡住(防止敏感信息被截屏，进而泄露出去)
    //2.如果当前设置了PIN码，从后台返回时需要先输入PIN码（防止被其他人看到）
    if ([LXHWallet hasPIN])
        [self presentValidatePINViewController];
    else
        [self presentMaskViewController];
}

- (void)presentValidatePINViewController {
    __weak UIViewController *rootViewController = self.window.rootViewController;
    UIViewController *validatePINViewController = [[LXHValidatePINViewController alloc] initWithValidatePINSuccessBlock:^{
        [rootViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    [rootViewController presentViewController:validatePINViewController animated:NO completion:nil];
}

- (void)presentMaskViewController {
    LXHMaskViewController *controller = [[LXHMaskViewController alloc] init];
    [self.window.rootViewController presentViewController:controller animated:NO completion:nil];
    self.maskViewController = controller;
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
    if (self.maskViewController) {//正在显示mask
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        self.maskViewController = nil;
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
