//
//  LXHTransactionDetailViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class LXHTransaction;
@interface LXHTransactionDetailViewModel : NSObject

- (instancetype)initWithTransaction:(LXHTransaction *)transaction;

- (NSMutableArray *)dataForCells;


/**
 key1 controllerClassName
 key2 viewModel
 */
- (NSDictionary *)controllerInfoAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
