//
//  AppDelegate.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (UIViewController *)currentRootViewController;
@end

