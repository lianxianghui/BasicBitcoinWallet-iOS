//
//  LXHWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"

@interface LXHWallet ()
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) BTCKeychain *firstAccountKeychain;
@property (nonatomic) BTCKeychain *receivingKeychain;
@property (nonatomic) BTCKeychain *changeKeychain;
@property (nonatomic) NSInteger currentChangeAddressIndex;
@property (nonatomic) NSInteger currentReceivingAddressIndex;
@property (nonatomic, readwrite) LXHBitcoinNetworkType currentNetworkType;
@end

@implementation LXHWallet

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                       currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    self = [super init];
    if (self) {
        return [self initWithMnemonicCodeWords:mnemonicCodeWords mnemonicPassphrase:mnemonicPassphrase currentReceivingAddressIndex:0 currentChangeAddressIndex:0  currentNetworkType:currentNetworkType];
    }
    return self;
}

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
                       currentNetworkType:(LXHBitcoinNetworkType)currentNetworkType {
    self = [super init];
    if (self) {
        BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
        NSData *rootSeed = [mnemonic seed];
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

- (BTCKeychain *)firstAccountKeychain {
    if (!_firstAccountKeychain) {
        NSString *path;
        if (_currentNetworkType == LXHBitcoinNetworkTypeTestnet)
            path = @"m/44'/1'/0'";
        else
            path = @"m/44'/0'/0'";
        _firstAccountKeychain = [self.masterKeychain derivedKeychainWithPath:path];
    }
    return _firstAccountKeychain;
}

- (BTCKeychain *)receivingKeychain {
    if (!_receivingKeychain) {
        _receivingKeychain = [self.firstAccountKeychain derivedKeychainAtIndex:0 hardened:NO];
    }
    return _receivingKeychain;
}
  
- (BTCKeychain *)changeKeychain {
    if (!_changeKeychain) {
        _changeKeychain = [self.firstAccountKeychain derivedKeychainAtIndex:1 hardened:NO];
    }
    return _changeKeychain;
}

- (NSString *)receivingAddressWithIndex:(NSUInteger)index {
    BTCKey *key = [[self receivingKeychain] keyAtIndex:(uint32_t)index];
    NSString *address =  [self addressWithKey:key].string;
    return address;
}

- (NSArray *)receivingAddressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = fromIndex; i < fromIndex+count; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)receivingAddressesFromZeroToIndex:(NSUInteger)toIndex {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = 0; i <= toIndex; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSString *)changeAddressWithIndex:(NSUInteger)index {
    BTCKeychain *keychain = [[self changeKeychain] derivedKeychainAtIndex:(uint32_t)index];
    return [self addressWithKey:keychain.key].string;
}
 
- (BTCPublicKeyAddress *)addressWithKey:(BTCKey *)key {
    if (_currentNetworkType == LXHBitcoinNetworkTypeMainnet)
        return key.address;
    else
        return key.addressTestnet;
}

@end
