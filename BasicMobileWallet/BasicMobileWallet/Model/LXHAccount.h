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

- (NSInteger)currentAddressIndexWithType:(LXHAddressType)type;
- (NSString *)currentAddressWithType:(LXHAddressType)type;
- (NSString *)addressWithType:(LXHAddressType)type index:(uint32_t)index;
- (NSString *)addressPathWithType:(LXHAddressType)typ index:(uint32_t)index;
- (NSArray *)usedAndCurrentAddressesWithType:(LXHAddressType)type;
- (BOOL)isUsedAddressWithType:(LXHAddressType)type index:(NSUInteger)index;

- (LXHLocalAddress *)localAddressWithWithType:(LXHAddressType)type index:(uint32_t)index;
- (LXHLocalAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address;
@end

NS_ASSUME_NONNULL_END
