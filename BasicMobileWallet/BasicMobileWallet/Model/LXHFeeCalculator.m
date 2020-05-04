//
//  LXHFeeEstimator.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/28.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHFeeCalculator.h"
#import "LXHTransactionInputOutputCommon.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"

@implementation LXHFeeCalculator

- (LXHBTCAmount)estimatedFeeInSat {
    return [self estimatedFeeInSatWithOutputs:_outputs];
}

- (LXHBTCAmount)estimatedFeeInSatWithOutputs:(NSArray *)outputs {
    if (_inputs.count == 0 || outputs.count == 0)
        return LXHBTCAmountError;
    return [LXHFeeCalculator estimatedFeeInSatWithFeeRate:_feeRate.value inputCount:_inputs.count outputCount:outputs.count];
}

- (BOOL)feeGreaterThanValueWithInput:(LXHTransactionInputOutputCommon *)input {
    //目前不支持隔离见证输入输出，所以目前与输入无关
    LXHBTCAmount feePerInputInSat = 148 * _feeRate.value;//目前不支持隔离见证输入输出
    return feePerInputInSat > input.valueSat;
}

- (BOOL)feeGreaterThanValueWithOutput:(LXHTransactionInputOutputCommon *)output {
    //目前不支持隔离见证输入输出，所以目前与输出无关
    LXHBTCAmount fee = 34 * _feeRate.value;//目前不支持隔离见证输入输出
    return fee > output.valueSat;
}

//参考 https://bitcoin.stackexchange.com/questions/1195/how-to-calculate-transaction-size-before-sending-legacy-non-segwit-p2pkh-p2sh
+ (LXHBTCAmount)estimatedFeeInSatWithFeeRate:(NSUInteger)feeRateInSat inputCount:(NSUInteger)inputCount outputCount:(NSUInteger)outputCount  {
    NSUInteger byteCount = inputCount * 148 + outputCount * 34 + 10;//目前不支持隔离见证输入输出
    LXHBTCAmount ret = byteCount * feeRateInSat;
    return ret;
}

@end
