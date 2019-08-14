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

NS_ASSUME_NONNULL_BEGIN

@interface LXHKeychainStore : NSObject
@property (nonatomic) UICKeyChainStore *store;

+ (instancetype)sharedInstance;

- (BOOL)saveString:(NSString *)string forKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
