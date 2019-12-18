//
//  LXHQRCodeAndTextViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHQRCodeAndTextViewModel.h"
#import "BTCQRCode.h"

@interface LXHQRCodeAndTextViewModel ()
@property (nonatomic) NSString *string;
@property (nonatomic) UIImage *image;
@end

@implementation LXHQRCodeAndTextViewModel

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
        _showText = YES;
    }
    return self;
}

- (NSString *)text {
    return _string;
}

- (UIImage *)image {
    if (!_image) {
        CGSize imageSize = {280, 280};
        _image = [BTCQRCode imageForString:_string size:imageSize scale:1];
    }
    return _image;
}
@end
