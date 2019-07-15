// LXHInitWalletViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHInitWalletViewController.h"
#import "Masonry.h"
#import "LXHInitWalletView.h"
#import "LXHInputMnemonicWordsViewController.h"
#import "LXHWalletMnemonicWordsOneByOneViewController.h"
#import "BTCMnemonic.h"
#import "BTCData.h"

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
    [self.contentView.restoreWalletButton addTarget:self action:@selector(restoreWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.createWalletButton addTarget:self action:@selector(createWalletButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)restoreWalletButtonClicked:(UIButton *)sender {
    UIViewController *controller = [[LXHInputMnemonicWordsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES]; 
}


- (void)createWalletButtonClicked:(UIButton *)sender {
    //todo 助记词Entropy用BTCRandomDataWithLength生成是否具有足够的随机性
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithEntropy:BTCRandomDataWithLength(16) password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    LXHWalletMnemonicWordsOneByOneViewController *controller = [[LXHWalletMnemonicWordsOneByOneViewController alloc] init];
    controller.words = mnemonic.words;
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
