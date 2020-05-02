//
//  LXHOutputListViewModelForFixedInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/4.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModelForFixedInput.h"
#import "LXHFeeCalculator.h"
#import "LXHTransactionOutput.h"
#import "LXHAddOutputViewModel.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"

@interface LXHOutputListViewModelForFixedInput ()
@property (nonatomic) LXHFeeCalculator *feeCalculator;
@end

@implementation LXHOutputListViewModelForFixedInput

- (NSString *)headerInfoTitle {
    if (self.outputCount == 0)
        return NSLocalizedString(@"允许添加的最大值", nil);
    else
        return NSLocalizedString(@"还允许添加的值", nil);
}

- (NSString *)headerInfoText {
    LXHBTCAmount maxValueForNewOutput = [self maxValueForNewOutput];
    return  [NSString stringWithFormat:@"%@BTC", [NSDecimalNumber decimalBTCValueWithSatValue:maxValueForNewOutput]];
}

- (LXHBTCAmount)maxValueForNewOutput {
    //计算可输入的最大值
    LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:self.inputs];
    LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:self.outputs];
    
    LXHTransactionOutput *output = [LXHTransactionOutput new];
    NSMutableArray *outputs = [self.outputs mutableCopy] ?: [NSMutableArray array];
    [outputs addObject:output];
    LXHBTCAmount estimatedFee = [self.feeCalculator estimatedFeeInSatWithOutputs:outputs];
    
    LXHBTCAmount maxValueOfNewOutput = inputsValueSum - outputsValueSum - estimatedFee;
    return MAX(maxValueOfNewOutput, 0);
}

- (LXHAddOutputViewModel *)getNewOutputViewModel {
    LXHBTCAmount maxValueForNewOutput = [self maxValueForNewOutput];
    if (maxValueForNewOutput > 0) {
        //返回viewModel
        LXHAddOutputViewModel *ret = [LXHAddOutputViewModel new];
        ret.maxValue = [NSDecimalNumber decimalBTCValueWithSatValue:maxValueForNewOutput];
        return ret;
    } else {
        return nil;
    }
}



- (void)refreshViewModelAtIndex:(NSUInteger)index {
    [self refreshViewModeMaxValueAtIndex:index];
}

- (void)refreshViewModeMaxValueAtIndex:(NSUInteger)index {
    if (index < self.outputViewModels.count) {
        LXHAddOutputViewModel *viewModel = self.outputViewModels[index];
        NSDecimalNumber *inputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:self.inputs];
        NSDecimalNumber *estimatedFeeInBTC = [self.feeCalculator estimatedFeeInBTCWithOutputs:self.outputs];
        
        NSMutableArray *otherOutputs = [self.outputs mutableCopy];
        [otherOutputs removeObject:viewModel.output];
        NSDecimalNumber *otherOutputsValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:otherOutputs];

        NSDecimalNumber *maxValueOfCurrentOutput = [[inputsValueSum decimalNumberBySubtracting:estimatedFeeInBTC] decimalNumberBySubtracting:otherOutputsValueSum];
        if ([maxValueOfCurrentOutput compare:[NSDecimalNumber zero]] == NSOrderedAscending)
            maxValueOfCurrentOutput = [NSDecimalNumber zero];
        viewModel.maxValue = maxValueOfCurrentOutput;
    }
}

- (LXHFeeCalculator *)feeCalculator {
    if (!_feeCalculator) {
        _feeCalculator = [LXHFeeCalculator new];
        _feeCalculator.inputs = self.inputs;
        _feeCalculator.feeRateInSat = self.feeRateInSat;
    }
    return _feeCalculator;
}

@end
