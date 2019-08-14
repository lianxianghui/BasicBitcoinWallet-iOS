//
//  UIUtils.h
//  
//
//  Created by lianxianghui on 17/12/8.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (UIAlertController *)okAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (UIAlertController *)okAlertViewWithTitle:(NSString *)title message:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler;
+ (UIAlertController *)okCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

@end
