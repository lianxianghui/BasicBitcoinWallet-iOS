//
//  LXHWalletChangeLevelModel.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "LXHAddress.h"

NS_ASSUME_NONNULL_BEGIN

#define kLXHKeychainStoreCurrentChangeAddressIndex @"CurrentChangeAddressIndex"
#define kLXHKeychainStoreCurrentReceivingAddressIndex @"CurrentReceivingAddressIndex"

/**
 * 代表 ”m/44'/coin_type'/account'/change/address_index“路径中 change级别的模型对象
 */
@interface LXHWalletChangeLevelModel : NSObject
- (instancetype)initWithBitcoinNetworkType:(LXHBitcoinNetworkType)currentNetworkType
                               addressType:(LXHLocalAddressType)addressType
                           accountKeychain:(id)accountKeychain
                       currentAddressIndex:(uint32_t)currentAddressIndex;

@property (nonatomic) uint32_t currentAddressIndex;//setCurrentAddressIndex有可能比较耗时

- (NSArray *)addressesFromIndex:(uint32_t)fromIndex count:(uint32_t)count;
- (NSString *)addressStringWithIndex:(uint32_t)index;
- (NSString *)addressPathWithIndex:(NSUInteger)index;
- (BOOL)isUsedAddressWithIndex:(NSUInteger)index;
- (NSString *)currentAddress;
- (NSArray *)usedAddresses;
- (NSArray *)usedAndCurrentAddresses;
- (LXHAddress *)localAddressWithIndex:(uint32_t)index;
- (LXHAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address;
- (LXHAddress *)currentLocalAddress;
- (NSData *)publicKeyAtIndex:(uint32_t)index;
- (BOOL)updateUsedBase58AddressesIfNeeded:(NSSet<NSString *> *)usedBase58AddressesSet;

/**
 从本地查找该公钥哈希，找到了就返回一个LXHAddress对象。
 目前最大扫描数量都为10000
 */
- (LXHAddress *)scanLocalAddressWithPublicKeyHash:(NSData *)publicKeyHash;
- (LXHAddress *)localAddressWithPublicKeyHash:(NSData *)publicKeyHash;

- (NSArray<NSData *> *)extendedPublicKeysFromIndex:(uint32_t)fromIndex toIndex:(uint32_t)toIndex;

- (void)clearSavedPublicKeys;
@end



NS_ASSUME_NONNULL_END