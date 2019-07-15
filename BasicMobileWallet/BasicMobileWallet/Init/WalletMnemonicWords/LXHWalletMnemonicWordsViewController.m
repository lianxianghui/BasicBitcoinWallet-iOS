// LXHWalletMnemonicWordsViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHWalletMnemonicWordsViewController.h"
#import "Masonry.h"
#import "LXHWalletMnemonicWordsView.h"
#import "LXHWalletMnemonicPassphraseViewController.h"
#import "UILabel+LXHText.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHWalletMnemonicWordsViewController()

@property (nonatomic) LXHWalletMnemonicWordsView *contentView;

@end

@implementation LXHWalletMnemonicWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFFFFFF00);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHWalletMnemonicWordsView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setMnemonicWordsText];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.button1 addTarget:self action:@selector(button1TouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.button1 addTarget:self action:@selector(button1TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setMnemonicWordsText {
    NSString *text = [self.words componentsJoinedByString:@" "];
    [self.contentView.text1 updateAttributedTextString:text];
}

//Actions
- (void)button1Clicked:(UIButton *)sender {
    sender.alpha = 1;
    UIViewController *controller = [[LXHWalletMnemonicPassphraseViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES]; 
}

- (void)button1TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)button1TouchUpOutside:(UIButton *)sender {
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
