//
//  LXHAddress+LXHAccount.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/3.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddress+LXHAccount.h"
#import "LXHWallet.h"
#import "BTCAddress.h"
#import "NSString+Base.h"

@implementation LXHAddress (LXHAccount)

+ (LXHAddress *)addressWithBase58String:(NSString *)base58String;{
    LXHAddress *address = [LXHWallet.mainAccount localAddressWithBase58Address:base58String];
    if (address) {
        return address;
    } else {
        LXHAddress *address = [LXHAddress new];
        address.base58String = base58String;
        return address;
    }
}

- (void)refreshLocalProperties {
    LXHAddress *address = [LXHAddress addressWithBase58String:self.base58String];
    if (address.isLocalAddress) {
        self.isLocalAddress = YES;
        self.localAddressUsed = address.localAddressUsed;
        self.localAddressPath = address.localAddressPath;
        self.localAddressType = address.localAddressType;
    }
}

/**
 返回有效的地址，如果无效返回nil
 */
+ (NSString *)validAddress:(NSString *)address {
    address = [address stringByTrimmingWhiteSpace];
    address = [address stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
    BTCAddress *btcAddress = [BTCAddress addressWithString:address];
    if (btcAddress) {
        LXHBitcoinNetworkType addressNetworkType = btcAddress.isTestnet ? LXHBitcoinNetworkTypeTestnet : LXHBitcoinNetworkTypeMainnet;
        if (addressNetworkType == [LXHWallet mainAccount].currentNetworkType)
            return address;
    }
    return nil;
}

@end
