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
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
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

//备注：为了简化逻辑，没有加入对用AES加密后的数据进行数据完整性验证的逻辑
- (BOOL)encryptAndSetData:(NSData *)data forKey:(NSString *)key {
    if (!data)
        return [self.store setData:nil forKey:key];
    
    NSError *error = nil;
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
        NSString *pin = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return pin;
    } else {
        return nil;
    }
}

- (BOOL)data:(NSData *)data isEqualToEncryptedDataForKey:(NSString *)key {
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:nil];
    if (!encryptedData)
        return NO;
    NSData *encryptedData1 = [self.store dataForKey:key];
    return [encryptedData isEqualToData:encryptedData1];
}

- (BOOL)string:(NSString *)string isEqualToEncryptedStringForKey:(NSString *)key {
    //TODO 能不能直接比较加密后的数据
    return [string isEqualToString:[self decryptedStringForKey:key error:nil]];
}

@end
