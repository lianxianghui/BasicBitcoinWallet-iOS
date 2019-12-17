// LXHQRCodeAndTextViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHQRCodeAndTextViewController.h"
#import "Masonry.h"
#import "LXHQRCodeAndTextView.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHQRCodeAndTextViewController()
@property (nonatomic) LXHQRCodeAndTextView *contentView;

@end

@implementation LXHQRCodeAndTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHQRCodeAndTextView alloc] init];
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
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
}

//Actions
- (void)shareButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)shareButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)shareButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)copyButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)copyButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)copyButtonTouchUpOutside:(UIButton *)sender {
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
