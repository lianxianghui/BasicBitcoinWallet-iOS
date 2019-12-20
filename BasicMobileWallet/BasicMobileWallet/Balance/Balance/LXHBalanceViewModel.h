//
//  LXHBalanceViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionListViewModel.h"

NS_ASSUME_NONNULL_BEGIN


/**
 很多地方和交易列表类似，所以继承LXHTransactionListViewModel
 重新实现了dataForCells方法
 */
@interface LXHBalanceViewModel : LXHTransactionListViewModel
- (NSString *)balanceValueText;
- (id)outputDetailViewModelAtIndex:(NSInteger)index;
//- (id)outputDetailViewModelAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
