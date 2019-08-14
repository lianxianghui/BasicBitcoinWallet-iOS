//
//  LXHKeychainStore.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHKeychainStore.h"
#import "BTCData.h"

#import <RNCryptor/RNCryptor.h>
#import <RNCryptor/RNDecryptor.h>
#import <RNCryptor/RNEncryptor.h>


@interface LXHKeychainStore ()
@end

static NSString *const kKeychainStoreServiceKey = @"org.lianxianghui.keychain.store.basic.wallet";
static NSString *const aesPassword = @"serefddetggg"; //TODO 随便写的，用你自己的代替


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

//备注：为了简化逻辑，没有加入对用AES加密后的数据进行验证的逻辑
- (BOOL)saveString:(NSString *)string forKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
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

- (NSString *)stringForKey:(NSString *)key error:(NSError **)error {
    NSData *encryptedData = [self.store dataForKey:key];
    if (!encryptedData) {
        return nil;
    }
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withPassword:aesPassword error:error];
    if (decryptedData) {
        NSString *pin = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        return pin;
    } else {
        return nil;
    }
}

- (void)saveMnemonic:(NSArray *)mnemonicWords {
    NSData *data = [[mnemonicWords componentsJoinedByString:@" "] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:&error];
    [LXHKeychainStore.sharedInstence.store setData:encryptedData forKey:kLXHKeychainStoreMnemonicCodeWords];
}

@end
