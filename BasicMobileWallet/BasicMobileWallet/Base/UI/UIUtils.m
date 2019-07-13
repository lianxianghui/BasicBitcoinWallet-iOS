//
//  UIUtils.m
//  
//
//  Created by lianxianghui on 17/12/8.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (UIAlertController *)okAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [self okAlertViewWithTitle:title message:message handler:nil];
}

+ (UIAlertController *)okAlertViewWithTitle:(NSString *)title message:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:okAction]; 
    return alert;
}

@end
