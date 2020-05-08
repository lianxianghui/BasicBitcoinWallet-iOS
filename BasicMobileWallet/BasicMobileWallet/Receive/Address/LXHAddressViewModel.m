//
//  LXHAddressViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2020/4/29.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAddressViewModel.h"
#import "LXHWallet.h"

@interface LXHAddressViewModel()

@end

@implementation LXHAddressViewModel

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSString *)navigationBarTitle {
    return @"地址二维码";
}

- (BOOL)leftButtonHidden {
    return NO;
}

- (NSString *)addressText {
    LXHLocalAddressType type = [_data[@"addressType"] integerValue];
    uint32_t index = [_data[@"addressIndex"] unsignedIntValue];
    NSString *address = [[LXHWallet mainAccount] addressWithType:type index:index];
    return address;
}

- (NSString *)path {
    uint32_t index = [_data[@"addressIndex"] unsignedIntValue];
    LXHLocalAddressType type = [_data[@"addressType"] integerValue];
    NSString *path = [[LXHWallet mainAccount] addressPathWithType:type index:index];
    return path;
}

- (void)refreshData {
    
}


@end
