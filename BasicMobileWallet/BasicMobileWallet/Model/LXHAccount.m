//
//  LXHAccount.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/24.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAccount.h"
#import "CoreBitcoin.h"
#import "NSMutableArray+Base.h"
#import "LXHWalletChangeLevelModel.h"

@interface LXHAccount ()
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic) BTCKeychain *receivingKeychain;
@property (nonatomic) BTCKeychain *changeKeychain;
@property (nonatomic, readwrite) NSInteger currentChangeAddressIndex;
@property (nonatomic, readwrite) NSInteger currentReceivingAddressIndex;
@property (nonatomic, readwrite) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *receiving;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *change;
@end

@implementation LXHAccount

- (instancetype)initWithRootSeed:(NSData *)rootSeed
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    self = [super init];
    if (self) {
        _masterKeychain = [[BTCKeychain alloc] initWithSeed:rootSeed];
        _currentReceivingAddressIndex = currentReceivingAddressIndex;
        _currentChangeAddressIndex = currentChangeAddressIndex;
        _currentNetworkType = currentNetworkType;
    }
    return self;
}

- (instancetype)initWithRootSeed:(NSData *)rootSeed currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    return [self initWithRootSeed:rootSeed currentReceivingAddressIndex:0 currentChangeAddressIndex:0 currentNetworkType:currentNetworkType];
}

- (BTCKeychain *)accountKeychain {
    NSString *path;
    if (_currentNetworkType == LXHBitcoinNetworkTypeTestnet)
        path = @"m/44'/1'/0'";
    else
        path = @"m/44'/0'/0'";
    return [_masterKeychain derivedKeychainWithPath:path];
}

- (LXHWalletChangeLevelModel *)receivingLevel {
    if (!_receiving) {
        _receiving = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHAddressTypeReceiving accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)_currentReceivingAddressIndex];
    }
    return _receiving;
}

- (LXHWalletChangeLevelModel *)changeLevel {
    if (!_change) {
        _change = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHAddressTypeChange accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)_currentChangeAddressIndex];
    }
    return _change;
}

- (NSArray *)usedAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self.receivingLevel usedAddresses]];
    [ret addObjectsIfNotNil:[self.changeLevel usedAddresses]];
    return ret;
}

- (NSArray *)usedAndCurrentAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectIfNotNil:[self usedAddresses]];
    [ret addObjectIfNotNil:[self currentAddressWithType:LXHAddressTypeReceiving]];
    [ret addObjectIfNotNil:[self currentAddressWithType:LXHAddressTypeChange]];
    return ret;
}

- (NSInteger)currentAddressIndexWithType:(LXHAddressType)type {
    return [self changeLeveWithType:type].currentAddressIndex;
}

- (NSString *)currentAddressWithType:(LXHAddressType)type {
    return [[self changeLeveWithType:type] currentAddress];
}

- (NSString *)addressWithType:(LXHAddressType)type index:(uint32_t)index {
    return [[self changeLeveWithType:type] addressStringWithIndex:index];
}

- (NSString *)addressPathWithType:(LXHAddressType)type index:(uint32_t)index {
    return [[self changeLeveWithType:type] addressPathWithIndex:index]; 
}

- (NSArray *)usedAndCurrentAddressesWithType:(LXHAddressType)type {
    return [[self changeLeveWithType:type] usedAndCurrentAddresses];
}

- (LXHWalletChangeLevelModel *)changeLeveWithType:(LXHAddressType)type {
    LXHWalletChangeLevelModel *changeLevel = (type == LXHAddressTypeReceiving) ? self.receiving : self.change;
    return changeLevel;
}

- (BOOL)isUsedAddressWithType:(LXHAddressType)type index:(NSUInteger)index {
    return [[self changeLeveWithType:type] isUsedAddressWithIndex:index];
}



@end
