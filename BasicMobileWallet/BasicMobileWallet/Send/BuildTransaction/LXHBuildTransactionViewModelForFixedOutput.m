//
//  LXHBuildTransactionViewModelForFixedOutput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBuildTransactionViewModelForFixedOutput.h"
#import "BlocksKit.h"
#import "LXHTransactionInput.h"
#import "LXHTransactionOutput.h"
#import "LXHSelectInputViewModel.h"
#import "LXHOutputListViewModel.h"
#import "LXHSelectFeeRateViewModel.h"
#import "LXHInputFeeViewModel.h"
#import "LXHAddOutputViewModel.h"
#import "LXHFeeCalculator.h"

@implementation LXHBuildTransactionViewModelForFixedOutput

- (NSArray *)cellDataForListview {
    NSMutableArray *cellDataListForListView = [NSMutableArray array];
    [cellDataListForListView addObject:[self titleCell1DataForGroup1]];
    [cellDataListForListView addObjectsFromArray:[self outputCellDataArray]];

    [cellDataListForListView addObject:[self titleCell2DataForGroup2]];
    [cellDataListForListView addObject:[self feeRateCellData]];

    [cellDataListForListView addObject:[self titleCell2DataForGroup3]];
    [cellDataListForListView addObjectsFromArray:[self inputCellDataArray]];
    return cellDataListForListView;
}

- (NSDictionary *)titleCell1DataForGroup1 {
    NSDecimalNumber *sum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:[self outputs]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输出 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell1"};
    return dic;
}


- (NSDictionary *)titleCell2DataForGroup3 {
    NSDecimalNumber *sum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:[self inputs]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输入 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell2"};
    return dic;
}

- (nullable NSString *)clickSelectOutputPrompt {
    return nil;
}

- (nullable NSString *)clickSelectInputPrompt {
    if ([self.outputListViewModel outputCount] == 0)
        return NSLocalizedString(@"请先添加输出", nil);
    else if (![self feeRateValue])
        return NSLocalizedString(@"请先选择或输入费率", nil);
    return nil;
}

- (NSString *)navigationBarTitle {
    return NSLocalizedString(@"构建固定输出交易", nil);
}

- (LXHSelectInputViewModel *)selectInputViewModel {
    LXHSelectInputViewModel *ret = [super selectInputViewModel];
    ret.isConstrainted = YES;
    ret.fixedOutputValueSum = [LXHTransactionInputOutputCommon valueSumOfInputsOrOutputs:[self outputs]];
    
    LXHFeeCalculator *feeCalculator = [[LXHFeeCalculator alloc] init];
    feeCalculator.outputCount = [self outputs].count;
    feeCalculator.feeRateInSat = [self feeRateValue].unsignedIntegerValue;
    ret.feeCalculator = feeCalculator;
    return ret;
}

@end
