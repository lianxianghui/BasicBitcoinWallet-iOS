//
//  LXHSelectInputViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectInputViewModel.h"
#import "LXHTransactionDataManager.h"
#import "BlocksKit.h"

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
            return -[obj1.value compare:obj2.value];
        }];
        
        //构造cellDataArray
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [cellDataArrayForListView addObject:dic];
        for (LXHTransactionOutput *utxo in utxos) {
            NSString *valueText = [NSString stringWithFormat:@"%@ BTC", utxo.value];
            
            static NSDateFormatter *formatter = nil;
            if (!formatter) {
                formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = NSLocalizedString(LXHTranactionTimeDateFormat, nil);
            }
            LXHTransaction *transaction = [[LXHTransactionDataManager sharedInstance] transactionByTxid:utxo.txid];
            
            NSString *transactionTime = nil;
            if (!transaction.time) { //还没有打进包
                transactionTime = @" ";
            } else {
                NSInteger time = [transaction.time integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                transactionTime = [formatter stringFromDate:date];
            }
            NSMutableDictionary *dic = @{@"circleImage":@"check_circle",
                                         @"cellType":@"LXHSelectInputCell",
                                         @"time": NSLocalizedString(@"交易时间:", nil),
                                         @"btcValue":@"0.00000004 BTC",
                                         @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ",
                                         @"checkedImage":@"checked_circle", @"isSelectable":@"1",
                                         @"timeValue":@"2019-09-01 12:36"}.mutableCopy;
            dic[@"btcValue"] = valueText;
            dic[@"addressText"] = utxo.address ?: @"";
            dic[@"timeValue"] = transactionTime;
            dic[@"model"] = utxo;
            dic[@"isChecked"] = @([self.selectedUtxos containsObject:utxo]);
            [cellDataArrayForListView addObject:dic];
        }
        _cellDataArrayForListview = cellDataArrayForListView;
    }
    return _cellDataArrayForListview;
}

- (NSString *)valueText {
    NSDecimalNumber *seletedUtxosValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
    NSString *text = [NSString stringWithFormat:@"%@ BTC", seletedUtxosValueSum];
    return text;
}

- (void)toggleCheckedStateOfRow:(NSInteger)row {
    if (row < self.cellDataArrayForListview.count) {
        NSMutableDictionary *dic = self.cellDataArrayForListview[row];
        BOOL isChecked =  [dic[@"isChecked"] boolValue];
        isChecked = !isChecked;
        dic[@"isChecked"] = @(isChecked);
        [self refershSelectedUtxosFromCellDataArray];
    }
}

- (void)refershSelectedUtxosFromCellDataArray {
    _selectedUtxos = [[self.cellDataArrayForListview bk_select:^BOOL(NSDictionary *dic) {
        return [dic[@"isChecked"] boolValue];
    }] bk_map:^id(NSDictionary *dic) {
        return dic[@"model"];
    }];
}

- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {
    [self.cellDataArrayForListview exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    [self refershSelectedUtxosFromCellDataArray];
}

@end
