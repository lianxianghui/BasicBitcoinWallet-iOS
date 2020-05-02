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

@interface LXHTransactionInputOutputCommon ()
@property (nonatomic, readwrite) LXHBTCAmount valueSat;
@end

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

- (void)setValueBTC:(NSDecimalNumber *)valueBTC {
    _valueSat = [[valueBTC decimalNumberByMultiplyingByPowerOf10:8] longLongValue];//todo 关注一下 Starting iOS 8.0.2, the longLongValue method returns 0 for some non rounded values.
    if (_valueSat >= LXHBTC_MAX_MONEY) {
        _valueSat = -1;
        _valueBTC = nil;
    } else {
        _valueBTC = valueBTC;
    }

}

- (LXHBTCAmount)valueSat {
    return _valueSat;
}

+ (NSDecimalNumber *)valueSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs {
    LXHBTCAmount valueSatSum = [self valueSatSumOfInputsOrOutputs:inputsOrOutputs];
    if (valueSatSum != LXHBTCAmountError)
        return [NSDecimalNumber decimalNumberWithMantissa:valueSatSum exponent:-8 isNegative:NO];
    else
        return nil;
}

+ (LXHBTCAmount)valueSatSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs {
    LXHBTCAmount ret = 0;
    for (LXHTransactionInputOutputCommon *inputOrOutput in inputsOrOutputs) {
        ret += inputOrOutput.valueSat;
        if (ret >= LXHBTC_MAX_MONEY)
            return LXHBTCAmountError;
    }
    return ret;
}

@end
