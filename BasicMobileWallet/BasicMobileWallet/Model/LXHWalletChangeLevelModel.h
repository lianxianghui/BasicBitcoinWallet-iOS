//
//  LXHWalletChangeLevelModel.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"
#import "LXHLocalAddress.h"

NS_ASSUME_NONNULL_BEGIN



/**
 * 代表 ”m/44'/coin_type'/account'/change/address_index“路径中 change级别的模型对象
 */
@interface LXHWalletChangeLevelModel : NSObject
- (instancetype)initWithBitcoinNetworkType:(LXHBitcoinNetworkType)currentNetworkType
                               addressType:(LXHAddressType)addressType
                           accountKeychain:(id)accountKeychain
                       currentAddressIndex:(uint32_t)currentAddressIndex;

@property (nonatomic, readonly) uint32_t currentAddressIndex;

- (NSArray *)addressesFromIndex:(uint32_t)fromIndex count:(uint32_t)count;
- (NSString *)addressStringWithIndex:(uint32_t)index;
- (NSString *)addressPathWithIndex:(NSUInteger)index;
- (BOOL)isUsedAddressWithIndex:(NSUInteger)index;
- (NSString *)currentAddress;
- (NSArray *)usedAddresses;
- (NSArray *)usedAndCurrentAddresses;
- (LXHLocalAddress *)localAddressWithIndex:(uint32_t)index;
- (LXHLocalAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address;
@end



NS_ASSUME_NONNULL_END
