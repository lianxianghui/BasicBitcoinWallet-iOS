//
//  LXHSelectInputViewModelForFixedOutputs.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/29.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectInputViewModelForFixedOutput.h"
#import "LXHFeeCalculator.h"
#import "NSArray+Base.h"
#import "LXHTransactionDataManager.h"
#import "BlocksKit.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"

@implementation LXHSelectInputViewModelForFixedOutput

- (BOOL)allUtxosIsNotEnough {
    //todo 校验LXHBTCAmountError
    NSArray *allUsableUtxos = [self allUsableUtxos];
    _feeCalculator.inputs = allUsableUtxos;
    LXHBTCAmount estimatedFee = [_feeCalculator estimatedFeeInSat];
    LXHBTCAmount sumOfOutputsAndFee = _fixedOutputValueSum + estimatedFee;
    LXHBTCAmount allUtxosSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:allUsableUtxos];
    return allUtxosSum < sumOfOutputsAndFee;
}

- (LXHTransactionOutput *)utxoOfMinFeeForNextSelection {
    NSArray *allUsableUtxos =  [self allUsableUtxos];
    NSArray *unSelectedUtxos = [allUsableUtxos minusWithArray:self.selectedUtxos];
    LXHTransactionOutput *ret = [self utxoWithMinFeeInArray:unSelectedUtxos];
    return ret;
}

- (LXHBTCAmount)minFeeForNextSelection {
    LXHTransactionOutput *utxoOfMinFeeForNextSelection = [self utxoOfMinFeeForNextSelection];
    NSMutableArray *array = [self.selectedUtxos mutableCopy] ?: [NSMutableArray array];
    if (utxoOfMinFeeForNextSelection) {
        [array addObject:utxoOfMinFeeForNextSelection];
    }
    _feeCalculator.inputs = array;
    LXHBTCAmount estimatedFee = [_feeCalculator estimatedFeeInSat];
    return estimatedFee;
}

//从array里返回一个带来最小手续费的UTXO
- (LXHTransactionOutput *)utxoWithMinFeeInArray:(NSArray *)array {
    //目前所有的都一样，所以就随便选一个
    if (array.count > 0)
        return array[0];
    else
        return nil;
}

- (LXHBTCAmount)minNeedValueForFutherSelection {
    LXHBTCAmount minFeeForNextSelection = [self minFeeForNextSelection];
    LXHBTCAmount sumOfOutputsAndFee = _fixedOutputValueSum + minFeeForNextSelection;
    LXHBTCAmount seletedInputValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:self.selectedUtxos];
    return sumOfOutputsAndFee - seletedInputValueSum;
}

//会滤掉那些消耗的Fee比它的值还大的Utxo
- (NSArray *)allUsableUtxos {
    LXHWeakSelf
    NSArray *allUtxos = [[LXHTransactionDataManager sharedInstance] utxosOfAllTransactions];
    NSArray<LXHTransactionOutput *> *allUsableUtxos = [allUtxos bk_reject:^BOOL(LXHTransactionOutput *obj) {//reject 把消耗的Fee比它的值还大的滤掉
        return [weakSelf.feeCalculator feeGreaterThanValueWithInput:obj];
    }];
    return allUsableUtxos;
}

/**
   以下几种情况
   可选择的输入总值小于当前输出与手续费的总值
   至少需要选择总值为  BTC的输入
   至少还需要选择总值为  BTC的输入
   所选总值为  BTC，已满足当前输出
  */
 - (NSString *)infoText {
    if ([self allUtxosIsNotEnough])
        return NSLocalizedString(@"余额不足", nil);//(可选择的输入总和小于所有输出与手续费的总和)
    LXHBTCAmount minNeedValueForFutherSelection = [self minNeedValueForFutherSelection];
    if (minNeedValueForFutherSelection > 0) {
        NSString *format = nil;
        if (self.selectedUtxos.count == 0)
            format = @"至少需要选择总和为 %@BTC的输入";
        else
            format = @"至少还需要选择总和为 %@BTC的输入";
        format = NSLocalizedString(format, nil);
        NSDecimalNumber *btcValue = [NSDecimalNumber decimalBTCValueWithSatValue:minNeedValueForFutherSelection];
        return [NSString stringWithFormat:format, btcValue];
    } else { //小于等于0，说明够了
        NSDecimalNumber *seletedInputValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
        NSString *format = NSLocalizedString(@"所选总和为 %@BTC，已满足输出与手续费", nil);
        return [NSString stringWithFormat:format, seletedInputValueSum];
    }
}


@end
