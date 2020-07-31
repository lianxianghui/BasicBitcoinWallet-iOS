//
//  LXHTransactionListByAddressViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionListViewModel.h"

NS_ASSUME_NONNULL_BEGIN


/**
 返回某一个地址的相关交易列表
 覆盖了LXHTransactionListViewModel的transactionList方法
 */
@interface LXHTransactionListByAddressViewModel : LXHTransactionListViewModel

- (instancetype)initWithAddress:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
