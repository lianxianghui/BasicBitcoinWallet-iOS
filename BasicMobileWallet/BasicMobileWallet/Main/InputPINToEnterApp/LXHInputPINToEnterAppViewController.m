// LXHInputPINToEnterAppViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-01-11
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHInputPINToEnterAppViewController.h"
#import "Masonry.h"
#import "LXHInputPINToEnterAppView.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

#define PINLength 6
    
@interface LXHInputPINToEnterAppViewController() <UITextFieldDelegate>
@property (nonatomic) LXHInputPINToEnterAppView *contentView;

@end

@implementation LXHInputPINToEnterAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHInputPINToEnterAppView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setViewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.inputPinTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if (textField.text.length == PINLength) {
        
    }
}

- (void)setDelegates {
    self.contentView.inputPinTextField.delegate = self;
}

- (void)setViewProperties {
    self.contentView.inputPinTextField.keyboardType = UIKeyboardTypeNumberPad;
}

//Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= PINLength;
}

@end
