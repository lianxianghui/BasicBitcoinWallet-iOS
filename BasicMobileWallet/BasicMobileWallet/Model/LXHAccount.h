//
//  LXHAccount.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/24.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LXHAddressType) {
    LXHAddressTypeReceiving = 0,
    LXHAddressTypeChange = 1,
};

@interface LXHAccount : NSObject

@property (nonatomic, readonly) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic, readonly) NSInteger currentChangeAddressIndex;
@property (nonatomic, readonly) NSInteger currentReceivingAddressIndex;

- (instancetype)initWithRootSeed:(NSData *)rootSeed
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (instancetype)initWithRootSeed:(NSData *)rootSeed
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType;

- (NSString *)currentReceivingAddress;
- (NSString *)currentChangeAddress;


- (NSString *)receivingAddressWithIndex:(NSUInteger)index;
- (NSString *)changeAddressWithIndex:(NSUInteger)index;

- (NSArray *)receivingAddressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count;

- (NSString *)currentReceivingAddressPath;
- (NSString *)currentChangeAddressPath;
- (NSString *)receivingAddressPathWithIndex:(NSUInteger)index;
- (NSString *)changeAddressPathWithIndex:(NSUInteger)index;


- (NSMutableArray *)usedAddresses;
- (NSArray *)usedAndCurrentAddresses;

- (NSMutableArray *)usedAndCurrentReceivingAddresses;
- (NSMutableArray *)usedAndCurrentChangeAddresses;

- (NSInteger)currentAddressIndexWithType:(LXHAddressType)type;
- (NSString *)currentAddressWithType:(LXHAddressType)type;
- (NSString *)addressWithType:(LXHAddressType)type index:(NSUInteger)index;
- (NSString *)addressPathWithType:(LXHAddressType)typ index:(NSUInteger)index;
- (NSMutableArray *)usedAndCurrentAddressesWithType:(LXHAddressType)type;
@end

NS_ASSUME_NONNULL_END
