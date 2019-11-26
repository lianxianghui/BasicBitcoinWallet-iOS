//
//  LXHBuildTransactionViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionInputOutputCommon, LXHSelectInputViewModel, LXHOutputListViewModel,LXHSelectFeeRateViewModel, LXHInputFeeViewModel;
@interface LXHBuildTransactionViewModel : NSObject

//ViewModell可以用来在几个页面之间传递构造交易数据
@property (nonatomic, readonly) LXHSelectInputViewModel *selectInputViewModel;
@property (nonatomic, readonly) LXHOutputListViewModel *outputListViewModel;
@property (nonatomic, readonly) LXHSelectFeeRateViewModel *selectFeeRateViewModel;
@property (nonatomic, readonly) LXHInputFeeViewModel *inputFeeViewModel;

- (NSArray<LXHTransactionInputOutputCommon *> *)inputs;
- (NSArray<LXHTransactionInputOutputCommon *> *)outputs;
- (NSArray *)inputCellDataArray;
- (NSArray *)outputCellDataArray;
- (NSDictionary *)feeRateCellData;
- (NSDecimalNumber *)sumForInputsOrOutputsWithArray:(NSArray *)array;

- (void)resetSelectFeeRateViewModel;
- (void)resetInputFeeViewModel;
//子类覆盖
- (NSArray *)cellDataForListview;
- (NSDictionary *)titleCell1DataForGroup1;//第一个title
- (NSDictionary *)titleCell2DataForGroup2;//费率的title
- (NSDictionary *)titleCell2DataForGroup3;//第三个title

- (NSString *)clickSelectInputPrompt;
- (NSString *)clickSelectOutpuPrompt;
@end

NS_ASSUME_NONNULL_END
