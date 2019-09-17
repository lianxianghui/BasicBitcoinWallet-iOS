// LXHAddressViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddressViewController.h"
#import "Masonry.h"
#import "BTCQRCode.h"
#import "LXHWallet.h"
#import "UILabel+LXHText.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]

@interface LXHAddressViewController()
@property (nonatomic) NSDictionary *data;
@end

@implementation LXHAddressViewController

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

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
    [self setViewData];
    [self addActions];
    [self setDelegates];
}

- (void)setViewData {
    LXHAddressType type = [_data[@"addressType"] integerValue];
    NSInteger index = [_data[@"addressIndex"] integerValue];
    
    NSString *address = [[LXHWallet mainAccount] addressWithType:type index:index];
    [self.contentView.addressText updateAttributedTextString:address];
    
    CGSize imageSize = {198, 198};
    UIImage *qrImage = [BTCQRCode imageForString:address size:imageSize scale:1];
    self.contentView.qrImage.image = qrImage;
    
    NSString *path = [[LXHWallet mainAccount] addressPathWithType:type index:index];
    [self.contentView.addressPath updateAttributedTextString:path];
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
