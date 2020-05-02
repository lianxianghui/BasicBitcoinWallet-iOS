//
//  LXHBalanceViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBalanceViewModel.h"
#import "LXHTransactionDataManager.h"
#import "LXHTransaction.h"
#import "BlocksKit.h"
#import "LXHOutputDetailViewModel.h"

@implementation LXHBalanceViewModel

- (NSString *)balanceValueText {
    NSString *balanceValueText = [NSString stringWithFormat:@"%@ BTC", [[LXHTransactionDataManager sharedInstance] balance]];
    return balanceValueText;
}

- (NSMutableArray *)dataForCells {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        NSDictionary *dic = nil;
        dic = @{@"isSelectable":@"0", @"cellType":@"LXHLineCell"};
        [_dataForCells addObject:dic];
        for (LXHTransactionOutput *utxo in [self utxos]) {
            NSString *valueText = [NSString stringWithFormat:@"%@ BTC", utxo.valueBTC];
            dic = @{@"text1": utxo.address.base58String ?: @"", @"isSelectable":@"1", @"text2": valueText, @"cellType":@"LXHBalanceLeftRightTextCell", @"model": utxo};
            [_dataForCells addObject:dic];
        }
    }
    return _dataForCells;
}

//按value从大到小排序
- (NSMutableArray<LXHTransactionOutput *> *)utxos {
    NSMutableArray<LXHTransactionOutput *> *ret = [[LXHTransactionDataManager sharedInstance] utxosOfAllTransactions];
    [ret sortUsingComparator:^NSComparisonResult(LXHTransactionOutput *  _Nonnull obj1, LXHTransactionOutput *  _Nonnull obj2) {
        return -[obj1.valueBTC compare:obj2.valueBTC];
    }];
    return ret;
}

- (id)outputDetailViewModelAtIndex:(NSInteger)index {
    LXHTransactionOutput *output = [self dataForCells][index][@"model"];
    if (!output)
        return nil;
    id viewModel = [[LXHOutputDetailViewModel alloc] initWithOutput:output];
    return viewModel;
}

@end
