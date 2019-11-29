//
//  LXHWalletChangeLevelModel.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletChangeLevelModel.h"
#import "CoreBitcoin.h"
#import "NSMutableArray+Base.h"

@interface LXHWalletChangeLevelModel ()
@property (nonatomic) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic) LXHAddressType addressType;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic, readwrite) uint32_t currentAddressIndex;

@property (nonatomic) BTCKeychain *keychain;
@end

@implementation LXHWalletChangeLevelModel

- (instancetype)initWithBitcoinNetworkType:(LXHBitcoinNetworkType)currentNetworkType
                               addressType:(LXHAddressType)addressType
                           accountKeychain:(id)accountKeychain
                       currentAddressIndex:(uint32_t)currentAddressIndex {
    self = [super init];
    if (self) {
        _currentNetworkType = currentNetworkType;
        _addressType = addressType;
        _accountKeychain = (BTCKeychain *)accountKeychain;
        _currentAddressIndex = currentAddressIndex;
    }
    return self;
}

- (BTCKeychain *)keychain {
    if (!_keychain) {
        uint32_t changeLevelIndex = _addressType;
        _keychain = [self.accountKeychain derivedKeychainAtIndex:changeLevelIndex hardened:NO];
    }
    return _keychain;
}

- (NSString *)addressPathWithIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"m/44'/%ld'/0'/%ld/%ld", _currentNetworkType, _addressType, index];
}

- (NSString *)addressStringWithIndex:(uint32_t)index {
    BTCKeychain *keychain = [self.keychain derivedKeychainAtIndex:(uint32_t)index];
    BTCPublicKeyAddress *addressModel = [self addressModelWithKey:keychain.key];
    return addressModel.string;
}

- (BTCPublicKeyAddress *)addressModelWithKey:(BTCKey *)key {
    if (_currentNetworkType == LXHBitcoinNetworkTypeMainnet)
        return key.address;
    else
        return key.addressTestnet;
}

- (NSArray *)addressesFromIndex:(uint32_t)fromIndex count:(uint32_t)count {
    NSMutableArray *addresses = [NSMutableArray array];
    for (uint32_t i = fromIndex; i < fromIndex+count; i++) {
        [addresses addObject:[self addressStringWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)usedAddresses {
    if (_currentAddressIndex == 0)
        return nil;
    NSArray *ret = [self addressesFromZeroToIndex:_currentAddressIndex-1];
    return ret;
}

- (NSArray *)addressesFromZeroToIndex:(uint32_t)toIndex {
    NSMutableArray *addresses = [NSMutableArray array];
    for (uint32_t i = 0; i <= toIndex; i++) {
        [addresses addObject:[self addressStringWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)usedAndCurrentAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self usedAddresses]];
    [ret addObjectIfNotNil:[self currentAddress]];
    return ret;
}

- (NSString *)currentAddress {
    return [self addressStringWithIndex:_currentAddressIndex];
}

- (BOOL)isUsedAddressWithIndex:(NSUInteger)index {
    return index < [self usedAddresses].count;
}

- (LXHLocalAddress *)localAddressWithIndex:(uint32_t)index {
    LXHLocalAddress *localAddress = [LXHLocalAddress new];
    localAddress.addressString = [self addressStringWithIndex:index];
    localAddress.addressPath = [self addressPathWithIndex:index];
    localAddress.type = self.addressType;
    localAddress.used = [self isUsedAddressWithIndex:index];
    return localAddress;
}

- (NSUInteger)localAddressIndexOfBase58Address:(nonnull NSString *)base58Address {
    NSArray *usedAndCurrentAddresses = [self usedAndCurrentAddresses];
    return [usedAndCurrentAddresses indexOfObject:base58Address];
}

- (LXHLocalAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address {
    NSUInteger index = [self localAddressIndexOfBase58Address:base58Address];
    if (index != NSNotFound)
        return [self localAddressWithIndex:(uint32_t)index];
    else
        return nil;
}

@end
