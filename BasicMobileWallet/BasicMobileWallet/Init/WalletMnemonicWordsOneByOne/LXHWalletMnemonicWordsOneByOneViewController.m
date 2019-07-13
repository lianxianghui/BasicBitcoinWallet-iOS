// LXHWalletMnemonicWordsOneByOneViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHWalletMnemonicWordsOneByOneViewController.h"
#import "Masonry.h"
#import "LXHWalletMnemonicWordsOneByOneView.h"
#import "LXHWalletMnemonicWordsViewController.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicWordsOneByOneViewController()

@property (nonatomic) LXHWalletMnemonicWordsOneByOneView *contentView;

@end

@implementation LXHWalletMnemonicWordsOneByOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHWalletMnemonicWordsOneByOneView alloc] init];
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
    [self.contentView.textButton2 addTarget:self action:@selector(textButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.textButton1 addTarget:self action:@selector(textButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)textButton2Clicked:(UIButton *)sender {
    UIViewController *controller = [[LXHWalletMnemonicWordsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES]; 
}


- (void)textButton1Clicked:(UIButton *)sender {
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
