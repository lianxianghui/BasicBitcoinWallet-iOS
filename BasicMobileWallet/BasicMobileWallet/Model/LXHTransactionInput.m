//
//  LXHTransactionInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInput.h"
#import "LXHGlobalHeader.h"

@implementation LXHTransactionInput

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectStament(address);
    LXHDecodeObjectStament(value);
    LXHDecodeObjectStament(txid);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(address);
    LXHEncodeObjectStament(value);
    LXHEncodeObjectStament(txid);
}

@end