//
//  LXHFeeUtils.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeUtils.h"


@implementation LXHFeeUtils

//参考 https://bitcoin.stackexchange.com/questions/1195/how-to-calculate-transaction-size-before-sending-legacy-non-segwit-p2pkh-p2sh
+ (unsigned long long)esmitatedFeeInSatWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount  {
    NSUInteger byteCount = inputCount * 148 + outputCount * 34 + 10;//目前不支持隔离见证输入输出
    unsigned long long esmitatedFeeInSat = byteCount * feeRateInSat;
    return esmitatedFeeInSat;
}

+ (NSDecimalNumber *)esmitatedFeeInBTCWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount {
    unsigned long long esmitatedFeeInSat = [self esmitatedFeeInSatWithFeeRate:feeRateInSat inputCount:inputCount outputCount:outputCount];
    NSDecimalNumber *ret = [NSDecimalNumber decimalNumberWithMantissa:esmitatedFeeInSat exponent:-8 isNegative:NO];
    return ret;
}

+ (NSDecimalNumber *)differenceBetweenInputs:(NSArray<LXHTransactionInputOutputCommon *> *)inputs outputs:(NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    NSDecimalNumber *inputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:inputs];
    NSDecimalNumber *outputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:outputs];
    return [inputsValueSum decimalNumberBySubtracting:outputsValueSum];
}



@end
