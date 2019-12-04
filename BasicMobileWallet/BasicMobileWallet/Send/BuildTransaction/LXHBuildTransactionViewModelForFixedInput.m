//
//  LXHBuildTransactionViewModelForFixedInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBuildTransactionViewModelForFixedInput.h"
#import "LXHSelectInputViewModel.h"
#import "LXHOutputListViewModel.h"
#import "LXHSelectFeeRateViewModel.h"
#import "LXHInputFeeViewModel.h"
#import "LXHAddOutputViewModel.h"
#import "LXHSelectInputViewModelForFixedInput.h"
#import "LXHOutputListViewModelForFixedInput.h"

@implementation LXHBuildTransactionViewModelForFixedInput


- (NSArray *)cellDataForListview {
    NSMutableArray *cellDataListForListView = [NSMutableArray array];
    [cellDataListForListView addObject:[self titleCell1DataForGroup1]];
    [cellDataListForListView addObjectsFromArray:[self inputCellDataArray]];
    
    [cellDataListForListView addObject:[self titleCell2DataForGroup2]];
    [cellDataListForListView addObject:[self feeRateCellData]];
    
    [cellDataListForListView addObject:[self titleCell2DataForGroup3]];
    [cellDataListForListView addObjectsFromArray:[self outputCellDataArray]];
    return cellDataListForListView;
}

- (NSDictionary *)titleCell1DataForGroup1 {
    NSDecimalNumber *sum =  [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:[self inputs]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输入 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell1"};
    return dic;
}

- (NSDictionary *)titleCell2DataForGroup3 {
    NSDecimalNumber *sum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:[self outputs]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输出 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell2"};
    return dic;
}

- (nullable NSString *)clickSelectInputPrompt {
    return nil;
}

- (nullable NSString *)clickSelectOutputPrompt {
    if (_selectInputViewModel.selectedUtxos.count == 0)
        return NSLocalizedString(@"请先选择输入", nil);
    else if (![self feeRateValue])
        return NSLocalizedString(@"请先选择或输入费率", nil);
    return nil;
}

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"构建固定输入交易", nil);
}

- (LXHSelectInputViewModel *)selectInputViewModel {
    if (!_selectInputViewModel) {
        LXHSelectInputViewModelForFixedInput *selectInputViewModel = [[LXHSelectInputViewModelForFixedInput alloc] init];
        _selectInputViewModel = selectInputViewModel;
    }
    return _selectInputViewModel;
}

- (LXHOutputListViewModel *)outputListViewModel {
    if (!_outputListViewModel)
        _outputListViewModel = [[LXHOutputListViewModelForFixedInput alloc] init];
    LXHOutputListViewModelForFixedInput *outputListViewModelForFixedInput = (LXHOutputListViewModelForFixedInput *)_outputListViewModel;
    outputListViewModelForFixedInput.inputs = [self inputs];
    outputListViewModelForFixedInput.feeRateInSat = [self feeRateValue].unsignedIntegerValue;
    return _outputListViewModel;
}

@end
