//
//  LXHQRCodeViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHQRCodeViewModel.h"
#import "BTCQRCode.h"

@interface LXHQRCodeViewModel ()
@property (nonatomic) NSString *string;
@property (nonatomic) UIImage *image;
@end

@implementation LXHQRCodeViewModel

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
    }
    return self;
}

- (UIImage *)image {
    if (!_image) {
        CGSize imageSize = {280, 280};
        _image = [BTCQRCode imageForString:_string size:imageSize scale:1];
    }
    return _image;
}

@end
