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

@interface LXHBuildTransactionViewModel ()
@property (nonatomic, readwrite) NSMutableDictionary *dataForBuildingTransaction;
@end

@implementation LXHBuildTransactionViewModel

- (NSMutableDictionary *)dataForBuildingTransaction {
    if (!_dataForBuildingTransaction)
        _dataForBuildingTransaction = [NSMutableDictionary dictionary];
    return _dataForBuildingTransaction;
}

#pragma mark - 加工View数据
//把数据加工成适合View直接使用的形式

- (NSArray *)inputCellDataArray {
    NSMutableArray *ret = [NSMutableArray array];
    NSDictionary *dic = @{@"isSelectable":@"1", @"disclosureIndicator":@"disclosure_indicator", @"cellType":@"LXHSelectionCell", @"text":@"选择输入", @"id":@"selectInput"};
    [ret addObject:dic];
    NSArray *selectedUtxos = self.dataForBuildingTransaction[@"selectedUtxos"];
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
    NSArray *outputs = self.dataForBuildingTransaction[@"outputs"];
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
    if (self.dataForBuildingTransaction[@"inputFeeRate"])
        feeRateValue = self.dataForBuildingTransaction[@"inputFeeRate"];
    else if (self.dataForBuildingTransaction[@"selectedFeeRateItem"]) {
        NSDictionary *selectedFeeRateItem = self.dataForBuildingTransaction[@"selectedFeeRateItem"];
        feeRateValue = selectedFeeRateItem.allValues[0];
    } else {
        feeRateValue = nil;
    }
    return feeRateValue;
}

- (NSDecimalNumber *)sumForInputsOrOutputsWithArray:(NSArray *)array {
    if (!array)
        return [NSDecimalNumber zero];
    NSDecimalNumber *ret = [array bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionInputOutputCommon *obj) {
        return [sum decimalNumberByAdding:obj.value];
    }];
    return ret;
}

- (NSDictionary *)titleCell2DataForGroup2 {
    NSDictionary *dic = nil;
    dic = @{@"title":@"手续费 0.0000912BTC", @"isSelectable":@"0", @"cellType":@"LXHTitleCell2"};
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

@end
