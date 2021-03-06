//
//  LXHQRCodeAndTextViewModel.m
//  BasicBitcoinWallet
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
        //以下为几个默认值
        _showText = YES;
        _title = NSLocalizedString(@"二维码", nil);
    }
    return self;
}

- (NSString *)text {
    return _string;
}

- (UIImage *)image {
    if (!_image) {
        CGSize imageSize = {250, 250};
        //这里的字符串转成二进制后，如果大于 2,953 bytes, _image会为nil
        _image = [BTCQRCode imageForString:_string size:imageSize scale:1];
    }
    return _image;
}
@end
