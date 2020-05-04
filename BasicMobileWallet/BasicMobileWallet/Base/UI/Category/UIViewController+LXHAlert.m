//
//  UIViewController+LXHAlert.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UIViewController+LXHAlert.h"
#import "UIUtils.h"

@implementation UIViewController (LXHAlert)

- (void)showOkAlertViewWithTitle:(NSString *)title message:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alert = [UIUtils okAlertViewWithTitle:title message:message handler:handler];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOkAlertViewWithMessage:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    NSString *title = NSLocalizedString(@"提醒", @"Warning");
    [self showOkAlertViewWithTitle:title message:message handler:handler];
}

- (void)showOkCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    UIAlertController *alert = [UIUtils okCancelAlertViewWithTitle:title message:message okHandler:okHandler cancelHandler:cancelHandler];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOkCancelAlertViewWithMessage:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    NSString *title = NSLocalizedString(@"提醒", @"Warning");
    [self showOkCancelAlertViewWithTitle:title message:message okHandler:okHandler cancelHandler:cancelHandler];
}

- (void)showYesNoAlertViewWithTitle:(NSString *)title message:(NSString *)message yesHandler:(void (^ __nullable)(UIAlertAction *action))yesHandler noHandler:(void (^ __nullable)(UIAlertAction *action))noHandler {
    UIAlertController *alert = [UIUtils yesNoAlertViewWithTitle:title message:message yesHandler:yesHandler noHandler:noHandler];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showYesNoAlertViewWithMmessage:(NSString *)message yesHandler:(void (^ __nullable)(UIAlertAction *action))yesHandler noHandler:(void (^ __nullable)(UIAlertAction *action))noHandler {
    NSString *title = NSLocalizedString(@"提醒", @"Warning");
    [self showYesNoAlertViewWithTitle:title message:message yesHandler:yesHandler noHandler:noHandler];
}



@end
