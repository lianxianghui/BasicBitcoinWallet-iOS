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
    self = [super init];
    if (!self) {
        return nil;
    }
    self.address = [decoder decodeObjectOfClass:[LXHAddress class] forKey:@"address"];
    LXHDecodeObjectOfStringClassStament(address);
    LXHDecodeObjectOfDecimalNumberClassStament(value);
    LXHDecodeObjectOfStringClassStament(lockingScript);
    LXHDecodeObjectOfStringClassStament(lockingScriptHex);
    LXHDecodeIntegerTypeStament(scriptType);
    LXHDecodeObjectOfStringClassStament(spendTxid);
    LXHDecodeObjectOfStringClassStament(txid);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(address);
    LXHEncodeObjectStament(value);
    LXHEncodeObjectStament(lockingScript);
    LXHEncodeObjectStament(lockingScriptHex);
    LXHEncodeIntegerStament(scriptType);
    LXHEncodeObjectStament(spendTxid);
    LXHEncodeObjectStament(txid);
}

- (BOOL)isUnspent {
    return _spendTxid == nil;
}

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    if (![object isMemberOfClass:[LXHTransactionOutput class]])
        return NO;
    LXHTransactionOutput *output = (LXHTransactionOutput *)object;
    return [self.lockingScript isEqualToString:output.lockingScript];
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
