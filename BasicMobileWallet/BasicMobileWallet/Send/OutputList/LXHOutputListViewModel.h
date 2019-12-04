//
//  LXHOutputListViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHAddOutputViewModel, LXHTransactionOutput;
@interface LXHOutputListViewModel : NSObject
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (NSString *)headerInfoTitle;
- (NSString *)headerInfoText;

- (void)resetCellDataArrayForListview;
- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)deleteRowAtIndex:(NSInteger)index;



- (void)addOutputViewModel:(LXHAddOutputViewModel *)model;
- (void)addNewChangeOutputAtRandomPositionWithOutput:(LXHTransactionOutput *)output;
- (BOOL)hasChangeOutput;
- (NSArray *)outputs;
- (NSInteger)outputCount;

- (NSArray<LXHAddOutputViewModel *> *)outputViewModels;

- (nullable LXHAddOutputViewModel *)getNewOutputViewModel;//子类覆盖
- (void)refreshViewModelAtIndex:(NSUInteger)index;//子类覆盖
@end

NS_ASSUME_NONNULL_END
