//
//  LXHSelectInputViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHFeeEstimator;
@interface LXHSelectInputViewModel : NSObject
@property (nonatomic) BOOL isConstrainted;
//如果isConstrainted为YES，feeEstimator和fixedOutputValueSum需要有值
@property (nonatomic) LXHFeeEstimator *feeEstimator;
@property (nonatomic) NSDecimalNumber *fixedOutputValueSum;

@property (nonatomic, readonly) NSArray *selectedUtxos;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (NSString *)infoText;
- (void)toggleCheckedStateOfRow:(NSInteger)row;
- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
@end

NS_ASSUME_NONNULL_END
