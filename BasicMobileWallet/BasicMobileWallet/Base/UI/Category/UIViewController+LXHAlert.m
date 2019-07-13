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

@end
