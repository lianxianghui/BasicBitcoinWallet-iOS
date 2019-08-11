// LXHSetPinViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSetPinViewController.h"
#import "Masonry.h"
#import "LXHSetPinView.h"
#import "UIViewController+LXHAlert.h"
#import "LXHKeychainStore.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSetPinViewController() <UITextFieldDelegate>

@property (nonatomic) LXHSetPinView *contentView;

@end

@implementation LXHSetPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSetPinView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.textButton addTarget:self action:@selector(textButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton addTarget:self action:@selector(textButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.textButton addTarget:self action:@selector(textButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
    self.contentView.inputPinTextFieldWithPlaceHolder.delegate = self;
    self.contentView.inputPinAgainTextFieldWithPlaceHolder.delegate = self;
}

//Actions
- (void)textButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    NSString *pin = self.contentView.inputPinTextFieldWithPlaceHolder.text;
    if (self.contentView.inputPinTextFieldWithPlaceHolder.text.length != 6 || self.contentView.inputPinAgainTextFieldWithPlaceHolder.text.length != 6) {
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"请确保输入六位数字", nil) handler:nil];
        return;
    } 
    if (![self.contentView.inputPinAgainTextFieldWithPlaceHolder.text isEqualToString:self.contentView.inputPinTextFieldWithPlaceHolder.text]) {
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"请确保两次输入的数字一致", nil) handler:nil];
        return;
    }
    [LXHKeychainStore.sharedInstence savePin:pin];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)textButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

//Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 6;
}


@end
