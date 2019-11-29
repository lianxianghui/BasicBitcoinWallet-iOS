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
        mutableDic[@"addressText"] = utxo.address;
        mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i+1];
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
        mutableDic[@"addressText"] = output.address;
        mutableDic[@"text"] = [NSString stringWithFormat:@"%ld.", i+1];
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

- (NSDecimalNumber *)feeValueInBTC {
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

- (NSDictionary *)titleCell2DataForGroup2 {
    NSDecimalNumber *feeValueInBTC = [self feeValueInBTC];
    NSString *title = feeValueInBTC ? [NSString stringWithFormat:NSLocalizedString(@"手续费 %@BTC", nil), feeValueInBTC] : NSLocalizedString(@"手续费", nil); //feeValueInBTC 为nil时代表无意义，不显示具体数值
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
    if (!_outputListViewModel) {
        _outputListViewModel = [[LXHOutputListViewModel alloc] init];
    }
    return _outputListViewModel;
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
     //get view model
    //put changeOutput
    //random int
//    int theInteger;
//    [completeData getBytes:&theInteger length:sizeof(theInteger)];
//    先把LocalAddress处理好
}

- (LXHTransactionOutput *)currentChangeOutput {
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    LXHTransactionOutput *changeOutput = [[LXHTransactionOutput alloc] init];
    NSDecimalNumber *feeOfChangeOutput = [LXHFeeCalculator feeInBTCWithOutput:changeOutput feeRateInSat:[self feeRateValue].unsignedIntegerValue];
    NSDecimalNumber *value = [differenceBetweenInputsAndOutputs decimalNumberBySubtracting:feeOfChangeOutput];
    if ([value compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        changeOutput.value = value;
        changeOutput.address = [LXHWallet.mainAccount currentChangeAddress].addressString;
    }
    return changeOutput;
}

/**
 关于是否需要添加找零的信息
 两种情况
 如果剩余的值 值得添加一个找零。提示用户是否添加找零输出。
 如果不值得，提示用户。（会被包含到手续费里）
 @return 字典 key0 showInfo value YES or No, key1 worth : value YES or No, key2 info
 */
- (NSDictionary *)infoForAddingChange {
    NSDecimalNumber *differenceBetweenInputsAndOutputs = [LXHFeeCalculator differenceBetweenInputs:[self inputs] outputs:[self outputs]];
    NSDictionary *ret = nil;
    if ([differenceBetweenInputsAndOutputs compare:[NSDecimalNumber zero]] == NSOrderedDescending) {//输入和大于输出和
        BOOL worth;
        NSString *info;
        LXHTransactionOutput *output = [LXHTransactionOutput new];
        output.value = differenceBetweenInputsAndOutputs;
        if ([LXHFeeCalculator feeGreaterThanValueWithOutput:output feeRateInSat:[self feeRateValue].unsignedIntegerValue]) {
            worth = NO;
            info = NSLocalizedString(@"因为找零过小，带来的手续费比它的值还大，已经被归到手续费里", nil);
        } else {
            worth = YES;
            info = NSLocalizedString(@"是否添加找零?", nil);
        }
        ret = @{@"showInfo":@(YES), @"worth":@(worth), @"info":info};
    } else {
        ret = @{@"showInfo":@(NO)};
    }
    return ret;
}

@end
