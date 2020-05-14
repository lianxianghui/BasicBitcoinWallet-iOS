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
        LXHAddOutputViewModel *ret = [[LXHAddOutputViewModel alloc] init];
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
        LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:self.inputs];
        LXHBTCAmount estimatedFeeInBTC = [self.feeCalculator estimatedFeeInSatWithOutputs:self.outputs];
        
        NSMutableArray *otherOutputs = [self.outputs mutableCopy];
        [otherOutputs removeObject:viewModel.output];
        LXHBTCAmount otherOutputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:otherOutputs];

        LXHBTCAmount maxValueOfCurrentOutput = inputsValueSum - estimatedFeeInBTC - otherOutputsValueSum;
        maxValueOfCurrentOutput = MAX(maxValueOfCurrentOutput, 0);
        viewModel.maxValue = [NSDecimalNumber decimalBTCValueWithSatValue:maxValueOfCurrentOutput];
    }
}

- (LXHFeeCalculator *)feeCalculator {
    if (!_feeCalculator) {
        _feeCalculator = [[LXHFeeCalculator alloc] init];
    }
    _feeCalculator.inputs = self.inputs;
    _feeCalculator.feeRate = self.feeRate;
    return _feeCalculator;
}

@end
