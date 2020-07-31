//
//  LXHTransactionInputOutputCommon.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/11/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInputOutputCommon.h"
#import "BlocksKit.h"
#import "LXHAddress+LXHAccount.h"
#import "LXHGlobalHeader.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "LXHAmount.h"

@interface LXHTransactionInputOutputCommon ()
//@property (nonatomic, readwrite) LXHBTCAmount valueSat;
@end

@implementation LXHTransactionInputOutputCommon
@synthesize address = _address, valueSat = _valueSat;

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
    NSDecimalNumber *valueSat = [valueBTC decimalNumberByMultiplyingByPowerOf10:8];
    if ([LXHAmount isValidWithDecimalValue:valueSat]) {
        _valueSat = [valueSat longLongValue];
        _valueBTC = valueBTC;
    } else {
        _valueSat = LXHBTCAmountError;
        _valueBTC = nil;
    }
}

- (void)setValueSat:(LXHBTCAmount)valueSat {
    NSDecimalNumber *valueBTC = [NSDecimalNumber decimalBTCValueWithSatValue:valueSat];
    [self setValueBTC:valueBTC];
}

- (LXHBTCAmount)valueSat {
    return _valueSat;
}

+ (NSDecimalNumber *)valueSumOfInputsOrOutputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputsOrOutputs {
    LXHBTCAmount valueSatSum = [self valueSatSumOfInputsOrOutputs:inputsOrOutputs];
    if (valueSatSum != LXHBTCAmountError)
        return [NSDecimalNumber decimalBTCValueWithSatValue:valueSatSum];
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
