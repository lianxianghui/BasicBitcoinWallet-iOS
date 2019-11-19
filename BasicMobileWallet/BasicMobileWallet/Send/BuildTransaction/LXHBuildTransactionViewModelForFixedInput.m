//
//  LXHBuildTransactionViewModelForFixedInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBuildTransactionViewModelForFixedInput.h"

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
    NSDecimalNumber *sum = [self sumForInputsOrOutputsWithArray:self.dataForBuildingTransaction[@"inputs"]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输入 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell1"};
    return dic;
}


- (NSDictionary *)titleCell2DataForGroup3 {
    NSDecimalNumber *sum = [self sumForInputsOrOutputsWithArray:self.dataForBuildingTransaction[@"outputs"]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"输入 %@BTC", nil), sum];
    NSDictionary *dic = @{@"title":title, @"isSelectable":@"0", @"cellType":@"LXHTitleCell2"};
    return dic;
}

@end
