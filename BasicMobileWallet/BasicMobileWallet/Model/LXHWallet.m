//
//  LXHWallet.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"
#import "CoreBitcoin.h"
#import "LXHKeychainStore.h"
#import "LXHAccountAddressSearcher.h"
#import "CoreBitcoin.h"
#import "LXHAccount.h"
#import "LXHTransactionDataManager.h"

//for wallet
#define kLXHKeychainStoreMnemonicCodeWords @"MnemonicCodeWords" //AES encrypt 
#define kLXHKeychainStoreRootSeed @"RootSeed" //AES encrypt 
#define kLXHKeychainStoreBitcoinNetType @"kLXHKeychainStoreBitcoinNetType"
#define kLXHKeychainStoreWalletDataGenerated @"kLXHKeychainStoreWalletDataGenerated"

//for first Account
#define kLXHKeychainStoreCurrentChangeAddressIndex @"CurrentChangeAddressIndex" 
#define kLXHKeychainStoreCurrentReceivingAddressIndex @"CurrentReceivingAddressIndex"

@interface LXHWallet ()
@property (nonatomic, readwrite) LXHAccount *mainAccount;
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

+ (LXHAccount *)mainAccount {
    return [self sharedInstance].mainAccount;
}

- (LXHAccount *)mainAccount {
    if (!_mainAccount) {
        NSData *rootSeed = [[LXHKeychainStore sharedInstance] decryptedDataForKey:kLXHKeychainStoreRootSeed error:nil];
        NSString *receivingAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        NSString *changeAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentChangeAddressIndex];
        NSString *netType = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreBitcoinNetType];
        if (rootSeed && receivingAddressIndex && changeAddressIndex && netType) {
            _mainAccount = [[LXHAccount alloc] initWithRootSeed:rootSeed
                                              currentReceivingAddressIndex:receivingAddressIndex.integerValue
                                                 currentChangeAddressIndex:changeAddressIndex.integerValue
                                                        currentNetworkType:netType.integerValue];
        }
    }
    return _mainAccount;
}

+ (BOOL)saveCurrentAddressIndexes {
    NSString *currentReceivingAddressIndex = @([self mainAccount].receiving.currentAddressIndex).description;
    NSString *currentChangeAddressIndex = @([self mainAccount].change.currentAddressIndex).description;
    BOOL saveResult = [[LXHKeychainStore sharedInstance].store setString:currentReceivingAddressIndex forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:currentChangeAddressIndex forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    return saveResult;
}


+ (BOOL)generateNewWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                           netType:(LXHBitcoinNetworkType)netType{
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed];
    BOOL saveResult = [self encryptAndSetMnemonicCodeWords:mnemonicCodeWords];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:rootSeed forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"0" forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(netType).stringValue forKey:kLXHKeychainStoreBitcoinNetType];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"1" forKey:kLXHKeychainStoreWalletDataGenerated];
    if (!saveResult) {
        [self clearAccount];
    }
    return saveResult;
}

+ (void)restoreExistWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                mnemonicPassphrase:(nullable NSString *)mnemonicPassphrase
                                           netType:(LXHBitcoinNetworkType)netType
                                      successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                      failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed].copy;
    LXHAccount *account = [[LXHAccount alloc] initWithRootSeed:rootSeed currentNetworkType:netType];
    LXHAccountAddressSearcher *searcher = [[LXHAccountAddressSearcher alloc] initWithAccount:account];
    [searcher searchWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *currentUnusedReceivingAddressIndex = resultDic[@"currentUnusedReceivingAddressIndex"];
        NSNumber *currentUnusedChangeAddressIndex = resultDic[@"currentUnusedChangeAddressIndex"];
        
        BOOL saveResult = [self encryptAndSetMnemonicCodeWords:mnemonicCodeWords];
        saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:rootSeed forKey:kLXHKeychainStoreRootSeed];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:currentUnusedReceivingAddressIndex.stringValue forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:currentUnusedChangeAddressIndex.stringValue forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(netType).stringValue forKey:kLXHKeychainStoreBitcoinNetType];
        saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"1" forKey:kLXHKeychainStoreWalletDataGenerated];
        
        if (!saveResult) {
            [self clearAccount];
            failureBlock(nil);
        } else {
            //充分利用已经请求到的数据，不用重新请求交易数据
            NSArray *allTransactions = resultDic[@"allTransactions"];
            [[LXHTransactionDataManager sharedInstance] setTransactionList:allTransactions];
            successBlock(resultDic);//has @"allTransactions":allTransaction
        }
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(nil);
    }];
}

+ (BOOL)clearAccount {
    [self sharedInstance].mainAccount = nil;
    BOOL saveResult = [self encryptAndSetMnemonicCodeWords:nil];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreBitcoinNetType];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreWalletDataGenerated];
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

+ (BOOL)encryptAndSetMnemonicCodeWords:(NSArray *)mnemonicCodeWords {
    return [[LXHKeychainStore sharedInstance] encryptAndSetString:[mnemonicCodeWords componentsJoinedByString:@" "]  forKey:kLXHKeychainStoreMnemonicCodeWords];
}

+ (NSArray *)mnemonicCodeWordsWithErrorPointer:(NSError **)error {
    NSString *string = [[LXHKeychainStore sharedInstance] decryptedStringForKey:kLXHKeychainStoreMnemonicCodeWords error:error];
    if (string)
        return [string componentsSeparatedByString:@" "];
    else 
        return nil;
}

+ (BOOL)walletDataGenerated {
    return [[[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreWalletDataGenerated] isEqualToString:@"1"];
}

@end
