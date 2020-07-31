//
//  TransactionDataManager.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"
#import "LXHTransaction.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 管理交易数据：持有数据、缓存数据到本地文件、从本地缓存文件加载数据 等功能
 */
@interface LXHTransactionDataManager : NSObject
@property (nonatomic, readonly) NSDictionary *transactionData;
@property (nonatomic, readonly) NSArray *transactionList;
@property (nonatomic, readonly) NSDate *dataUpdatedTime;

- (void)clearCachedData;
+ (instancetype)sharedInstance;

/**
 从全部交易列表里过滤出 输入地址或输出地址为address的交易
 */
- (NSArray *)transactionListByAddress:(NSString *)address;
- (LXHTransaction *)transactionByTxid:(NSString *)txid;
- (NSMutableArray<LXHTransactionOutput *> *)utxosOfAllTransactions;
- (NSDecimalNumber *)balance;
- (NSMutableSet *)allBase58Addresses;

- (BOOL)setAndSaveTransactionList:(NSArray *)transactionList;

+ (void)addTransaction:(LXHTransaction *)transaction toArray:(NSMutableArray *)array;
+ (void)updateOldTransactionToNewTransaction:(LXHTransaction *)newTransaction inArray:(NSMutableArray *)array;
@end

NS_ASSUME_NONNULL_END
