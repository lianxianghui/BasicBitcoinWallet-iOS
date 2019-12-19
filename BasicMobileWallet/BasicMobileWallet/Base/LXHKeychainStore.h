//
//  LXHKeychainStore.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHKeychainStore : NSObject
@property (nonatomic) UICKeyChainStore *store;

+ (instancetype)sharedInstance;

- (BOOL)encryptAndSetData:(nullable NSData *)data forKey:(NSString *)key;
- (NSData *)decryptedDataForKey:(NSString *)key error:(NSError **)error;
- (BOOL)encryptAndSetString:(nullable NSString *)string forKey:(NSString *)key;
- (NSString *)decryptedStringForKey:(NSString *)key error:(NSError **)error;

- (BOOL)data:(NSData *)data isEqualToEncryptedDataForKey:(NSString *)key;
- (BOOL)string:(NSString *)string isEqualToEncryptedStringForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
