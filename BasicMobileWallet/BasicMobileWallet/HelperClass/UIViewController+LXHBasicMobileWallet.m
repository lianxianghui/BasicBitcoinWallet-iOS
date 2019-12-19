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
    if ([[LXHKeychainStore sharedInstance].store contains:kLXHKeychainStorePIN]) {
        UIAlertController *pinCodeInput = [UIUtils pinCodeInputAlertWithMessage:nil textBlock:^(NSString *text) {
            if ([[LXHKeychainStore sharedInstance] string:text isEqualToEncryptedStringForKey:kLXHKeychainStorePIN])
                handler();
            else
                [self showOkAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"PIN码不正确", nil) handler:nil];
        }];
        [self presentViewController:pinCodeInput animated:YES completion:nil];
    } else {
        handler();
    }
}

@end
