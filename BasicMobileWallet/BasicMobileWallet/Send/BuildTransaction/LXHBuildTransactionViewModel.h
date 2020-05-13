//
//  LXHBuildTransactionViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionInputOutputCommon, LXHSelectInputViewModel, LXHOutputListViewModel,LXHSelectFeeRateViewModel, LXHInputFeeViewModel, LXHTransactionInfoViewModel, LXHFeeRate, LXHFeeCalculator;


/**
 抽象类，有一些方法在子类里实现
 */
@interface LXHBuildTransactionViewModel : NSObject {
    @protected
    LXHSelectInputViewModel *_selectInputViewModel;
    LXHOutputListViewModel *_outputListViewModel;
}

//ViewModell可以用来在几个页面之间传递构造交易数据
@property (nonatomic, readonly) LXHSelectFeeRateViewModel *selectFeeRateViewModel;
@property (nonatomic, readonly) LXHInputFeeViewModel *inputFeeViewModel;

- (LXHTransactionInfoViewModel *)transactionInfoViewModel;

- (NSArray *)inputs;
- (NSArray *)outputs;
- (NSArray *)inputCellDataArray;
- (NSArray *)outputCellDataArray;
- (NSDictionary *)feeRateCellData;
- (NSNumber *)feeRateValue;
- (LXHFeeRate *)feeRate;
- (LXHFeeCalculator *)feeCalculatorForSelectInput;

- (void)resetSelectFeeRateViewModel;
- (void)resetInputFeeViewModel;
//把一个找零输出加到outputs数组(位置随机)
- (void)addChangeOutputAtRandomPosition;

- (NSInteger)currentStatusCode;

- (BOOL)hasChangeOutput;

//子类覆盖
- (LXHSelectInputViewModel *)selectInputViewModel;
- (LXHOutputListViewModel *)outputListViewModel;

- (NSArray *)cellDataForListview;
- (NSDictionary *)titleCell1DataForGroup1;//第一个title
- (NSDictionary *)titleCell2DataForGroup2;//费率的title
- (NSDictionary *)titleCell2DataForGroup3;//第三个title

- (nullable NSString *)clickSelectInputPrompt;
- (nullable NSString *)clickSelectOutputPrompt;

- (NSString *)navigationBarTitle;


@end

NS_ASSUME_NONNULL_END
