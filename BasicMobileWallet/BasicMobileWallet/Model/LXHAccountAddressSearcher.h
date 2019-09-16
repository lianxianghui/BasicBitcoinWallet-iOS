//
//  LXHAccountAddressSearcher.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHAccount.h"

NS_ASSUME_NONNULL_BEGIN

/**
 搜索比特币网络交易，找到准备使用的下一个接收地址和下一个找零地址
 恢复钱包时用到这个功能
 */
@interface LXHAccountAddressSearcher : NSObject

- (instancetype)initWithAccount:(LXHAccount *)account;
- (void)searchWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
