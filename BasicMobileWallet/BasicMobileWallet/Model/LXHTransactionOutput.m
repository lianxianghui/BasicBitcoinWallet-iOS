//
//  LXHTransactionOutput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionOutput.h"
#import "LXHGlobalHeader.h"
#import "BlocksKit.h"

@implementation LXHTransactionOutput

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectStament(address);
    LXHDecodeObjectStament(value);
    LXHDecodeObjectStament(lockingScript);
    LXHDecodeIntegerTypeStament(scriptType);
    LXHDecodeObjectStament(spendTxid);
    LXHDecodeObjectStament(txid);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(address);
    LXHEncodeObjectStament(value);
    LXHEncodeObjectStament(lockingScript);
    LXHEncodeIntegerStament(scriptType);
    LXHEncodeObjectStament(spendTxid);
    LXHEncodeObjectStament(txid);
}

- (BOOL)isUnspent {
    return _spendTxid == nil || [_spendTxid isEqual:[NSNull null]];
}

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    if (![object isMemberOfClass:[LXHTransactionOutput class]])
        return NO;
    LXHTransactionOutput *output = (LXHTransactionOutput *)object;
    return [self.lockingScript isEqualToString:output.lockingScript];
}

+ (NSDecimalNumber *)valueSumOfOutputs:(NSArray<LXHTransactionOutput *> *)outputs {
    return [outputs bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionOutput *utxo) {
        return [sum decimalNumberByAdding:utxo.value];
    }];
}

@end
