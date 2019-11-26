//
//  LXHOutputListViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHAddOutputViewModel;
@interface LXHOutputListViewModel : NSObject
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (NSString *)headerInfoTitle;
- (NSString *)headerInfoText;

- (void)resetCellDataArrayForListview;
- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)deleteRowAtIndex:(NSInteger)index;

- (LXHAddOutputViewModel *)getNewOutputViewModel;
- (NSArray<LXHAddOutputViewModel *> *)outputViewModels;
- (void)addOutputViewModel:(LXHAddOutputViewModel *)model;
@end

NS_ASSUME_NONNULL_END
