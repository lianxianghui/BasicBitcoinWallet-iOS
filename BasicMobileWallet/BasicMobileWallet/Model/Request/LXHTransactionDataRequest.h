//
//  LXHTransactionDataRequest.h
//  BasicMobileWallet
//
//  Created by lian on 2020/5/11.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinWebApiSmartbit.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHTransactionDataRequest : NSObject

/**
 * 请求成功后会把事务数据保存到文件，同时放到transactionList里
 */
+ (void)requestDataWithSuccessBlock:(nullable void (^)(NSDictionary *resultDic))successBlock
                       failureBlock:(nullable void (^)(NSDictionary *resultDic))failureBlock;

+ (void)requestTransactionsWithNetworkType:(LXHBitcoinNetworkType)type
                                 addresses:(NSArray *)addresses
                              successBlock:(void (^)(NSDictionary *resultDic))successBlock
                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

+ (void)requestTransactionsWithTxids:(NSArray *)txids
                        successBlock:(void (^)(NSDictionary *resultDic))successBlock
                        failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

+ (void)pushTransactionsWithHex:(NSString *)hex
                   successBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
