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
    LXHBitcoinNetworkTypeTestnet = 0,
    LXHBitcoinNetworkTypeMainnet = 1, 
};

NS_ASSUME_NONNULL_BEGIN

/**
 * 按着BIP44标准管理地址钱包对象 
 * 目前只支持一个账号，也就是按着”m/44'/coin_type'/account'/change/address_index“路径 account为0的账户
 * BIP44标准请参考 https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki
 */
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
- (NSArray *)receivingAddressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count;
- (NSArray *)receivingAddressesFromZeroToIndex:(NSUInteger)toIndex;
- (NSString *)changeAddressWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
