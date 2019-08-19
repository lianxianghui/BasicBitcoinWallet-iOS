//
//  LXHKeychainStore.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/13.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

#define kLXHKeychainStorePIN @"PIN"
#define kLXHKeychainStoreMnemonicCodeWords @"MnemonicCodeWords"
#define kLXHKeychainStoreRootSeed @"RootSeed"
#define kLXHKeychainStoreCurrentChangeAddressIndex @"CurrentChangeAddressIndex"
#define kLXHKeychainStoreCurrentReceivingAddressIndex @"CurrentReceivingAddressIndex"
#define kLXHKeychainStoreBitcoinNetType @"kLXHKeychainStoreBitcoinNetType"


NS_ASSUME_NONNULL_BEGIN

@interface LXHKeychainStore : NSObject
@property (nonatomic) UICKeyChainStore *store;

+ (instancetype)sharedInstance;

- (BOOL)encryptAndSetData:(nullable NSData *)data forKey:(NSString *)key;
- (NSData *)decryptedDataForKey:(NSString *)key error:(NSError **)error;
- (BOOL)encryptAndSetString:(nullable NSString *)string forKey:(NSString *)key;
- (NSString *)decryptedStringForKey:(NSString *)key error:(NSError **)error;


- (BOOL)encryptAndSetMnemonicCodeWords:(nullable NSArray *)mnemonicCodeWords;
- (NSArray *)decryptedMnemonicCodeWordsWithErrorPointer:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
