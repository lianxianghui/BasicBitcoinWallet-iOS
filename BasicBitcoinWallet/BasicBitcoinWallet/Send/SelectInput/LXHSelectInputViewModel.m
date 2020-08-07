//
//  LXHSelectInputViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectInputViewModel.h"
#import "LXHTransactionDataManager.h"
#import "BlocksKit.h"
#import "LXHOutputDetailViewModel.h"
#import "LXHFeeCalculator.h"

@interface LXHSelectInputViewModel ()
@property (nonatomic, readwrite) NSArray *selectedUtxos;
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListview;
@end

@implementation LXHSelectInputViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedUtxos = nil;//初始为空
    }
    return self;
}

- (NSMutableArray *)cellDataArrayForListview {
    if (!_cellDataArrayForListview) {
        NSMutableArray *cellDataArrayForListView = [NSMutableArray array];
        //utxos 按value从大到小排序
        NSMutableArray<LXHTransactionOutput *> *utxos = [[LXHTransactionDataManager sharedInstance] utxosOfAllTransactions];
        [utxos sortUsingComparator:^NSComparisonResult(LXHTransactionOutput *  _Nonnull obj1, LXHTransactionOutput *  _Nonnull obj2) {
            return -[obj1.valueBTC compare:obj2.valueBTC];
        }];
        
        //构造cellDataArray
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [cellDataArrayForListView addObject:dic];
        for (LXHTransactionOutput *utxo in utxos) {
            NSString *valueText = [NSString stringWithFormat:@"%@ BTC", utxo.valueBTC];
            
            static NSDateFormatter *formatter = nil;
            if (!formatter) {
                formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = NSLocalizedString(LXHTransactionTimeDateFormat, nil);
            }
            LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:utxo.txid];
            
            NSString *transactionTime = nil;
            if (!transaction.firstSeen) { //应该不会出现这种情况
                transactionTime = @" ";
            } else {
                NSInteger time = [transaction.firstSeen integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                transactionTime = [formatter stringFromDate:date];
            }
            NSMutableDictionary *dic = @{@"circleImage":@"check_circle",
                                         @"cellType":@"LXHSelectInputCell",
                                         @"time": NSLocalizedString(@"交易发起时间:", nil),
                                         @"btcValue":@"0.00000004 BTC",
                                         @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ",
                                         @"checkedImage":@"checked_circle", @"isSelectable":@"1",
                                         @"timeValue":@"2019-09-01 12:36"}.mutableCopy;
            BOOL btcValueHidden = [self showBTCValueForWarningWithUtxo:utxo];
            dic[@"btcValue"] = valueText;
            dic[@"btcValueHidden"] = @(btcValueHidden);
            dic[@"btcValueForWarning"] = valueText;
            dic[@"btcValueForWarningHidden"] = @(!btcValueHidden);
            dic[@"addressText"] = utxo.address.base58String ?: @"";
            dic[@"timeValue"] = transactionTime;
            dic[@"model"] = utxo;
            dic[@"isChecked"] = @([self.selectedUtxos containsObject:utxo]);
            [cellDataArrayForListView addObject:dic];
        }
        _cellDataArrayForListview = cellDataArrayForListView;
    }
    return _cellDataArrayForListview;
}

- (void)resetCellDataArrayForListview {
    _cellDataArrayForListview = nil;
}

- (NSString *)infoText {
    return nil;
}

- (void)toggleCheckedStateOfRow:(NSInteger)row {
    if (row < self.cellDataArrayForListview.count) {
        NSMutableDictionary *dic = self.cellDataArrayForListview[row];
        BOOL isChecked =  [dic[@"isChecked"] boolValue];
        isChecked = !isChecked;
        dic[@"isChecked"] = @(isChecked);
        [self refreshSelectedUtxosFromCellDataArray];
    }
}

- (void)refreshSelectedUtxosFromCellDataArray {
    _selectedUtxos = [[self.cellDataArrayForListview bk_select:^BOOL(NSDictionary *dic) {
        return [dic[@"isChecked"] boolValue];
    }] bk_map:^id(NSDictionary *dic) {
        return dic[@"model"];
    }];
}

- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {
    [self.cellDataArrayForListview exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    [self refreshSelectedUtxosFromCellDataArray];
}

- (id)outputDetailViewModelAtIndex:(NSInteger)index {
    if (index >= self.cellDataArrayForListview.count)
        return nil;
    LXHTransactionOutput *output = self.cellDataArrayForListview[index][@"model"];
    if (!output)
        return nil;
    id viewModel = [[LXHOutputDetailViewModel alloc] initWithOutput:output];
    return viewModel;
}

- (BOOL)showBTCValueForWarningWithUtxo:(LXHTransactionOutput *)utxo {
    LXHBTCAmount feeRateValue = _feeCalculator.feeRate.value;
    feeRateValue = MAX(feeRateValue, 1);//最小feeRate为1
    return [LXHFeeCalculator feeGreaterThanValueWithInput:utxo feeRateValue:feeRateValue];
}

@end
