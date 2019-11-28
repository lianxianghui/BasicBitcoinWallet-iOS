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

- (NSDecimalNumber *)currentEstimatedFee {
    NSUInteger inputCount = self.selectedUtxos.count;
    if (inputCount == 0)
        inputCount = 1;//估计时要按着至少有一个输入来估计
    _feeCalculator.inputs = self.selectedUtxos;
    NSDecimalNumber *currentEstimatedFee = [_feeCalculator estimatedFeeInBTC];
    return currentEstimatedFee;
}

//- (NSDecimalNumber *)currentEstimatedFeeWithNewUTXO:(LXHTransactionOutput *)utxo {
//    NSMutableArray *utxos = self.selectedUtxos
//    _feeCalculator.inputCount = inputCount;
//    NSDecimalNumber *currentEstimatedFee = [_feeCalculator estimatedFeeInBTC];
//    return currentEstimatedFee;
//}

- (BOOL)allUtxosIsNotEnoughWithCurrentEstimatedFee:(NSDecimalNumber *)currentEstimatedFee {
    NSDecimalNumber *sumOfOutputsAndFee = [_fixedOutputValueSum decimalNumberByAdding:currentEstimatedFee];
    NSDecimalNumber *allUtxosSum = [self allUsableUtxosSum];
    return [allUtxosSum compare:sumOfOutputsAndFee] == NSOrderedAscending;//小于
}

- (NSDecimalNumber *)differenceWithCurrentEstimatedFee:(NSDecimalNumber *)currentEstimatedFee {
    NSDecimalNumber *sumOfOutputsAndFee = [_fixedOutputValueSum decimalNumberByAdding:currentEstimatedFee];
    NSDecimalNumber *seletedInputValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
    return [sumOfOutputsAndFee decimalNumberBySubtracting:seletedInputValueSum];
}

//会滤掉值过小的
- (NSDecimalNumber *)allUsableUtxosSum {
    LXHWeakSelf
    NSArray *allUtxos = [[LXHTransactionDataManager sharedInstance] utxosOfAllTransactions];
    NSArray<LXHTransactionOutput *> *allUsableUtxos = [allUtxos bk_reject:^BOOL(LXHTransactionOutput *obj) {
        return [weakSelf.feeCalculator feeGreaterThanValueWithInput:obj];//把消耗的Fee比它的值还大的滤掉
    }];
    NSDecimalNumber *sum = [LXHTransactionOutput valueSumOfOutputs:allUsableUtxos];
    return sum;
}

//可选择的输入总值小于当前输出与手续费的总值
//至少需要选择总值为  BTC的输入
//至少还需要选择总值为  BTC的输入
//所选总值为  BTC，已满足当前输出
- (NSString *)infoText {
    if (_isConstrainted) {
        NSDecimalNumber *currentEstimatedFee = [self currentEstimatedFee];
        if (!currentEstimatedFee) //应该不会发生
            return @" ";
       if ([self allUtxosIsNotEnoughWithCurrentEstimatedFee:currentEstimatedFee])
           return NSLocalizedString(@"余额不足(可选择的输入总和小于当前输出与手续费的总和)", nil);
        NSDecimalNumber *difference = [self differenceWithCurrentEstimatedFee:currentEstimatedFee];
        if ([difference compare:[NSDecimalNumber zero]] == NSOrderedDescending) { // 大于0
            NSString *format = nil;
            if (self.selectedUtxos.count == 0)
                format = @"至少需要选择总和为  %@BTC的输入";
            else
                format = @"至少还需要选择总和为  %@BTC的输入";
            format = NSLocalizedString(format, nil);
            return [NSString stringWithFormat:format, difference];
        } else { //小于等于0，说明够了
            NSDecimalNumber *seletedInputValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
            NSString *format = NSLocalizedString(@"所选总和为  %@BTC，已满足当前输出与手续费", nil);
            return [NSString stringWithFormat:format, seletedInputValueSum];
        }
    } else {
        NSDecimalNumber *seletedInputValueSum = [LXHTransactionOutput valueSumOfOutputs:self.selectedUtxos];
        NSString *format = NSLocalizedString(@"所选总值为  %@BTC", nil);
        return [NSString stringWithFormat:format, seletedInputValueSum];
    }
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
