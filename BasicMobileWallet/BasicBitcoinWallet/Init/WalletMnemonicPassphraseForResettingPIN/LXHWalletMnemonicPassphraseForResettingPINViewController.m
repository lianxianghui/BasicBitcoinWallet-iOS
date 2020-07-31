// LXHWalletMnemonicPassphraseForResettingPINViewController.m
// BasicWallet
//
//  Created by lianxianghui on 20-03-6
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import "LXHWalletMnemonicPassphraseForResettingPINViewController.h"
#import "Masonry.h"
#import "LXHWalletMnemonicPassphraseForResettingPINView.h"
#import "LXHSetPassphraseViewController.h"
#import "LXHWalletMnemonicPassphraseForResettingPINViewModel.h"
#import "LXHSetPinViewController.h"
#import "UIViewController+LXHAlert.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicPassphraseForResettingPINViewController()
@property (nonatomic) LXHWalletMnemonicPassphraseForResettingPINView *contentView;
@property (nonatomic) LXHWalletMnemonicPassphraseForResettingPINViewModel *viewModel;
@end

@implementation LXHWalletMnemonicPassphraseForResettingPINViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHWalletMnemonicPassphraseForResettingPINView alloc] init];
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
    [self.contentView.button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)button2Clicked:(UIButton *)sender {
    if ([_viewModel isCurrentMnemonicWords]) {
        UIViewController *controller = [[LXHSetPinViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self showOkAlertViewWithTitle:NSLocalizedString(@"提醒", @"Warning") message:NSLocalizedString(@"您所输入的助记词有误，或者您选择的重置PIN码方式不对。", nil) handler:nil];
    }
}


- (void)button1Clicked:(UIButton *)sender {
    id viewModel = [_viewModel viewModelOfSetPassphrasePage];
    UIViewController *controller = [[LXHSetPassphraseViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
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
