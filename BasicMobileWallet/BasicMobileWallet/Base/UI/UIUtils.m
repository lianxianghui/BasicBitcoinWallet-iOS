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

+ (UIAlertController *)okCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:okHandler];
    [alert addAction:okAction]; 
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:cancelHandler];
    [alert addAction:cancelAction]; 
    return alert;
}


+ (UIAlertController *)pinCodeInputOKCancelAlertWithMessage:(NSString *)message textBlock:(void (^)(NSString *text))textBlock {
    
    UIAlertController *pinCodeInput = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入PIN码", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *pinCodeTextField = nil;
    [pinCodeInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"PIN码", nil);
        [textField setSecureTextEntry:YES];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        pinCodeTextField = textField;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        textBlock(pinCodeTextField.text);
    }];
    [pinCodeInput addAction:cancelAction];
    [pinCodeInput addAction:okAction];
    return pinCodeInput;
}

+ (UIAlertController *)pinCodeInputOKAndForgotPINAlertWithMessage:(NSString *)message textBlock:(void (^)(NSString *text))textBlock forgotPINBlock:(void (^)(void))forgotPINBlock {
    
    UIAlertController *pinCodeInput = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入PIN码", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *pinCodeTextField = nil;
    [pinCodeInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"PIN码", nil);
        [textField setSecureTextEntry:YES];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        pinCodeTextField = textField;
    }];
    UIAlertAction *forgotPINAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"我忘记了PIN码", nil)  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        forgotPINBlock();
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        textBlock(pinCodeTextField.text);
    }];
    [pinCodeInput addAction:forgotPINAction];
    [pinCodeInput addAction:okAction];
    return pinCodeInput;
}

+ (UIAlertController *)pinCodeInputOKAlertWithMessage:(NSString *)message textBlock:(void (^)(NSString *text))textBlock {
    UIAlertController *pinCodeInput = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入PIN码", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *pinCodeTextField = nil;
    [pinCodeInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"PIN码", nil);
        [textField setSecureTextEntry:YES];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        pinCodeTextField = textField;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        textBlock(pinCodeTextField.text);
    }];
    [pinCodeInput addAction:okAction];
    return pinCodeInput;
}

@end
