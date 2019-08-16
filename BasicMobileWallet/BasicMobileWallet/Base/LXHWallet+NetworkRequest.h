//
//  LXHWallet+NetworkRequest.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWallet (NetworkRequest)

- (void)findLastUsedReceivingAddressIndexWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                             failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
- (NSInteger)lastUsedChangeAddressIndexWithAllTransactions:(NSArray *)transactions;

- (void)requestAllTransactionsWithLastUsedReceivingAddressIndex:(NSInteger)lastUsedReceivingAddressIndex
                                                   successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
