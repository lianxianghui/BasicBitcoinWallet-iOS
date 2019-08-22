// LXHAddressViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddressViewController.h"
#import "Masonry.h"
#import "LXHWallet+MainWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHAddressViewController()
@end

@implementation LXHAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHAddressView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    [self addActions];
    [self setDelegates];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setViewData];
}

- (void)setViewData {
    
}

- (void)addActions {
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.shareButton addTarget:self action:@selector(shareButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.copyButton addTarget:self action:@selector(copyButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
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

@end
