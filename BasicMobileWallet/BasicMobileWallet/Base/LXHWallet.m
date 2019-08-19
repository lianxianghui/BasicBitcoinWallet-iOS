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
@property (nonatomic) LXHBitcoinNetworkType currentNetworkType;
@end

@implementation LXHWallet

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase {
    self = [super init];
    if (self) {
        return [self initWithMnemonicCodeWords:mnemonicCodeWords mnemonicPassphrase:mnemonicPassphrase currentChangeAddressIndex:0 currentReceivingAddressIndex:0 currentNetworkType:LXHBitcoinNetworkTypeTestnet3];
    }
    return self;
}

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex
             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
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

- (BTCKeychain *)firstAccountKeychain {
    if (!_firstAccountKeychain) {
        NSString *path;
        if ([self currentNetworkType] == LXHBitcoinNetworkTypeTestnet3)
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
    BTCKeychain *keychain = [[self receivingKeychain] derivedKeychainAtIndex:(uint32_t)index];
    return keychain.key.address.string;
}

- (NSString *)changeAddressWithIndex:(NSUInteger)index {
    BTCKeychain *keychain = [[self changeKeychain] derivedKeychainAtIndex:(uint32_t)index];
    return keychain.key.address.string;
}

@end
