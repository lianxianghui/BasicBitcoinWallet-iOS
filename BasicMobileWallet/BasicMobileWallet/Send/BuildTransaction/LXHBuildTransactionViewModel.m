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
#import "LXHFeeUtils.h"

@interface LXHBuildTransactionViewModel ()
@property (nonatomic, readwrite) LXHSelectInputViewModel *selectInputViewModel;
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
    NSArray *selectedUtxos = self.selectInputViewModel.selectedUtxos;
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
    return self.selectInputViewModel.selectedUtxos;
}

- (NSArray<LXHTransactionInputOutputCommon *> *)outputs {
    return self.outputListViewModel.outputs;
}

- (NSDecimalNumber *)feeValueInBTC {
    NSUInteger inputCount = [self inputs].count;
    NSUInteger outputCount = [self outputs].count;
    if (inputCount == 0 || outputCount == 0)
        return nil;
    NSDecimalNumber *difference = [LXHFeeUtils differenceBetweenInputs:[self inputs] outputs:[self outputs]];
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
    if (!_selectInputViewModel)
        _selectInputViewModel = [[LXHSelectInputViewModel alloc] init];
    return _selectInputViewModel;
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

@end
