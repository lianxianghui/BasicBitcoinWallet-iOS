//
//  LXHSendViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSendViewModel.h"
#import "LXHTransactionInput.h"
#import "LXHTransactionOutput.h"

@interface LXHSendViewModel ()
@property (nonatomic, readwrite) NSMutableDictionary *dataForBuildingTransaction;
@end

@implementation LXHSendViewModel

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

//- (NSArray *)cellDataForListview {
//    NSMutableArray *cellDataListForListView = [NSMutableArray array];
//    NSDictionary *dic = nil;
//    dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
//    [cellDataListForListView addObject:dic];
//
//    [cellDataListForListView addObjectsFromArray:[self inputCellDataArray]];
//    [cellDataListForListView addObject:[self feeRateCellData]];
//
//    dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
//    [cellDataListForListView addObject:dic];
//
//    [cellDataListForListView addObjectsFromArray:[self outputCellDataArray]];
//    return cellDataListForListView;
//}

- (NSArray *)cellDataForListview {
    NSMutableArray *cellDataListForListView = [NSMutableArray array];
    NSDictionary *dic = nil;
    dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
    [cellDataListForListView addObject:dic];
    
    [cellDataListForListView addObjectsFromArray:[self outputCellDataArray]];
    dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
    [cellDataListForListView addObject:dic];
    
    [cellDataListForListView addObject:[self feeRateCellData]];
    dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyCell"};
    [cellDataListForListView addObject:dic];
    
    [cellDataListForListView addObjectsFromArray:[self inputCellDataArray]];
    return cellDataListForListView;
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


#pragma mark - other ViewModels




@end
