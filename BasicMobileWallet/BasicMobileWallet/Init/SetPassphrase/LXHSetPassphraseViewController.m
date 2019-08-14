// LXHSetPassphraseViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSetPassphraseViewController.h"
#import "Masonry.h"
#import "LXHSetPassphraseView.h"
#import "LXHTabBarPageViewController.h"
#import "UILabel+LXHText.h"
#import "UIViewController+LXHAlert.h"
#import "UIViewController+LXHSaveMnemonicAndSeed.h"
#import "NSString+Base.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSetPassphraseViewController()<UITextFieldDelegate>

@property (nonatomic) LXHSetPassphraseView *contentView;

@end

@implementation LXHSetPassphraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHSetPassphraseView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setViewProperties];
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

- (void)setViewProperties {
    self.contentView.inputTextFieldWithPlaceHolder.secureTextEntry = YES;
    self.contentView.inputAgainTextFieldWithPlaceHolder.secureTextEntry = YES;
    if (self.type == LXHSetPassphraseViewControllerForRestoring)
        [self setViewPropertiesForRestoring];
}

- (void)setViewPropertiesForRestoring {
    [self.contentView.title updateAttributedTextString:NSLocalizedString(@"输入助记词密码", nil)];
    [self.contentView.promot updateAttributedTextString:NSLocalizedString(@"请输入助记词密码", nil)];
}

- (void)setDelegates {
    self.contentView.inputTextFieldWithPlaceHolder.delegate = self;
    self.contentView.inputAgainTextFieldWithPlaceHolder.delegate = self;
}

//Actions
- (void)textButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    if (![self.contentView.inputAgainTextFieldWithPlaceHolder.text isEqualToString:self.contentView.inputTextFieldWithPlaceHolder.text]) {
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"请确保两次输入的密码一致", nil) handler:nil];
        return;
    }
    NSString *passphrase = self.contentView.inputAgainTextFieldWithPlaceHolder.text;
    if (![passphrase isEqualToString:[passphrase stringByEliminatingWhiteSpace]]) {
        [self showOkCancelAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"密码含有空白字符，这是您的本意吗，您确定要使用包含空白字符的密码吗？", nil) okHandler:^(UIAlertAction * _Nonnull action) {
            [self saveToKeychainWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];
        } cancelHandler:nil];
    } else {
        [self saveToKeychainWithMnemonicCodeWords:self.words mnemonicPassphrase:passphrase];     
    }
    
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

@end
