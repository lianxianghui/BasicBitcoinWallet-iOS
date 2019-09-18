// LXHShowWalletMnemonicWordsViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-18
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHShowWalletMnemonicWordsViewController.h"
#import "Masonry.h"
#import "LXHShowWalletMnemonicWordsView.h"
#import "LXHWallet.h"
#import "UILabel+LXHText.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHShowWalletMnemonicWordsViewController()
@property (nonatomic) LXHShowWalletMnemonicWordsView *contentView;

@end

@implementation LXHShowWalletMnemonicWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHShowWalletMnemonicWordsView alloc] init];
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
    [self setMnemonicWordsText];
}

- (void)setMnemonicWordsText {
    NSArray *mnemonicCodeWords = [LXHWallet mnemonicCodeWordsWithErrorPointer:nil];
    NSString *text = [mnemonicCodeWords componentsJoinedByString:@" "];
    if (text)
        [self.contentView.text updateAttributedTextString:text];
    else
        [self.contentView.text updateAttributedTextString:@""];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

@end
