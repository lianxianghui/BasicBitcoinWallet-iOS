//
//  LXHBitcoinNetwork.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/1/8.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LXHBitcoinNetworkType) { //do not modify
    LXHBitcoinNetworkTypeTestnet = 1,
    LXHBitcoinNetworkTypeMainnet = 0,
    LXHBitcoinNetworkTypeUndefined = -1,
};

@interface LXHBitcoinNetwork : NSObject

+ (NSString *)networkStringWithType:(LXHBitcoinNetworkType)type;
+ (LXHBitcoinNetworkType)networkTypeWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
