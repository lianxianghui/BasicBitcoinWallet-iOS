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
/**
 bitcoin URI scheme from bip21
 bitcoin:<address>[?amount=<amount>][?label=<label>][?message=<message>]
 目前返回的Dic只包含address和amount
 */
+ (NSDictionary *)bitcoinURIDic:(NSString *)bitcoinURI;
@end

NS_ASSUME_NONNULL_END
