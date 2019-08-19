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

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase;

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
                       currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (instancetype)initWithRootSeed:(NSData *)rootSeed;
- (instancetype)initWithRootSeed:(NSData *)rootSeed
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (NSString *)receivingAddressWithIndex:(NSUInteger)index;
- (NSString *)changeAddressWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
