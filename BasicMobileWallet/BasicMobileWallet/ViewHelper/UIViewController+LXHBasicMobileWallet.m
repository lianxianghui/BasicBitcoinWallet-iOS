//
//  UIViewController+LXHBasicMobileWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UIViewController+LXHBasicMobileWallet.h"
#import "LXHKeychainStore.h"
#import "LXHWallet.h"
#import "UIUtils.h"
#import "UIViewController+LXHAlert.h"

@implementation UIViewController (LXHBasicMobileWallet)

- (void)validatePINWithPassedHandler:(void (^)(void))handler {
    if ([LXHWallet hasPIN]) {
        UIAlertController *pinCodeInput = [UIUtils pinCodeInputOKCancelAlertWithMessage:nil textBlock:^(NSString *text) {
            if (text && [LXHWallet verifyPIN:text])
                handler();
            else
                [self showOkAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"PIN码不正确", nil) handler:nil];
        }];
        [self presentViewController:pinCodeInput animated:YES completion:nil];
    } else {//不需要验证，直接执行
        handler();
    }
}

@end
