//
//  LXHWalletDataManager.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletDataManager.h"
#import "LXHKeychainStore.h"
#import "LXHWalletAddressSearcher.h"
#import "CoreBitcoin.h"

@implementation LXHWalletDataManager

+ (LXHWalletDataManager *)sharedInstance { 
    static LXHWalletDataManager *sharedInstance = nil;  
    static dispatch_once_t once;  
    dispatch_once(&once, ^{ 
        sharedInstance = [[self alloc] init];  
    });  
    return sharedInstance;
}

- (BOOL)generateNewWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                       mnemonicPassphrase:(NSString *)mnemonicPassphrase {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveResult = [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:mnemonicCodeWords];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance saveData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    if (!saveResult) {
        [self reset];
    }
    return saveResult;
}

- (void)restoreExistWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                        mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveResult = [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:mnemonicCodeWords];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance saveData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    //TODO
}


- (BOOL)reset {
    BOOL saveResult = [LXHKeychainStore.sharedInstance saveMnemonicCodeWords:nil];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance saveData:nil forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    return saveResult;
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
