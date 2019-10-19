//
//  LXHTransactionOutput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionOutput.h"
#import "LXHGlobalHeader.h"

@implementation LXHTransactionOutput

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectStament(address);
    LXHDecodeObjectStament(value);
    LXHDecodeObjectStament(spendTxid);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(address);
    LXHEncodeObjectStament(value);
    LXHEncodeObjectStament(spendTxid);
}

- (BOOL)isUnspent {
    return _spendTxid == nil || [_spendTxid isEqual:[NSNull null]];
}

@end
