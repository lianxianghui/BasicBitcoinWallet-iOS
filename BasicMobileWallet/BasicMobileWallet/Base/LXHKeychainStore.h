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
#define kLXHPreferenceBitcoinNetworkType @"kLXHPreferenceBitcoinNetworkType"


NS_ASSUME_NONNULL_BEGIN

@interface LXHKeychainStore : NSObject
@property (nonatomic) UICKeyChainStore *store;

+ (instancetype)sharedInstance;

- (BOOL)saveData:(nullable NSData *)data forKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key error:(NSError **)error;
- (BOOL)saveString:(nullable NSString *)string forKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key error:(NSError **)error;


- (BOOL)saveMnemonicCodeWords:(nullable NSArray *)mnemonicCodeWords;
- (NSArray *)mnemonicCodeWordsWithErrorPointer:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
