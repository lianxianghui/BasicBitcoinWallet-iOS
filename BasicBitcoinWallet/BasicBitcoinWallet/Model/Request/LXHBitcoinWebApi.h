//
//  LXHBitcoinWebApi.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LXHBitcoinWebApi

- (void)requestAllTransactionsWithAddresses:(NSArray<NSString *> *)addresses
                               successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

- (void)pushTransactionWithHex:(NSString *)hex
                  successBlock:(void (^)(NSDictionary *resultDic))successBlock
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;


- (void)requestTransactionsById:(NSString *)txid
                    successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@optional
- (void)requestTransactionsByIds:(NSArray<NSString *> *)txids
                               successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;



@end

NS_ASSUME_NONNULL_END
