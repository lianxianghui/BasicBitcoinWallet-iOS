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

- (void)showOkCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    UIAlertController *alert = [UIUtils okCancelAlertViewWithTitle:title message:message okHandler:okHandler cancelHandler:cancelHandler];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
