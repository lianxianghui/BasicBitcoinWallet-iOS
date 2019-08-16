//
//  LXHWallet.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreBitcoin.h"

typedef NS_ENUM(NSUInteger, LXHBitcoinNetworkType) {
    LXHBitcoinNetworkTypeMainnet,
    LXHBitcoinNetworkTypeTestnet3,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHWallet : NSObject

- (NSString *)receivingAddressWithIndex:(NSUInteger)index;
- (NSString *)changeAddressWithIndex:(NSUInteger)index;
- (LXHBitcoinNetworkType)currentNetworkType;
@end

NS_ASSUME_NONNULL_END
