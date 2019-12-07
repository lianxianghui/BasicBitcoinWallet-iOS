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
        _currentNetworkType = currentNetworkType;
        _receiving = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeReceiving accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentReceivingAddressIndex];
        _change = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeChange accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentChangeAddressIndex];
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

- (NSData *)signatureWithLocalAddress:(LXHAddress *)localAddress hash:(NSData *)hash {
    LXHWalletChangeLevelModel *changeLevel = [self changeLeveWithType:localAddress.localAddressType];
    NSString *index = [localAddress.localAddressPath lastPathComponent];
    return [changeLevel signatureWithIndex:(uint32_t)index.integerValue hash:hash];
}

- (NSData *)publicKeyWithLocalAddress:(LXHAddress *)localAddress {
    LXHWalletChangeLevelModel *changeLevel = [self changeLeveWithType:localAddress.localAddressType];
    NSString *index = [localAddress.localAddressPath lastPathComponent];
    return [changeLevel publicKeyWithIndex:(uint32_t)index.integerValue];
}

- (LXHAddress *)currentChangeAddress {
    return [[self changeLeveWithType:LXHLocalAddressTypeChange] currentLocalAddress];
}

@end
