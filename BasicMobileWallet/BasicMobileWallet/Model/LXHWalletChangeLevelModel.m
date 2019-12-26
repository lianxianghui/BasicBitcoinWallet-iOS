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
#import "BlocksKit.h"

@interface LXHWalletChangeLevelModel ()
@property (nonatomic) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic) LXHLocalAddressType addressType;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic, readwrite) uint32_t currentAddressIndex;
@property (nonatomic) NSArray<NSString *> *usedAddresses;
@property (nonatomic) NSString *currentAddress;
@property (nonatomic) BTCKeychain *keychain;
@property (nonatomic) NSMutableArray<BTCKeychain *> *cachedKeychains;
@property (nonatomic) NSMutableArray<NSData *> *cachedPublicKeyHashes;
@end

@implementation LXHWalletChangeLevelModel

- (instancetype)initWithBitcoinNetworkType:(LXHBitcoinNetworkType)currentNetworkType
                               addressType:(LXHLocalAddressType)addressType
                           accountKeychain:(id)accountKeychain
                       currentAddressIndex:(uint32_t)currentAddressIndex {
    self = [super init];
    if (self) {
        _currentNetworkType = currentNetworkType;
        _addressType = addressType;
        _accountKeychain = (BTCKeychain *)accountKeychain;
        _currentAddressIndex = currentAddressIndex;
        _cachedKeychains = [NSMutableArray array];
        _cachedPublicKeyHashes = [NSMutableArray array];
    }
    return self;
}

- (BTCKeychain *)keychain {
    if (!_keychain) {
        uint32_t changeLevelIndex = _addressType;
        _keychain = [self.accountKeychain derivedKeychainAtIndex:changeLevelIndex hardened:NO];
        _keychain.network = self.accountKeychain.network;
    }
//    NSLog(@"xpub:%@, length=%ld", self.accountKeychain.extendedPublicKey, self.accountKeychain.extendedPublicKey.length);
    return _keychain;
}

- (NSString *)addressPathWithIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"m/44'/%lu'/0'/%ld/%ld", (unsigned long)_currentNetworkType, _addressType, index];
}

- (NSString *)addressStringWithIndex:(uint32_t)index {
    BTCKeychain *keychain = [self keychainAtIndex:(uint32_t)index];
    keychain.network = self.keychain.network;
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
    if (!_usedAddresses) {
        NSArray *ret;
        if (_currentAddressIndex == 0)
            ret = nil;
        ret = [self addressesFromZeroToIndex:_currentAddressIndex-1];
        _usedAddresses = ret;
    }
    return _usedAddresses;
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
    if (!_currentAddress)
       _currentAddress = [self addressStringWithIndex:_currentAddressIndex];
    return _currentAddress;
}

- (LXHAddress *)currentLocalAddress {
    return [self localAddressWithIndex:_currentAddressIndex];
}

- (BOOL)isUsedAddressWithIndex:(NSUInteger)index {
    return index < [self usedAddresses].count;
}

- (LXHAddress *)localAddressWithIndex:(uint32_t)index {
    LXHAddress *localAddress = [LXHAddress new];
    localAddress.base58String = [self addressStringWithIndex:index];
    localAddress.isLocalAddress = YES;
    localAddress.localAddressPath = [self addressPathWithIndex:index];
    localAddress.localAddressType = self.addressType;
    localAddress.localAddressUsed = [self isUsedAddressWithIndex:index];
    return localAddress;
}

- (NSUInteger)localAddressIndexOfBase58Address:(nonnull NSString *)base58Address {
    NSArray *usedAndCurrentAddresses = [self usedAndCurrentAddresses];
    return [usedAndCurrentAddresses indexOfObject:base58Address];
}

- (LXHAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address {
    NSUInteger index = [self localAddressIndexOfBase58Address:base58Address];
    if (index != NSNotFound)
        return [self localAddressWithIndex:(uint32_t)index];
    else
        return nil;
}

- (NSData *)publicKeyAtIndex:(uint32_t)index {
    BTCKeychain *keychain = [self keychainAtIndex:(uint32_t)index];
    keychain.network = self.keychain.network;
    return keychain.key.publicKey;
}

- (BTCKeychain *)keychainAtIndex:(uint32_t)index {
    if (index < self.cachedKeychains.count)
        return self.cachedKeychains[index];
    NSUInteger fromIndex = self.cachedKeychains.count;
    NSUInteger toIndex = index;
    for (NSUInteger i = fromIndex; i <= toIndex; i++) {
         BTCKeychain *keychain = [self.keychain derivedKeychainAtIndex:(uint32_t)i];
        [self.cachedKeychains addObject:keychain];
    }
    return self.cachedKeychains[index];
}

- (NSData *)publicKeyHashAtIndex:(uint32_t)index {
    if (index < self.cachedPublicKeyHashes.count)
        return self.cachedPublicKeyHashes[index];
    NSUInteger fromIndex = self.cachedPublicKeyHashes.count;
    NSUInteger toIndex = index;
    for (NSUInteger i = fromIndex; i <= toIndex; i++) {
        NSData *publicKey = [self publicKeyAtIndex:(uint32_t)i];
        NSData *publicKeyHash = BTCHash160(publicKey);
        [self.cachedPublicKeyHashes addObject:publicKeyHash];
    }
    return self.cachedPublicKeyHashes[index];
    
//    NSData *publicKey = [self publicKeyAtIndex:(uint32_t)index];
//    NSData *publicKeyHash = BTCHash160(publicKey);
}

- (void)incrementCurrentAddressIndex {
    _currentAddressIndex = _currentAddressIndex + 1;
    _usedAddresses = nil;
    _currentAddress = nil;
}

- (BOOL)updateUsedBase58AddressesIfNeeded:(NSSet<NSString *> *)usedBase58AddressesSet {
    LXHAddress *currentAddress = [self currentLocalAddress];
    if ([usedBase58AddressesSet containsObject:currentAddress.base58String]) {
        [self incrementCurrentAddressIndex];
        [self updateUsedBase58AddressesIfNeeded:usedBase58AddressesSet];//检查下一个
        return YES;
    } else {
        return NO;
    }
}

- (LXHAddress *)scanLocalAddressWithPublicKeyHash:(NSData *)publicKeyHash {
    const uint32_t maxScanCount = 100;
    return [self scanLocalAddressWithPublicKeyHash:publicKeyHash maxScanCount:maxScanCount];
}

- (LXHAddress *)scanLocalAddressWithPublicKeyHash:(NSData *)publicKeyHash maxScanCount:(uint32_t)maxScanCount {
    for (uint32_t i = 0 ; i < maxScanCount; i++) {
        NSData *currentPublicKeyHash = [self publicKeyHashAtIndex:i];
        if ([currentPublicKeyHash isEqualToData:publicKeyHash])
            return [self localAddressWithIndex:i];
    }
    return nil;
}

- (LXHAddress *)localAddressWithPublicKeyHash:(NSData *)publicKeyHash {
    const uint32_t maxScanCount = _currentAddressIndex + 1;
    return [self scanLocalAddressWithPublicKeyHash:publicKeyHash maxScanCount:maxScanCount];
}

- (NSArray<NSData *> *)extendedPublicKeysFromIndex:(uint32_t)fromIndex toIndex:(uint32_t)toIndex {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSUInteger i = fromIndex; i <= toIndex; i++) {
        BTCKeychain *keychain = [self.keychain derivedKeychainAtIndex:(uint32_t)i];
        [ret addObject:keychain.extendedPublicKey];
    }
    return ret;
}

@end
