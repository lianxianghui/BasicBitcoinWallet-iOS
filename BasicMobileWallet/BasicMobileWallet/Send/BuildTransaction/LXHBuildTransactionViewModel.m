//
//  LXHBuildTransactionViewModel.m
//  BasicMobileWallet
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

@interface LXHBuildTransactionViewModel ()
@property (nonatomic, readwrite) LXHOutputListViewModel *outputListViewModel;
@property (nonatomic, readwrite) LXHSelectFeeRateViewModel *selectFeeRateViewModel;
@property (nonatomic, readwrite) LXHInputFeeViewModel *inputFeeViewModel;
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
        mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", utxo.value];
        [ret addObject:mutableDic];
    }
    return ret;
}

- (NSArray *)outputCellDataArray {
    NSMutableArray *ret = [NSMutableArray array];
    NSDictionary *dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输出", @"id":@"selectOutput"};
    [ret addObject:dic];
    NSArray *outputs = [self.outputListViewModel outputs];
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
        
        mutableDic[@"btcValue"] = [NSString stringWithFormat:@"%@ BTC", output.value];
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

- (NSDecimalNumber *)actualFeeValueInBTC {
    NSUInteger inputCount = [self inputs].count;
    NSUInteger outputCount = [self outputs].count;
    if (inputCount == 0 || outputCount == 0)
        return nil;
    NSDecimalNumber *difference = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    if ([difference compare:[NSDecimalNumber zero]] == NSOrderedDescending) {//输入和大于输出和
        return difference;
    }
    return nil;
}

- (NSDecimalNumber *)estimatedFeeValueInBTC {
    LXHFeeCalculator *feeCalculator = [LXHFeeCalculator new];
    feeCalculator.inputs = [self inputs];
    feeCalculator.feeRateInSat = [self feeRateValue].unsignedIntegerValue;
    feeCalculator.outputs = [self outputs];
    NSDecimalNumber *estimatedFeeValueInBTC = [feeCalculator estimatedFeeInBTC];//从费率和估计的字节数算出的手续费
    return estimatedFeeValueInBTC;
}


- (NSDictionary *)titleCell2DataForGroup2 {
    NSDecimalNumber *estimatedFeeValueInBTC = [self estimatedFeeValueInBTC];
    NSDecimalNumber *actualFeeValueInBTC = [self actualFeeValueInBTC];
    NSString *title = nil;
    if (!estimatedFeeValueInBTC || !actualFeeValueInBTC) {
        title = NSLocalizedString(@"手续费", nil); //为nil时代表无意义，不显示具体数值
    } else {
        NSComparisonResult comparisonResult = [actualFeeValueInBTC compare:estimatedFeeValueInBTC];
        if (comparisonResult == NSOrderedSame)
            title = [NSString stringWithFormat:NSLocalizedString(@"手续费 %@BTC", nil), actualFeeValueInBTC];
        else if (comparisonResult == NSOrderedDescending) { //actualFeeValueInBTC > estimatedFeeValueInBTC
            if ([self changeTooSmall]) //找零太小，归到手续费里的情况
                title = [NSString stringWithFormat:NSLocalizedString(@"手续费 %@BTC", nil), actualFeeValueInBTC];
            else //实际手续费过多，有可能造成浪费。起到提醒作用
                title = [NSString stringWithFormat:NSLocalizedString(@"估计的手续费 %@BTC  实际的手续费 %@BTC", nil), estimatedFeeValueInBTC, actualFeeValueInBTC];
        } else { //actualFeeValueInBTC < estimatedFeeValueInBTC。实际手续费过少，有可能影响到账时间。起到提醒作用
            title = [NSString stringWithFormat:NSLocalizedString(@"估计的手续费 %@BTC  实际的手续费 %@BTC", nil), estimatedFeeValueInBTC, actualFeeValueInBTC];
        }
    }
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell2"};
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
}

- (LXHInputFeeViewModel *)inputFeeViewModel {
    if (!_inputFeeViewModel)
        _inputFeeViewModel = [[LXHInputFeeViewModel alloc] init];
    return _inputFeeViewModel;
}

- (void)resetInputFeeViewModel {
    _inputFeeViewModel = nil;
}

- (void)addChangeOutputAtRandomPosition {
    LXHTransactionOutput *currentChangeOutput = [self currentChangeOutput];
    if (currentChangeOutput)
        [self.outputListViewModel addNewChangeOutputAtRandomPositionWithOutput:currentChangeOutput];
}

- (BOOL)hasInputsAndFeeRateAndOutputs {
    return _selectInputViewModel.selectedUtxos.count > 0 && [self feeRateValue] && [self.outputListViewModel outputCount] > 0;
}

/**
 关于是否需要添加找零的信息
 两种情况显示或不显示
 如果显示分两种情况
 1.如果剩余的值 值得添加一个找零。提示用户是否添加找零输出。
 2.如果不值得，提示用户。（会被包含到手续费里）
 @return 字典 key0 showInfo value YES or No, key1 worth : value YES or No, key2 info
 */
- (NSDictionary *)infoForAddingChange {
    NSDictionary *doNotShowInfo = @{@"showInfo":@(NO)};
    if (![self hasInputsAndFeeRateAndOutputs])
        return doNotShowInfo;
    if ([self.outputListViewModel hasChangeOutput])
        return doNotShowInfo;
    
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    NSDictionary *ret = nil;
    if ([differenceBetweenInputsAndOutputs compare:[NSDecimalNumber zero]] == NSOrderedDescending) {//输入和大于输出和
        BOOL worth;
        NSString *info;
        if ([self changeTooSmall]) {
            worth = NO;
            info = NSLocalizedString(@"因为找零过小，带来的手续费比它的值还大，已经被归到手续费里", nil);
        } else {
            worth = YES;
            info = NSLocalizedString(@"是否添加找零?", nil);
        }
        ret = @{@"showInfo":@(YES), @"worth":@(worth), @"info":info};
    } else {
        ret = doNotShowInfo;
    }
    return ret;
}

- (BOOL)hasChangeOutput {
    return [self.outputListViewModel hasChangeOutput];
}

/**
 点击下一步时判断输入、输出、手续费是否正常，返回代表该情况的code
输入、输出或费率未正确选择或填写 code -4
 1.输入大于等于输出
 1) 实际手续费与估计的手续费一样，理想状态 不需要显示提示 code 0
 2) 实际手续费大于估计的手续费，但是加一个找零又不值得（带来的手续费比其值还大）不需要显示提示 code 1
 2) 实际手续费过多，有可能造成浪费的情况。提醒是否加一个找零 code -1
 3) 实际手续费过少，有可能影响到账时间。 code -2
 2.输入小于输出
 提示 输入无法满足输出 code -3
 @return code
 */
- (NSInteger)codeForClickingNextStep {
    if (_selectInputViewModel.selectedUtxos.count == 0)
        return -4;
    if ([self.outputListViewModel outputCount] == 0)
        return -4;
    if (![self feeRateValue])
        return -4;
    
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    if ([differenceBetweenInputsAndOutputs compare:[NSDecimalNumber zero]] == NSOrderedAscending) {//输入小于输出
        return -3;
    } else { ///输入大于等于输出
        NSDecimalNumber *estimatedFeeValueInBTC = [self estimatedFeeValueInBTC];
        NSDecimalNumber *actualFeeValueInBTC = [self actualFeeValueInBTC];
        if ([actualFeeValueInBTC compare:estimatedFeeValueInBTC] == NSOrderedSame) {
            return 0;
        } else if ([actualFeeValueInBTC compare:estimatedFeeValueInBTC] == NSOrderedDescending) {//actualFeeValueInBTC > estimatedFeeValueInBTC
            if ([self changeTooSmall])
                return 1;
            else
                return -1;
        } else { //actualFeeValueInBTC < estimatedFeeValueInBTC
            return -2;
        }
    }
}

- (BOOL)changeTooSmall {
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    LXHTransactionOutput *output = [LXHTransactionOutput new];
    output.value = differenceBetweenInputsAndOutputs;
    return [LXHFeeCalculator feeGreaterThanValueWithOutput:output feeRateInSat:[self feeRateValue].unsignedIntegerValue];
}

- (LXHTransactionOutput *)currentChangeOutput {
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    NSDecimalNumber *feeWithANewChangeOutput = [self feeWithANewChangeOutput];
    NSDecimalNumber *value = [differenceBetweenInputsAndOutputs decimalNumberBySubtracting:feeWithANewChangeOutput];
    if ([value compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        LXHTransactionOutput *changeOutput = [LXHTransactionOutput new];
        changeOutput.value = value;
        changeOutput.address = [LXHWallet.mainAccount currentChangeAddress];
        return changeOutput;
    } else {
        return nil;
    }
}

- (NSDecimalNumber *)feeWithANewChangeOutput {
    LXHFeeCalculator *feeCalculator = [LXHFeeCalculator new];
    feeCalculator.inputs = [self inputs];
    feeCalculator.feeRateInSat = [self feeRateValue].unsignedIntegerValue;
    LXHTransactionOutput *newChangeOutput = [LXHTransactionOutput new];
    NSMutableArray *outputs = [self outputs].mutableCopy;
    [outputs addObject:newChangeOutput];
    feeCalculator.outputs = outputs;
    return [feeCalculator estimatedFeeInBTC];
}

@end
