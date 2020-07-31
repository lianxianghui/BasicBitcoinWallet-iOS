//
//  AppDelegate.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LXHRootControllerAppear @"LXHRootControllerAppear"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)reEnterRootViewController;
+ (UIViewController *)currentRootViewController;
+ (BOOL)pinValidationViewControllerPresented;
@end

