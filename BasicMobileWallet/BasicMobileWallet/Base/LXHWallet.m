//
//  LXHWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"
#import "LXHKeychainStore.h"

@interface LXHWallet ()
@property (nonatomic) BTCKeychain *masterKeychain;
@property (nonatomic) BTCKeychain *firstAccountKeychain;
@property (nonatomic) BTCKeychain *receivingKeychain;
@property (nonatomic) BTCKeychain *changeKeychain;

@end

@implementation LXHWallet

+ (LXHWallet *)sharedInstance { 
    static LXHWallet *sharedInstance = nil;  
    static dispatch_once_t once;  
    dispatch_once(&once, ^{ 
        sharedInstance = [[self alloc] init];  
    });  
    return sharedInstance; 
}

- (BTCKeychain *)masterKeychain {
    if (!_masterKeychain) {
        NSError *error = nil;
        NSData* seed = [LXHKeychainStore.sharedInstance dataForKey:kLXHKeychainStoreRootSeed error:&error];
        if (!seed) 
            return nil;
        _masterKeychain = [[BTCKeychain alloc] initWithSeed:seed];
    }
    return _masterKeychain;
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

- (NSInteger)currentAddressIndexWithKey:(NSString *)key {
    NSError *error = nil;
    NSString *indexString = [[LXHKeychainStore sharedInstance] stringForKey:key error:&error];
    if (error)
        return -1;
    else {
        if (indexString)
            return indexString.integerValue;
        else
            return 0;
    }
}

- (NSInteger)currentChangeAddressIndex {
    return [self currentAddressIndexWithKey:kLXHKeychainStoreCurrentChangeAddressIndex];
}

- (NSInteger)currentReceivingAddressIndex {
    return [self currentAddressIndexWithKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
}

- (LXHBitcoinNetworkType)currentNetworkType {
    NSString *typeString = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHPreferenceBitcoinNetworkType];
    if (!typeString)
        return LXHBitcoinNetworkTypeTestnet3;
    else
        return typeString.integerValue;
}

@end
