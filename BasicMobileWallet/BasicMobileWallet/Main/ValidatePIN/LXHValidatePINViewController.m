// LXHValidatePINViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-01-11
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHValidatePINViewController.h"
#import "Masonry.h"
#import "LXHValidatePINView.h"
#import "UIViewController+LXHBasicMobileWallet.h"
#import "UIUtils.h"
#import "UIViewController+LXHAlert.h"
#import "LXHWallet.h"
#import "LXHKeychainStore.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHValidatePINViewController()
@property (nonatomic) LXHValidatePINView *contentView;

@end

@implementation LXHValidatePINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHValidatePINView alloc] init];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showValidatePINOKAlert];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
}

- (void)setDelegates {
}


- (void)showValidatePINOKAlert {
    if ([LXHWallet hasPIN]) {
         __weak typeof(self) weakSelf = self;
        UIAlertController *pinCodeInput = [UIUtils pinCodeInputOKAlertWithMessage:nil textBlock:^(NSString *text) {
            if ([[LXHKeychainStore sharedInstance] string:text isEqualToEncryptedStringForKey:kLXHKeychainStorePIN])
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            else
                [self showOkAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"PIN码不正确", nil) handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf showValidatePINOKAlert];
                }];
        }];
        [self presentViewController:pinCodeInput animated:YES completion:nil];
    }
}

@end
