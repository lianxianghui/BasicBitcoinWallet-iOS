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
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) BTCKeychain *accountKeychain;
@property (nonatomic, readwrite) LXHBitcoinNetworkType currentNetworkType;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *receiving;
@property (nonatomic, readwrite) LXHWalletChangeLevelModel *change;

@property (nonatomic) NSString *xpub;
@end

@implementation LXHAccount

- (instancetype)initWithRootSeed:(NSData *)rootSeed
                    accountIndex:(NSUInteger)accountIndex
    currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
       currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
              currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    self = [super init];
    if (self) {
        BTCNetwork *network = currentNetworkType == LXHBitcoinNetworkTypeMainnet ? BTCNetwork.mainnet : BTCNetwork.testnet;
        _masterKeychain = [[BTCKeychain alloc] initWithSeed:rootSeed network:network];
        _accountIndex = accountIndex;
        _currentNetworkType = currentNetworkType;
        _receiving = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeReceiving accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentReceivingAddressIndex];
        _change = [[LXHWalletChangeLevelModel alloc] initWithBitcoinNetworkType:_currentNetworkType addressType:LXHLocalAddressTypeChange accountKeychain:self.accountKeychain currentAddressIndex:(uint32_t)currentChangeAddressIndex];
    }
    return self;
}

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

- (instancetype)initWithRootSeed:(NSData *)rootSeed currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    return [self initWithRootSeed:rootSeed accountIndex:0 currentReceivingAddressIndex:0 currentChangeAddressIndex:0 currentNetworkType:currentNetworkType];
}

//- (BTCKeychain *)accountKeychain {
//    if (!_accountKeychain) {
//        NSString *pathFormat;
//        if (_currentNetworkType == LXHBitcoinNetworkTypeTestnet)
//            pathFormat = @"m/44'/1'/%ld'";
//        else
//            pathFormat = @"m/44'/0'/%ld'";
//        NSString *path = [NSString stringWithFormat:pathFormat, _accountIndex];
//        _accountKeychain = [_masterKeychain derivedKeychainWithPath:path];
//        _accountKeychain.network = _masterKeychain.network;
//    }
//    return _accountKeychain;
//}

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

@end
