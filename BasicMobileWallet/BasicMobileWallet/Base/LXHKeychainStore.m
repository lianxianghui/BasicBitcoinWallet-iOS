//
//  LXHKeychainStore.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHKeychainStore.h"
#import "BTCData.h"
#import "LXHGlobalHeader.h"

#import <RNCryptor/RNCryptor.h>
#import <RNCryptor/RNDecryptor.h>
#import <RNCryptor/RNEncryptor.h>


@interface LXHKeychainStore ()
@end

static NSString *const kKeychainStoreServiceKey = @"org.lianxianghui.keychain.store.basic.wallet";
static NSString *const aesPassword = LXHAESPassword;


@implementation LXHKeychainStore

+ (instancetype)sharedInstance {
    static LXHKeychainStore *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[LXHKeychainStore alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _store = [UICKeyChainStore keyChainStoreWithService:kKeychainStoreServiceKey];
        _store.accessibility = UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly;//For Security
    }
    return self;
}

- (BOOL)encryptAndSetData:(NSData *)data forKey:(NSString *)key {
    if (!data)
        return [self.store setData:nil forKey:key];
    
    NSError *error = nil;
    //This generates an NSData including a header, encryption salt, HMAC salt, IV, ciphertext, and HMAC
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:&error];
    if (encryptedData) {
        return [self.store setData:encryptedData forKey:key];
    } else {
        return NO;
    }
}

- (NSData *)decryptedDataForKey:(NSString *)key error:(NSError **)error {
    NSData *encryptedData = [self.store dataForKey:key];
    if (!encryptedData) {
        return nil;
    }
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withSettings:kRNCryptorAES256Settings password:aesPassword error:error];
    return decryptedData;
}

- (BOOL)encryptAndSetString:(NSString *)string forKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self encryptAndSetData:data forKey:key];
}

- (NSString *)decryptedStringForKey:(NSString *)key error:(NSError **)error {
    NSData *data = [self decryptedDataForKey:key error:error];
    if (data) {
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return ret;
    } else {
        return nil;
    }
}

- (BOOL)data:(NSData *)data isEqualToEncryptedDataForKey:(NSString *)key {
    return [data isEqualToData:[self decryptedDataForKey:key error:nil]];
}

- (BOOL)string:(NSString *)string isEqualToEncryptedStringForKey:(NSString *)key {
    return [string isEqualToString:[self decryptedStringForKey:key error:nil]];
}

@end
