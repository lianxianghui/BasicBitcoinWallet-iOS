//
//  LXHSelectInputViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 抽象类
 */
@interface LXHSelectInputViewModel : NSObject
@property (nonatomic, readonly) NSArray *selectedUtxos;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (void)toggleCheckedStateOfRow:(NSInteger)row;
- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

- (NSString *)infoText;//for overriding

- (id)outputDetailViewModelAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
