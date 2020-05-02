//
//  LXHTransactionInputOutputCommon.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInputOutputCommon.h"
#import "BlocksKit.h"
#import "LXHAddress+LXHAccount.h"
#import "LXHGlobalHeader.h"

@implementation LXHTransactionInputOutputCommon
@synthesize address = _address;

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectOfStringClassStament(address);
    [_address refreshLocalProperties];
    LXHDecodeObjectOfDecimalNumberClassStament(valueBTC);
    LXHDecodeObjectOfStringClassStament(txid);
    LXHDecodeUnsignedIntegerTypeStament(index);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(address);
    LXHEncodeObjectStament(valueBTC);
    LXHEncodeObjectStament(txid);
    LXHEncodeIntegerStament(index);
}

- (void)setAddress:(LXHAddress *)address {
    _address = address;
}

+ (NSDecimalNumber *)valueSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs {
    if (inputsOrOutputs.count == 0)
        return [NSDecimalNumber zero];
    else
        return [inputsOrOutputs bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionInputOutputCommon *inputOrOutput) {
            return [sum decimalNumberByAdding:inputOrOutput.valueBTC];
        }];
}

@end
