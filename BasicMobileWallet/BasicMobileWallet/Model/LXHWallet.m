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
#define kLXHKeychainStoreExtendedPublicKey @"ExtendedPublicKey"
#define kLXHKeychainStoreBitcoinNetType @"kLXHKeychainStoreBitcoinNetType"
#define kLXHKeychainStoreWalletDataGenerated @"kLXHKeychainStoreWalletDataGenerated"

//for first Account
#define kLXHKeychainStoreCurrentChangeAddressIndex @"CurrentChangeAddressIndex" 
#define kLXHKeychainStoreCurrentReceivingAddressIndex @"CurrentReceivingAddressIndex"

#define MainAccountIndex 0

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
        NSString *extendedPublicKey = [[LXHKeychainStore sharedInstance] decryptedStringForKey:kLXHKeychainStoreExtendedPublicKey error:nil];
        NSString *receivingAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
        NSString *changeAddressIndex = [[LXHKeychainStore sharedInstance].store stringForKey:kLXHKeychainStoreCurrentChangeAddressIndex];
        if (extendedPublicKey && receivingAddressIndex && changeAddressIndex) {
            _mainAccount = [[LXHAccount alloc] initWithAccountExtendedPublicKey:extendedPublicKey
                                                                   accountIndex:0 //first account
                                              currentReceivingAddressIndex:receivingAddressIndex.integerValue
                                                 currentChangeAddressIndex:changeAddressIndex.integerValue];
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
                                           netType:(LXHBitcoinNetworkType)netType {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKeychain = [mnemonic.keychain copy];
    BTCKeychain *firstAccountKeychain = [self firstAccountKeychainWithMasterKeychain:masterKeychain netType:netType];
    
    BOOL saveResult = [self encryptAndSetMnemonicCodeWords:mnemonicCodeWords];//mnemonic words
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:[[mnemonic seed] copy] forKey:kLXHKeychainStoreRootSeed];//root seed
    saveResult = saveResult && [self saveAccountDataWithAccountBase58ExtendedPublicKey:firstAccountKeychain.extendedPublicKey currentReceivingAddressIndex:0 currentChangeAddressIndex:0];//account info
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@"1" forKey:kLXHKeychainStoreWalletDataGenerated];//generated flag
    if (!saveResult) {
        [self clearAccount];
    }
    return saveResult;
}

+ (BTCKeychain *)firstAccountKeychainWithMasterKeychain:(BTCKeychain *)masterKeychain
                                netType:(LXHBitcoinNetworkType)netType {
    BTCNetwork *network;
    NSString *path;
    if (netType == LXHBitcoinNetworkTypeMainnet) {
        network = [BTCNetwork mainnet];
        path = @"m/44'/0'/0'";
    } else {
        network = [BTCNetwork testnet];
        path = @"m/44'/1'/0'";
    }
    
    masterKeychain.network = network;
    BTCKeychain *accountKeychain = [masterKeychain derivedKeychainWithPath:path];
    accountKeychain.network = network;
    return accountKeychain;
}

+ (void)importReadOnlyWalletWithAccountExtendedPublicKey:(NSString *)extendedPublicKey
                                            successBlock:(void (^)(NSDictionary *resultDic))successBlock
                                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    LXHAccount *account = [[LXHAccount alloc] initWithAccountExtendedPublicKey:extendedPublicKey accountIndex:MainAccountIndex currentReceivingAddressIndex:0 currentChangeAddressIndex:0];
    LXHAccountAddressSearcher *searcher = [[LXHAccountAddressSearcher alloc] initWithAccount:account];
    [searcher searchWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *currentUnusedReceivingAddressIndex = resultDic[@"currentUnusedReceivingAddressIndex"];
        NSNumber *currentUnusedChangeAddressIndex = resultDic[@"currentUnusedChangeAddressIndex"];
        
        BOOL saveResult = [self saveAccountDataWithAccountBase58ExtendedPublicKey:extendedPublicKey currentReceivingAddressIndex:currentUnusedReceivingAddressIndex.integerValue currentChangeAddressIndex:currentUnusedChangeAddressIndex.integerValue];
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

+ (BOOL)saveAccountDataWithAccountBase58ExtendedPublicKey:(NSString *)extendedPublicKey
                             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
                                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex {
    
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetString:extendedPublicKey forKey:kLXHKeychainStoreExtendedPublicKey];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(currentReceivingAddressIndex).stringValue forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(currentChangeAddressIndex).stringValue forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    
    //get netType from extendedPublicKey
    BTCNetwork *network = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey].network;
    LXHBitcoinNetworkType netType = network.isMainnet ? LXHBitcoinNetworkTypeMainnet : LXHBitcoinNetworkTypeTestnet;
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(netType).stringValue forKey:kLXHKeychainStoreBitcoinNetType];
    return saveResult;
}

+ (void)restoreExistWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                mnemonicPassphrase:(nullable NSString *)mnemonicPassphrase
                                           netType:(LXHBitcoinNetworkType)netType
                                      successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                      failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    NSData *rootSeed = [mnemonic seed].copy;
    
    BTCKeychain *masterKeychain = [mnemonic.keychain copy];
    BTCKeychain *firstAccountKeychain = [self firstAccountKeychainWithMasterKeychain:masterKeychain netType:netType];
    
    LXHAccount *account = [[LXHAccount alloc] initWithAccountExtendedPublicKey:firstAccountKeychain.extendedPublicKey accountIndex:0 currentReceivingAddressIndex:0 currentChangeAddressIndex:0];
    
    LXHAccountAddressSearcher *searcher = [[LXHAccountAddressSearcher alloc] initWithAccount:account];
    [searcher searchWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *currentUnusedReceivingAddressIndex = resultDic[@"currentUnusedReceivingAddressIndex"];
        NSNumber *currentUnusedChangeAddressIndex = resultDic[@"currentUnusedChangeAddressIndex"];
        
        BOOL saveResult = [self encryptAndSetMnemonicCodeWords:mnemonicCodeWords];
        saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:rootSeed forKey:kLXHKeychainStoreRootSeed];
        saveResult = saveResult && [self saveAccountDataWithAccountBase58ExtendedPublicKey:firstAccountKeychain.extendedPublicKey currentReceivingAddressIndex:currentUnusedReceivingAddressIndex.integerValue currentChangeAddressIndex:currentUnusedChangeAddressIndex.integerValue];
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
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreExtendedPublicKey];
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
