//
//  LXHBuildTransactionViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBuildTransactionViewModel.h"
#import "LXHTransactionInput.h"
#import "LXHTransactionOutput.h"
#import "BlocksKit.h"
#import "LXHSelectInputViewModel.h"
#import "LXHOutputListViewModel.h"
#import "LXHSelectFeeRateViewModel.h"
#import "LXHInputFeeViewModel.h"
#import "LXHAddOutputViewModel.h"
#import "LXHFeeCalculator.h"
#import "LXHWallet.h"
#import "LXHTransactionInfoViewModel.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "LXHFeeRate.h"

@interface LXHBuildTransactionViewModel ()
@property (nonatomic, readwrite) LXHOutputListViewModel *outputListViewModel;
@property (nonatomic, readwrite) LXHSelectFeeRateViewModel *selectFeeRateViewModel;
@property (nonatomic, readwrite) LXHInputFeeViewModel *inputFeeViewModel;
@property (nonatomic, readwrite) LXHFeeRate *feeRate;
@end

@implementation LXHBuildTransactionViewModel

#pragma mark - 加工View数据
//把数据加工成适合View直接使用的形式

- (NSArray *)inputCellDataArray {
    NSMutableArray *ret = [NSMutableArray array];
    NSDictionary *dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输入", @"id":@"selectInput"};
    [ret addObject:dic];
    NSArray *selectedUtxos = _selectInputViewModel.selectedUtxos;
    for (NSUInteger i = 0 ; i < selectedUtxos.count; i++) {
        LXHTransactionOutput *utxo = selectedUtxos[i];
        NSMutableDictionary *mutableDic =  @{@"isSelectable":@"1", @"cellType":@"LXHInputOutputCell"}.mutableCopy;
        mutableDic[@"addressText"] = utxo.address.base58String;
        mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i];
        mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", utxo.valueBTC];
        [ret addObject:mutableDic];
    }
    return ret;
}

- (NSArray *)outputCellDataArray {
    NSMutableArray *ret = [NSMutableArray array];
    NSDictionary *dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输出", @"id":@"selectOutput"};
    [ret addObject:dic];
    NSArray *outputs = [_outputListViewModel outputs];
    for (NSUInteger i = 0 ; i < outputs.count; i++) {
        LXHTransactionOutput *output = outputs[i];
        NSMutableDictionary *mutableDic =  @{@"isSelectable":@"1", @"cellType":@"LXHInputOutputCell"}.mutableCopy;
        mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i]; //index
        
        NSString *address = nil;
        if (output.address.isLocalAddress && output.address.localAddressType == LXHLocalAddressTypeChange)
            address = [NSString stringWithFormat:NSLocalizedString(@"%@(找零)", nil), output.address.base58String];
        else
            address = output.address.base58String;
        mutableDic[@"addressText"] = address;
        
        mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", output.valueBTC];
        [ret addObject:mutableDic];
    }
    return ret;
}

- (NSDictionary *)feeRateCellData {
    //fee rate text
    NSNumber *feeRateValue = [self feeRateValue];
    NSString *feeRateText = nil;
    if (feeRateValue) {
        NSString *feeRateTextFormat = NSLocalizedString(@"手续费率: %@ sat/byte", nil);
        feeRateText = [NSString stringWithFormat:feeRateTextFormat, feeRateValue];
    } else {
        feeRateText = NSLocalizedString(@"请选择或者输入手续费率", nil);
    }
    NSDictionary *dic = @{@"text":feeRateText, @"isSelectable":@"0", @"cellType":@"LXHFeeCell"};
    return dic;
}

- (LXHFeeRate *)feeRate {
    //这个_feeRate因为会在多个类中引用，所以只能创建一次，不要重新生成对象。
    if (!_feeRate)
        _feeRate = [[LXHFeeRate alloc] init];
    [self updateFeeRate];
    return _feeRate;
}

- (void)updateFeeRate {
    NSNumber *feeRateValue = [self feeRateValue];
    if (feeRateValue) {
        _feeRate.value = [feeRateValue longLongValue];
    } else
        _feeRate.value = LXHBTCAmountError;
}

- (NSNumber *)feeRateValue {
    NSNumber *feeRateValue = nil;
    if (self.inputFeeViewModel.inputFeeRateSat)
        feeRateValue = self.inputFeeViewModel.inputFeeRateSat;
    else if (self.selectFeeRateViewModel.selectedFeeRateItem) {
        feeRateValue = self.selectFeeRateViewModel.selectedFeeRateItem.allValues[0];
    } else {
        feeRateValue = nil;
    }
    return feeRateValue;
}

- (NSArray<LXHTransactionInputOutputCommon *> *)inputs { //utxos
    return _selectInputViewModel.selectedUtxos;
}

- (NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    return self.outputListViewModel.outputs;
}

- (LXHBTCAmount)actualFeeValueInSat {
    NSUInteger inputCount = [self inputs].count;
    NSUInteger outputCount = [self outputs].count;
    if (inputCount == 0 || outputCount == 0)
        return LXHBTCAmountError;
    LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self inputs]];
    LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self outputs]];
    LXHBTCAmount fee = inputsValueSum - outputsValueSum;
    if ([LXHFeeRate isValidWithFeeRateValue:fee])
        return fee;
    else
        return LXHBTCAmountError;
}

- (LXHBTCAmount)estimatedFeeValueInSat {
    LXHFeeCalculator *feeCalculator = [[LXHFeeCalculator alloc] init];
    feeCalculator.inputs = [self inputs];
    feeCalculator.feeRate = [self feeRate];
    feeCalculator.outputs = [self outputs];
    LXHBTCAmount estimatedFeeValueSat = [feeCalculator estimatedFeeInSat];//从费率和估计的字节数算出的手续费
    return estimatedFeeValueSat;
}

- (NSDictionary *)titleCell2DataForGroup2 {
    NSString *title = [self titleForFeeCell];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell1"};
    return dic;
}

#pragma mark - for subclass overriding
- (NSArray *)cellDataForListview {
    return nil;
}

- (NSDictionary *)titleCell1DataForGroup1 {
    return nil;
}

- (NSDictionary *)titleCell2DataForGroup3 {
    return nil;
}

- (NSString *)clickSelectInputPrompt {
    return nil;
}

- (NSString *)clickSelectOutputPrompt {
    return nil;
}

- (NSString *)navigationBarTitle {
    return nil;
}

#pragma mark - other related viewModels

- (LXHSelectInputViewModel *)selectInputViewModel {
    return nil;
}

- (LXHOutputListViewModel *)outputListViewModel {
    return nil;
}

- (LXHSelectFeeRateViewModel *)selectFeeRateViewModel {
    if (!_selectFeeRateViewModel)
        _selectFeeRateViewModel = [[LXHSelectFeeRateViewModel alloc] init];
    return _selectFeeRateViewModel;
}

- (void)resetSelectFeeRateViewModel {
    _selectFeeRateViewModel = nil;
    [self updateFeeRate];
}

- (LXHInputFeeViewModel *)inputFeeViewModel {
    if (!_inputFeeViewModel)
        _inputFeeViewModel = [[LXHInputFeeViewModel alloc] init];
    return _inputFeeViewModel;
}

- (LXHTransactionInfoViewModel *)transactionInfoViewModel {
    return [[LXHTransactionInfoViewModel alloc] initWithInputs:self.inputs outputs:self.outputs];
}

- (void)resetInputFeeViewModel {
    _inputFeeViewModel = nil;
    [self updateFeeRate];
}

- (void)addChangeOutputAtRandomPosition {
    LXHTransactionOutput *aNewChangeOutput = [self getANewChangeOutput];
    if (aNewChangeOutput)
        [self.outputListViewModel addNewChangeOutputAtRandomPositionWithOutput:aNewChangeOutput];
}

- (BOOL)hasInputsAndFeeRateAndOutputs {
    return _selectInputViewModel.selectedUtxos.count > 0 && [self feeRateValue] && [self.outputListViewModel outputCount] > 0;
}

- (BOOL)hasChangeOutput {
    return [self.outputListViewModel hasChangeOutput];
}

/**
 当前状态
 输入、输出或费率未正确选择或填写  code -4
 估计的手续费值无效  -5 (正常情况下应该不会出现）
 实际的手续费值无效  -6 (正常情况下应该不会出现）
 输入等于输出：实际手续费与估计的手续费一样，code 0
 输入大于输出：
 1) 实际手续费大于估计的手续费，但是加一个找零又不值得（带来的手续费比其值还大） code 1
 2) 实际手续费过多，有可能造成浪费的情况。 code -1
 3) 实际手续费过少，有可能影响到账时间。 code -2
 输入小于输出 code -3
 @return code
 */
- (NSInteger)currentStatusCode {
    if (_selectInputViewModel.selectedUtxos.count == 0)
        return -4;
    if ([self.outputListViewModel outputCount] == 0)
        return -4;
    if (![self feeRateValue])
        return -4;

    LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self inputs]];
    LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self outputs]];
    if (inputsValueSum < outputsValueSum) {//输入小于输出
        return -3;
    } else {//输入大于等于输出
        LXHBTCAmount estimatedFeeValueInSat = [self estimatedFeeValueInSat];
        LXHBTCAmount actualFeeValueInSat = [self actualFeeValueInSat];
        if (estimatedFeeValueInSat == LXHBTCAmountError)
            return -5;
        if (actualFeeValueInSat == LXHBTCAmountError)
            return -6;
        
        if (actualFeeValueInSat == estimatedFeeValueInSat) {
            return 0;
        } else if (actualFeeValueInSat > estimatedFeeValueInSat) {
            if (![self isWorthToAddChangeOutput])
                return 1;
            else
                return -1;
        } else { //actualFeeValue < estimatedFeeValue
            return -2;
        }
    }
}

- (NSString *)titleForFeeCell {
    NSInteger statusCode = [self currentStatusCode];
    NSString *title = nil;
    LXHBTCAmount estimatedFeeValueInSat = [self estimatedFeeValueInSat];
    LXHBTCAmount actualFeeValueInSat = [self actualFeeValueInSat];
    NSDecimalNumber *estimatedFeeValueInBTC = [NSDecimalNumber decimalBTCValueWithSatValue:estimatedFeeValueInSat];
    NSDecimalNumber *actualFeeValueInBTC = [NSDecimalNumber decimalBTCValueWithSatValue:actualFeeValueInSat];
    switch (statusCode) {
        case 0:
            title = [NSString stringWithFormat:NSLocalizedString(@"手续费 %@BTC", nil), actualFeeValueInBTC];
            break;
        case 1:
        {
            LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self inputs]];
            LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self outputs]];
            NSDecimalNumber *remainingValue = [NSDecimalNumber decimalBTCValueWithSatValue:inputsValueSum-outputsValueSum-estimatedFeeValueInSat];
            //剩余的值太小，归到手续费里的情况
            title = [NSString stringWithFormat:NSLocalizedString(@"手续费 %@BTC(剩余%@因为太小已经被归到手续费里）", nil), actualFeeValueInBTC, remainingValue];
        }
            break;
        case -1:
            //实际手续费过多，有可能造成浪费。title文字起提醒作用
            title = [NSString stringWithFormat:NSLocalizedString(@"估计的手续费 %@BTC  实际的手续费 %@BTC", nil), estimatedFeeValueInBTC, actualFeeValueInBTC];
            break;
        case -2:
            //实际手续费过少，有可能影响到账时间。title文字起提醒作用
            title = [NSString stringWithFormat:NSLocalizedString(@"估计的手续费 %@BTC  实际的手续费 %@BTC", nil), estimatedFeeValueInBTC, actualFeeValueInBTC];
            break;
        default:
            title = NSLocalizedString(@"手续费", nil); //这时候不显示具体数值。点下一步时会提示具体的问题
            break;
    }
    return title;
}

//判断剩余的值，相比其带来的手续费，是否值得添加一个找零
- (BOOL)isWorthToAddChangeOutput {
    LXHBTCAmount value = [self valueForAddingANewChangeOutput];
    return value > 0;
}

- (LXHBTCAmount)valueForAddingANewChangeOutput {
    LXHBTCAmount inputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self inputs]];
    LXHBTCAmount outputsValueSum = [LXHTransactionInputOutputCommon valueSatSumOfInputsOrOutputs:[self outputs]];
    LXHBTCAmount feeOfNewChangeOutput = [self feeOfNewChangeOutput];
    LXHBTCAmount value = inputsValueSum - outputsValueSum - feeOfNewChangeOutput;
    return value;
}

/**
 按着目前的的情况返回一个找零LXHTransactionOutput
 如果计算得到的值大于零，返回找零对象，否则返回nil
 */
- (LXHTransactionOutput *)getANewChangeOutput {
    LXHBTCAmount value = [self valueForAddingANewChangeOutput];
    if (value > 0) {
        LXHTransactionOutput *changeOutput = [LXHTransactionOutput new];
        changeOutput.valueBTC = [NSDecimalNumber decimalBTCValueWithSatValue:value];
        changeOutput.address = [LXHWallet.mainAccount currentChangeAddress];
        return changeOutput;
    } else {
        return nil;
    }
}

- (LXHBTCAmount)feeOfNewChangeOutput {
    LXHFeeCalculator *feeCalculator = [[LXHFeeCalculator alloc] init];
    feeCalculator.inputs = [self inputs];
    feeCalculator.feeRate = [self feeRate];
    LXHTransactionOutput *newChangeOutput = [LXHTransactionOutput new];
    NSMutableArray *outputs = [self outputs].mutableCopy;
    [outputs addObject:newChangeOutput];
    feeCalculator.outputs = outputs;
    return [feeCalculator estimatedFeeInSat];
}

- (LXHFeeCalculator *)feeCalculatorForSelectInput {
    LXHFeeCalculator *feeCalculator = [[LXHFeeCalculator alloc] init];
    feeCalculator.outputs = [self outputs];
    feeCalculator.feeRate = [self feeRate];
    return feeCalculator;
}

@end
