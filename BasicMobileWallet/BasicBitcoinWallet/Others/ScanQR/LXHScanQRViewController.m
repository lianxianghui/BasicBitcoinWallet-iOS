// LXHScanQRViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHScanQRViewController.h"
#import "Masonry.h"
#import "LXHScanQRView.h"
#import "BTCQRCode.h"
#import "LXHGlobalHeader.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHScanQRViewController()
@property (nonatomic) LXHScanQRView *contentView;
@property (nonatomic) UIView *scanerView;
@property (nonatomic) NSString *text;
@property (nonatomic, copy) LXHScanQRViewDetectionBlock detectionBlock;
@end

@implementation LXHScanQRViewController

- (instancetype)initWithDetectionBlock:(LXHScanQRViewDetectionBlock)detectionBlock {
    self = [super init];
    if (self) {
        _detectionBlock = detectionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFA00);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addScanerView];
    self.contentView = [[LXHScanQRView alloc] init];
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

- (void)addScanerView {
    LXHWeakSelf
    self.scanerView = [BTCQRCode scannerViewWithBlock:^(NSString *text) {
        [weakSelf.scanerView removeFromSuperview];
        weakSelf.detectionBlock(text);
    }];
    [self.view addSubview:self.scanerView];;
}

- (void)swipeView:(id)sender {
    [self.scanerView removeFromSuperview];
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
    [self.scanerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

@end
