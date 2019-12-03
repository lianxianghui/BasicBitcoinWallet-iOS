//
//  LXHAddress+LXHAccount.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/3.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddress+LXHAccount.h"
#import "LXHWallet.h"

@implementation LXHAddress (LXHAccount)

+ (LXHAddress *)addressWithBase58String:(NSString *)base58String;{
    LXHAddress *address = [LXHWallet.mainAccount localAddressWithBase58Address:base58String];
    if (address) {
        return address;
    } else {
        LXHAddress *address = [LXHAddress new];
        address.base58String = base58String;
        return address;
    }
}

- (void)refreshLocalProperties {
    LXHAddress *address = [LXHAddress addressWithBase58String:self.base58String];
    if (address.isLocalAddress) {
        self.isLocalAddress = YES;
        self.localAddressUsed = address.localAddressUsed;
        self.localAddressPath = address.localAddressPath;
        self.localAddressType = address.localAddressType;
    }
}

@end
