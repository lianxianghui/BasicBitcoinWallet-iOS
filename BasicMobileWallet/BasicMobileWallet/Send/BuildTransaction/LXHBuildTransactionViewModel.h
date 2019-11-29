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


/**
 抽象类，有一些方法在子类里实现
 */
@interface LXHBuildTransactionViewModel : NSObject {
    @protected
    LXHSelectInputViewModel *_selectInputViewModel;
}

//ViewModell可以用来在几个页面之间传递构造交易数据
@property (nonatomic, readonly) LXHOutputListViewModel *outputListViewModel;//可能会被子类覆盖
@property (nonatomic, readonly) LXHSelectFeeRateViewModel *selectFeeRateViewModel;
@property (nonatomic, readonly) LXHInputFeeViewModel *inputFeeViewModel;

- (NSArray<LXHTransactionInputOutputCommon *> *)inputs;
- (NSArray<LXHTransactionInputOutputCommon *> *)outputs;
- (NSArray *)inputCellDataArray;
- (NSArray *)outputCellDataArray;
- (NSDictionary *)feeRateCellData;
- (NSNumber *)feeRateValue;

- (void)resetSelectFeeRateViewModel;
- (void)resetInputFeeViewModel;
//把一个找零输出加到outputs数组(位置随机)
- (void)addChangeOutputAtRandomPosition;

/**
 关于是否需要添加找零的信息
 两种情况
 如果剩余的值 值得添加一个找零。提示用户是否添加找零输出。
 如果不值得，提示用户。（会被包含到手续费里）
 @return 字典 key1 worth : value YES or No. key2 info
 */
- (NSDictionary *)infoForAddingChange;

//子类覆盖
- (LXHSelectInputViewModel *)selectInputViewModel;

- (NSArray *)cellDataForListview;
- (NSDictionary *)titleCell1DataForGroup1;//第一个title
- (NSDictionary *)titleCell2DataForGroup2;//费率的title
- (NSDictionary *)titleCell2DataForGroup3;//第三个title

- (nullable NSString *)clickSelectInputPrompt;
- (nullable NSString *)clickSelectOutputPrompt;




- (NSString *)navigationBarTitle;


@end

NS_ASSUME_NONNULL_END
