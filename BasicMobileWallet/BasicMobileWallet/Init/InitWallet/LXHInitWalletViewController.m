// LXHInitWalletViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInitWalletViewController.h"
#import "Masonry.h"
#import "LXHInitWalletView.h"
#import "LXHScanQRViewController.h"
#import "LXHSelectMnemonicWordLengthViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHInitWalletViewController()
@property (nonatomic) LXHInitWalletView *contentView;

@end

@implementation LXHInitWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHInitWalletView alloc] init];
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
    [self.contentView.importWatchOnlyWalletButton addTarget:self action:@selector(importWatchOnlyWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.restoreWalletButton addTarget:self action:@selector(restoreWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.createWalletButton addTarget:self action:@selector(createWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)importWatchOnlyWalletButtonClicked:(UIButton *)sender {
    UIViewController *controller = [[LXHScanQRViewController alloc] initWithDetectionBlock:^(NSString *message) {
        
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}


- (void)restoreWalletButtonClicked:(UIButton *)sender {
    LXHSelectMnemonicWordLengthViewController *controller = [LXHSelectMnemonicWordLengthViewController new];
    controller.type = LXHSelectMnemonicWordLengthViewControllerTypeForRestoringExistingWallet;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createWalletButtonClicked:(UIButton *)sender {
    LXHSelectMnemonicWordLengthViewController *controller = [LXHSelectMnemonicWordLengthViewController new];
    controller.type = LXHSelectMnemonicWordLengthViewControllerTypeForCreatingNewWallet;
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
