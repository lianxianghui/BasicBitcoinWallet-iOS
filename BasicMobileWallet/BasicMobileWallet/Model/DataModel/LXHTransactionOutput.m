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
#import "LXHAddress.h"

@implementation LXHTransactionOutput

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectOfStringClassStament(lockingScript);
    LXHDecodeObjectOfStringClassStament(lockingScriptHex);
    LXHDecodeIntegerTypeStament(scriptType);
//    LXHDecodeObjectOfStringClassStament(spendTxid);
    LXHDecodeBOOLTypeStament(spent);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    LXHEncodeObjectStament(lockingScript);
    LXHEncodeObjectStament(lockingScriptHex);
    LXHEncodeIntegerStament(scriptType);
    LXHEncodeBOOLStament(spent);
//    LXHEncodeObjectStament(spendTxid);
}

- (BOOL)isUnspent {
    return !_spent;
}

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    if (![object isMemberOfClass:[LXHTransactionOutput class]])
        return NO;
    LXHTransactionOutput *output = (LXHTransactionOutput *)object;
    if (![self.txid isEqualToString:output.txid])
        return NO;
    if (self.index != output.index)
         return NO;
    if (![self.lockingScript isEqualToString:output.lockingScript])
        return NO;
    return YES;
}

- (NSMutableDictionary *)tempData {
    if (!_tempData)
        _tempData = [NSMutableDictionary dictionary];
    return _tempData;
}

+ (NSDecimalNumber *)valueSumOfOutputs:(NSArray<LXHTransactionOutput *> *)outputs {
    return [super valueSumOfInputsOrOutputs:outputs];
}



@end
