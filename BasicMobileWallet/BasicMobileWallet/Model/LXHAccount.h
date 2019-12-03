//
//  LXHAccount.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/24.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "LXHWalletChangeLevelModel.h"

NS_ASSUME_NONNULL_BEGIN


/**
 地址分接收地址和找零地址
 地址分用过的地址和未用过的。currentAddresses指目前第一个还未被用过的地址
 */
@interface LXHAccount : NSObject

@property (nonatomic, readonly) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic, readonly) LXHWalletChangeLevelModel *receiving;
@property (nonatomic, readonly) LXHWalletChangeLevelModel *change;

- (instancetype)initWithRootSeed:(NSData *)rootSeed
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (instancetype)initWithRootSeed:(NSData *)rootSeed
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;


- (NSArray *)usedAddresses;
- (NSArray *)usedAndCurrentAddresses;

- (NSInteger)currentAddressIndexWithType:(LXHLocalAddressType)type;
- (NSString *)currentAddressWithType:(LXHLocalAddressType)type;
- (NSString *)addressWithType:(LXHLocalAddressType)type index:(uint32_t)index;
- (NSString *)addressPathWithType:(LXHLocalAddressType)typ index:(uint32_t)index;
- (NSArray *)usedAndCurrentAddressesWithType:(LXHLocalAddressType)type;
- (BOOL)isUsedAddressWithType:(LXHLocalAddressType)type index:(NSUInteger)index;


- (LXHAddress *)localAddressWithWithType:(LXHLocalAddressType)type index:(uint32_t)index;
- (LXHAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address;
- (LXHAddress *)currentChangeAddress;
@end

NS_ASSUME_NONNULL_END
