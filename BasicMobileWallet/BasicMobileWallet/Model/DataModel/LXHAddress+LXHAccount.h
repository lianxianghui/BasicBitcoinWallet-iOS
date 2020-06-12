//
//  LXHAddress+LXHAccount.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/3.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddress (LXHAccount)

+ (LXHAddress *)addressWithBase58String:(NSString *)base58String;

- (void)refreshLocalProperties;

/**
 返回有效的地址，如果无效返回nil
 */
+ (NSString *)validAddress:(NSString *)address;
+ (NSDictionary *)bitcoinURIDic:(NSString *)bitcoinURI;
@end

NS_ASSUME_NONNULL_END
