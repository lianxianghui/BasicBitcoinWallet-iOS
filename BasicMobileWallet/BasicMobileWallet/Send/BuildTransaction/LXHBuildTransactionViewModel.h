//
//  LXHBuildTransactionViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHBuildTransactionViewModel : NSObject

//用来在几个页面之间传递构造交易数据的字典
@property (nonatomic, readonly) NSMutableDictionary *dataForBuildingTransaction;//keys @"selectedUtxos", @"outputs", @"selectedFeeRateItem", @"inputFeeRate"

- (NSArray *)inputCellDataArray;
- (NSArray *)outputCellDataArray;
- (NSDictionary *)feeRateCellData;
- (NSDecimalNumber *)sumForInputsOrOutputsWithArray:(NSArray *)array;

//子类覆盖
- (NSArray *)cellDataForListview;
- (NSDictionary *)titleCell1DataForGroup1;//第一个title
- (NSDictionary *)titleCell2DataForGroup2;//费率的title
- (NSDictionary *)titleCell2DataForGroup3;//第三个title
@end

NS_ASSUME_NONNULL_END
