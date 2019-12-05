//
//  LXHQRCodeViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHQRCodeViewModel.h"

@interface LXHQRCodeViewModel ()
@property (nonatomic) NSString *string;
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
    return nil;
}

@end
