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
    LXHBitcoinNetworkTypeMainnet = 0, 
    LXHBitcoinNetworkTypeTestnet3 = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHWallet : NSObject

@property (nonatomic, readonly) LXHBitcoinNetworkType currentNetworkType;

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                       currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
                       currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (instancetype)initWithRootSeed:(NSData *)rootSeed currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;;
- (instancetype)initWithRootSeed:(NSData *)rootSeed
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (NSString *)receivingAddressWithIndex:(NSUInteger)index;
- (NSString *)changeAddressWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
