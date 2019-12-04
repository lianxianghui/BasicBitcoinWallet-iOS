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
 两种情况显示或不显示
 如果显示分两种情况
 1.如果剩余的值 值得添加一个找零。提示用户是否添加找零输出。
 2.如果不值得，提示用户。（会被包含到手续费里）
 @return 字典 key0 showInfo value YES or No, key1 worth : value YES or No, key2 info
 */
- (NSDictionary *)infoForAddingChange;

/**
 点击下一步时判断输入、输出、手续费是否正常，返回代表该情况的code
 1.输入大于等于输出
 1) 实际手续费与估计的手续费一样，理想状态 不需要显示提示 code 0
 2) 实际手续费大于估计的手续费，但是加一个找零又不值得（带来的手续费比其值还大）不需要显示提示 code 1
 2) 实际手续费过多，有可能造成浪费的情况。提醒是否加一个找零 code -1
 3) 实际手续费过少，有可能影响到账时间。 code -2
 2.输入小于输出
 提示 输入无法满足输出 code -3
 @return code
 */
- (NSInteger)codeForClickingNextStep;

- (BOOL)hasChangeOutput;

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
