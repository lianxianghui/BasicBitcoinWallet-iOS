//
//  LXHBitcoinfeesNetworkRequest.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/10/23.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHBitcoinfeesNetworkRequest : NSObject

+ (instancetype)sharedInstance;

- (void)requestWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

@end

NS_ASSUME_NONNULL_END
