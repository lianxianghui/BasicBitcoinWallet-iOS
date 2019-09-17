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

@interface LXHAccount ()
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic) BTCKeychain *receivingKeychain;
@property (nonatomic) BTCKeychain *changeKeychain;
@property (nonatomic, readwrite) NSInteger currentChangeAddressIndex;
@property (nonatomic, readwrite) NSInteger currentReceivingAddressIndex;
@property (nonatomic, readwrite) LXHBitcoinNetworkType currentNetworkType;
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


- (BTCKeychain *)receivingKeychain {
    if (!_receivingKeychain) {
        _receivingKeychain = [self.accountKeychain derivedKeychainAtIndex:0 hardened:NO];
    }
    return _receivingKeychain;
}

- (BTCKeychain *)changeKeychain {
    if (!_changeKeychain) {
        _changeKeychain = [self.accountKeychain derivedKeychainAtIndex:1 hardened:NO];
    }
    return _changeKeychain;
}

- (NSString *)currentReceivingAddress {
    return [self receivingAddressWithIndex:self.currentReceivingAddressIndex];
}

- (NSString *)currentReceivingAddressPath {
    return [self receivingAddressPathWithIndex:self.currentReceivingAddressIndex];
}

- (NSString *)currentChangeAddress {
    return [self receivingAddressWithIndex:self.currentChangeAddressIndex];
}

- (NSString *)currentChangeAddressPath {
    return [self changeAddressPathWithIndex:self.currentReceivingAddressIndex];
}

- (NSString *)receivingAddressPathWithIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"m/44'/%ld'/0'/0/%ld", self.currentNetworkType, index];
}

- (NSString *)changeAddressPathWithIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"m/44'/%ld'/0'/1/%ld", self.currentNetworkType, index];
}

- (NSString *)receivingAddressWithIndex:(NSUInteger)index {
    BTCKey *key = [[self receivingKeychain] keyAtIndex:(uint32_t)index];
    NSString *address = [self addressWithKey:key].string;
    return address;
}

- (NSArray *)receivingAddressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = fromIndex; i < fromIndex+count; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)usedReceivingAddresses {
    NSArray *ret = [self receivingAddressesFromZeroToIndex:_currentReceivingAddressIndex-1];
    return ret;
}

- (NSArray *)usedChangeAddresses {
    NSArray *ret = [self changeAddressesFromZeroToIndex:_currentChangeAddressIndex-1];
    return ret;
}

- (NSMutableArray *)usedAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self usedReceivingAddresses]];
    [ret addObjectsIfNotNil:[self usedChangeAddresses]];
    return ret;
}

- (NSArray *)usedAndCurrentAddresses {
    NSMutableArray *ret = [self usedAddresses];
    [ret addObjectIfNotNil:[self currentReceivingAddress]];
    [ret addObjectIfNotNil:[self currentChangeAddress]];
    return ret;
}

- (NSMutableArray *)usedAndCurrentReceivingAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self usedReceivingAddresses]];
    [ret addObjectIfNotNil:[self currentReceivingAddress]];
    return ret;
}

- (NSMutableArray *)usedAndCurrentChangeAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self usedChangeAddresses]];
    [ret addObjectIfNotNil:[self currentChangeAddress]];
    return ret;
}

- (NSArray *)receivingAddressesFromZeroToIndex:(NSInteger)toIndex {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSInteger i = 0; i <= toIndex; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)changeAddressesFromZeroToIndex:(NSInteger)toIndex {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSInteger i = 0; i <= toIndex; i++) {
        [addresses addObject:[self changeAddressWithIndex:i]];
    }
    return addresses;
}

- (NSString *)changeAddressWithIndex:(NSUInteger)index {
    BTCKeychain *keychain = [[self changeKeychain] derivedKeychainAtIndex:(uint32_t)index];
    return [self addressWithKey:keychain.key].string;
}

- (NSInteger)currentAddressIndexWithType:(LXHAddressType)type {
    return type == LXHAddressTypeReceiving ? self.currentReceivingAddressIndex : self.currentChangeAddressIndex;
}

- (NSString *)currentAddressWithType:(LXHAddressType)type {
    return type == LXHAddressTypeReceiving ? [self currentReceivingAddress] : [self currentChangeAddress];
}

- (NSString *)addressWithType:(LXHAddressType)type index:(NSUInteger)index {
    return type == LXHAddressTypeReceiving ? [self receivingAddressWithIndex:index] : [self changeAddressWithIndex:index];
}

- (NSString *)addressPathWithType:(LXHAddressType)type index:(NSUInteger)index {
    return type == LXHAddressTypeReceiving ? [self receivingAddressPathWithIndex:index] : [self changeAddressPathWithIndex:index];
}

- (NSMutableArray *)usedAndCurrentAddressesWithType:(LXHAddressType)type {
    return type == LXHAddressTypeReceiving ? [self usedAndCurrentReceivingAddresses] : [self usedAndCurrentChangeAddresses];
}

- (BTCPublicKeyAddress *)addressWithKey:(BTCKey *)key {
    if (_currentNetworkType == LXHBitcoinNetworkTypeMainnet)
        return key.address;
    else
        return key.addressTestnet;
}

@end
