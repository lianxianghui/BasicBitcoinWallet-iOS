//
//  UIViewController+LXHAlert.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LXHAlert)

- (void)showOkAlertViewWithMessage:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler;
- (void)showOkCancelAlertViewWithMessage:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

- (void)showOkAlertViewWithTitle:(NSString *)title message:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)showOkCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

- (void)showYesNoAlertViewWithMmessage:(NSString *)message yesHandler:(void (^ __nullable)(UIAlertAction *action))yesHandler noHandler:(void (^ __nullable)(UIAlertAction *action))noHandler;
@end

NS_ASSUME_NONNULL_END
