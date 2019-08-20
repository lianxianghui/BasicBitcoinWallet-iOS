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

- (LXHWallet *)wallet {
    if (!_wallet) {
        NSData *rootSeed = [[LXHKeychainStore sharedInstance] decryptedDataForKey:kLXHKeychainStoreRootSeed error:nil];
        NSString *receivingAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        NSString *changeAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentChangeAddressIndex];
        NSString *netType = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreBitcoinNetType];
        if (rootSeed && receivingAddressIndex && changeAddressIndex && netType) {
            _wallet = [[LXHWallet alloc] initWithRootSeed:rootSeed 
                             currentReceivingAddressIndex:receivingAddressIndex.integerValue 
                                currentChangeAddressIndex:changeAddressIndex.integerValue
                                       currentNetworkType:netType.integerValue];
        }
    }
    return _wallet;
}

- (BOOL)generateNewWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                                    netType:(LXHBitcoinNetworkType)netType{
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetMnemonicCodeWords:mnemonicCodeWords];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(netType).stringValue forKey:kLXHKeychainStoreBitcoinNetType];
    if (!saveResult) {
        [self clearData];
    }
    return saveResult;
}

-(void)restoreExistWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                        mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                            netType:(LXHBitcoinNetworkType)netType
                                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    LXHWallet *wallet = [[LXHWallet alloc] initWithRootSeed:rootSeed currentNetworkType:netType];
    LXHWalletAddressSearcher *searcher = [[LXHWalletAddressSearcher alloc] initWithWallet:wallet];
    [searcher searchWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *lastUsedReceivingAddressIndex = resultDic[@"lastUsedReceivingAddressIndex"];
        NSNumber *lastUsedChangeAddressIndex = resultDic[@"lastUsedChangeAddressIndex"];
        NSString *currentReceivingAddressIndex = [NSString stringWithFormat:@"%ld", lastUsedReceivingAddressIndex.integerValue+1];
        NSString *currentChangeAddressIndex = [NSString stringWithFormat:@"%ld", lastUsedChangeAddressIndex.integerValue+1];
        
        BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetMnemonicCodeWords:mnemonicCodeWords];
        saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:rootSeed forKey:kLXHKeychainStoreRootSeed];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:currentReceivingAddressIndex forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:currentChangeAddressIndex forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(netType).stringValue forKey:kLXHKeychainStoreBitcoinNetType];
        if (!saveResult) {
            [self clearData];
            failureBlock(nil);
        } else {
            successBlock(resultDic);//has @"allTransactions":allTransaction
        }
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(nil);
    }];
}

- (BOOL)clearData {
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetMnemonicCodeWords:nil];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreBitcoinNetType];
    return saveResult;
}


- (NSInteger)currentAddressIndexWithKey:(NSString *)key {
    NSError *error = nil;
    NSString *indexString = [[LXHKeychainStore sharedInstance] decryptedStringForKey:key error:&error];
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
    NSString *typeString = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreBitcoinNetType];
    if (!typeString)
        return LXHBitcoinNetworkTypeTestnet;
    else
        return typeString.integerValue;
}

@end
