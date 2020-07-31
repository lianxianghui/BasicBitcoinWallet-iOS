//
//  LXHBitcoinNetwork.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/1/8.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinNetwork.h"

@implementation LXHBitcoinNetwork

+ (NSString *)networkStringWithType:(LXHBitcoinNetworkType)type {
    if (type == LXHBitcoinNetworkTypeMainnet)
        return @"mainnet";
    else if(type == LXHBitcoinNetworkTypeTestnet)
        return @"testnet";
    else
        return @"undefined";
}

+ (LXHBitcoinNetworkType)networkTypeWithString:(NSString *)string {
    if ([string isEqualToString:@"mainnet"])
        return LXHBitcoinNetworkTypeMainnet;
    else if ([string isEqualToString:@"testnet"])
        return LXHBitcoinNetworkTypeTestnet;
    else
        return LXHBitcoinNetworkTypeUndefined;
}

@end
