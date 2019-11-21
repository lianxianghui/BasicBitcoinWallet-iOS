//
//  LXHOutputListViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHOutputListViewModel : NSObject
@property (nonatomic, readonly) NSMutableArray *outputs;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (NSString *)headerInfoText;

- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
- (void)deleteRowAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
