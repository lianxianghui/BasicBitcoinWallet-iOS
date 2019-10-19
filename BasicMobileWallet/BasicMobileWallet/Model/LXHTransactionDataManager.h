//
//  TransactionDataManager.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 管理交易数据：包括请求数据、持有数据、缓存数据到本地文件、从本地缓存文件加载数据 等功能
 */
@interface LXHTransactionDataManager : NSObject
@property (nonatomic) NSArray *transactionList;
/**
 * 请求成功后会把事务数据保存到文件，同时放到transactionList里
 */
- (void)requestDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                       failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

- (void)clearCachedData;
+ (instancetype)sharedInstance;

+ (void)requestTransactionsWithNetworkType:(LXHBitcoinNetworkType)type
                                 addresses:(NSArray *)addresses
                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

/**
 从全部交易列表里过滤出 输入地址或输出地址为address的交易
 */
- (NSArray *)transactionListByAddress:(NSString *)address;
@end

NS_ASSUME_NONNULL_END
