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
@property (nonatomic) NSUInteger accountIndex;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic, readwrite) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *receiving;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *change;
@end

@implementation LXHAccount

- (instancetype)initWithAccountExtendedPublicKey:(NSString *)extendedPublicKey
                       accountIndex:(NSUInteger)accountIndex
       currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
          currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex {
    self = [super init];
    if (self) {
        _accountIndex = accountIndex;
        _accountKeychain = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey];
        _currentNetworkType = _accountKeychain.network.isMainnet ? LXHBitcoinNetworkTypeMainnet : LXHBitcoinNetworkTypeTestnet;
        _receiving = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeReceiving accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentReceivingAddressIndex];
        _change = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeChange accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentChangeAddressIndex];
    }
    return self;
}

- (NSArray *)usedAddresses {
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObjectsIfNotNil:[self.receiving usedAddresses]];
    [ret addObjectsIfNotNil:[self.change usedAddresses]];
    return ret;
}

- (NSArray *)usedAndCurrentAddresses {
    NSMutableArray *ret = [[self usedAddresses] mutableCopy];
    [ret addObjectIfNotNil:[self currentAddressWithType:LXHLocalAddressTypeReceiving]];
    [ret addObjectIfNotNil:[self currentAddressWithType:LXHLocalAddressTypeChange]];
    return ret;
}

- (NSInteger)currentAddressIndexWithType:(LXHLocalAddressType)type {
    return [self changeLeveWithType:type].currentAddressIndex;
}

- (NSString *)currentAddressWithType:(LXHLocalAddressType)type {
    return [[self changeLeveWithType:type] currentAddress];
}

- (NSString *)addressWithType:(LXHLocalAddressType)type index:(uint32_t)index {
    return [[self changeLeveWithType:type] addressStringWithIndex:index];
}

- (NSString *)addressPathWithType:(LXHLocalAddressType)type index:(uint32_t)index {
    return [[self changeLeveWithType:type] addressPathWithIndex:index]; 
}

- (NSArray *)usedAndCurrentAddressesWithType:(LXHLocalAddressType)type {
    return [[self changeLeveWithType:type] usedAndCurrentAddresses];
}

- (LXHWalletChangeLevelModel *)changeLeveWithType:(LXHLocalAddressType)type {
    LXHWalletChangeLevelModel *changeLevel = (type == LXHLocalAddressTypeReceiving) ? self.receiving : self.change;
    return changeLevel;
}

- (BOOL)isUsedAddressWithType:(LXHLocalAddressType)type index:(NSUInteger)index {
    return [[self changeLeveWithType:type] isUsedAddressWithIndex:index];
}

- (LXHAddress *)localAddressWithWithType:(LXHLocalAddressType)type index:(uint32_t)index {
    return [[self changeLeveWithType:type] localAddressWithIndex:index];
}

- (LXHAddress *)localAddressWithBase58Address:(nonnull NSString *)base58Address {
    LXHAddress *ret = nil;
    ret = [[self changeLeveWithType:LXHLocalAddressTypeChange] localAddressWithBase58Address:base58Address];
    if (!ret)
        ret = [[self changeLeveWithType:LXHLocalAddressTypeReceiving] localAddressWithBase58Address:base58Address];
    return ret;
}

- (NSData *)publicKeyWithLocalAddress:(LXHAddress *)localAddress {
    LXHWalletChangeLevelModel *changeLevel = [self changeLeveWithType:localAddress.localAddressType];
    NSString *index = [localAddress.localAddressPath lastPathComponent];
    return [changeLevel publicKeyAtIndex:(uint32_t)index.integerValue];
}

- (LXHAddress *)currentChangeAddress {
    return [[self changeLeveWithType:LXHLocalAddressTypeChange] currentLocalAddress];
}

- (LXHAddress *)currentReceingAddress {
    return [[self changeLeveWithType:LXHLocalAddressTypeReceiving] currentLocalAddress];
}

- (BOOL)updateUsedBase58AddressesIfNeeded:(NSSet<NSString *> *)usedBase58AddressesSet {
    __block BOOL ret = NO;
    NSArray *types = @[@(LXHLocalAddressTypeReceiving), @(LXHLocalAddressTypeChange)];
    [types enumerateObjectsUsingBlock:^(NSNumber  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger type = obj.unsignedIntegerValue;
        ret = ret || [[self changeLeveWithType:type] updateUsedBase58AddressesIfNeeded:usedBase58AddressesSet];
    }];
    return ret;
}

- (NSString *)extendedPublicKey {
    return _accountKeychain.extendedPublicKey;
}

- (LXHAddress *)scanLocalAddressWithPublicKeyHash:(NSData *)publicKeyHash {
    NSArray *types = @[@(LXHLocalAddressTypeReceiving), @(LXHLocalAddressTypeChange)];
    __block LXHAddress *ret = nil;
    [types enumerateObjectsUsingBlock:^(NSNumber  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger type = obj.unsignedIntegerValue;
        ret = [[self changeLeveWithType:type] scanLocalAddressWithPublicKeyHash:publicKeyHash];
        if (ret)
            *stop = YES;
    }];
    return ret;
}

- (LXHAddress *)localAddressWithPublicKeyHash:(NSData *)publicKeyHash {
    NSArray *types = @[@(LXHLocalAddressTypeReceiving), @(LXHLocalAddressTypeChange)];
    __block LXHAddress *ret = nil;
    [types enumerateObjectsUsingBlock:^(NSNumber  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger type = obj.unsignedIntegerValue;
        ret = [[self changeLeveWithType:type] localAddressWithPublicKeyHash:publicKeyHash];
        if (ret)
            *stop = YES;
    }];
    return ret;
}

- (void)clearSavedPublicKeys {
    for (NSInteger type = LXHLocalAddressTypeReceiving; type <= LXHLocalAddressTypeChange; type++) {
        [[self changeLeveWithType:type] clearSavedPublicKeys];
    }
}

@end
