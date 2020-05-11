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
#define kLXHKeychainStoreExtendedPublicKey @"ExtendedPublicKey" //AES encrypt
#define kLXHKeychainStoreWalletDataGenerated @"kLXHKeychainStoreWalletDataGenerated"
#define MainAccountIndex 0

@interface LXHWallet ()
@property (nonatomic) LXHAccount *mainAccount;
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
                                                                   accountIndex:MainAccountIndex
                                                   currentReceivingAddressIndex:receivingAddressIndex.integerValue
                                                      currentChangeAddressIndex:changeAddressIndex.integerValue];
        }
    }
    return _mainAccount;
}

+ (BOOL)generateWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                           netType:(LXHBitcoinNetworkType)netType {
    if (!mnemonicCodeWords || (netType == LXHBitcoinNetworkTypeUndefined))
        return YES;
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
    if (!account) {
        failureBlock(nil);
        return;
    }
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
        failureBlock(resultDic);
    }];
}

+ (BOOL)saveAccountDataWithAccountBase58ExtendedPublicKey:(NSString *)extendedPublicKey
                             currentReceivingAddressIndex:(NSInteger)currentReceivingAddressIndex
                                currentChangeAddressIndex:(NSInteger)currentChangeAddressIndex {
    
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetString:extendedPublicKey forKey:kLXHKeychainStoreExtendedPublicKey];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(currentReceivingAddressIndex).stringValue forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:@(currentChangeAddressIndex).stringValue forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    return saveResult;
}

+ (void)searchAndUpdateCurrentAddressIndexWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    LXHAccount *account = [LXHWallet mainAccount];
    LXHAccountAddressSearcher *searcher = [[LXHAccountAddressSearcher alloc] initWithAccount:account];
    [searcher searchWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
        uint32_t currentUnusedReceivingAddressIndex = [resultDic[@"currentUnusedReceivingAddressIndex"] unsignedIntValue];
        uint32_t currentUnusedChangeAddressIndex = [resultDic[@"currentUnusedChangeAddressIndex"] unsignedIntValue];
        
        BOOL indexNeedBeUpdated =
        (currentUnusedReceivingAddressIndex > account.receiving.currentAddressIndex) ||
        (currentUnusedChangeAddressIndex > account.change.currentAddressIndex);
        NSMutableDictionary *resultDicCopy = [resultDic mutableCopy];
        if (indexNeedBeUpdated) {
            [account.receiving setCurrentAddressIndex:currentUnusedReceivingAddressIndex];
            [account.change setCurrentAddressIndex:currentUnusedChangeAddressIndex];
            resultDicCopy[@"indexUpdated"] = @(YES);
        } else {
            resultDicCopy[@"indexUpdated"] = @(NO);
        }
        //充分利用已经请求到的数据，不用重新请求交易数据
        NSArray *allTransactions = resultDicCopy[@"allTransactions"];
        [[LXHTransactionDataManager sharedInstance] setTransactionList:allTransactions];
        successBlock(resultDicCopy);//has @"allTransactions":allTransaction
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

+ (BOOL)isCurrentMnemonicCodeWords:(NSArray *)mnemonicCodeWords
             andMnemonicPassphrase:(nullable NSString *)mnemonicPassphrase {
    
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:mnemonicCodeWords password:mnemonicPassphrase wordListType:BTCMnemonicWordListTypeEnglish];
    if ([self isFullFunctional]) {
        NSData *seedToCompare = [mnemonic seed].copy;
        return [LXHKeychainStore.sharedInstance data:seedToCompare isEqualToEncryptedDataForKey:kLXHKeychainStoreRootSeed];
    } else if ([self isWatchOnly]) {
        BTCKeychain *masterKeychain = [mnemonic.keychain copy];
        LXHBitcoinNetworkType netType = [self currentNetworkType];
        if (netType == LXHBitcoinNetworkTypeUndefined)
            return NO;
        BTCKeychain *firstAccountKeychain = [self firstAccountKeychainWithMasterKeychain:masterKeychain netType:netType];
        return [LXHKeychainStore.sharedInstance string:firstAccountKeychain.extendedPublicKey isEqualToEncryptedStringForKey:kLXHKeychainStoreExtendedPublicKey];
    } else { //不应该发生这种情况
        return NO;
    }
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
    
    LXHAccount *account = [[LXHAccount alloc] initWithAccountExtendedPublicKey:firstAccountKeychain.extendedPublicKey accountIndex:MainAccountIndex currentReceivingAddressIndex:0 currentChangeAddressIndex:0];
    
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
        failureBlock(resultDic);
    }];
}

+ (BOOL)clearAccount {
    [[self sharedInstance].mainAccount clearSavedPublicKeys];
    [self sharedInstance].mainAccount = nil;
    BOOL saveResult = [self encryptAndSetMnemonicCodeWords:nil];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreRootSeed];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreExtendedPublicKey];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentReceivingAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreCurrentChangeAddressIndex];
    saveResult = saveResult && [[LXHKeychainStore sharedInstance].store setString:nil forKey:kLXHKeychainStoreWalletDataGenerated];
    return saveResult;
}

+ (LXHBitcoinNetworkType)currentNetworkType {
    //get netType from extendedPublicKey
    NSString *extendedPublicKey = [[LXHKeychainStore sharedInstance] decryptedStringForKey:kLXHKeychainStoreExtendedPublicKey error:nil];
    if (!extendedPublicKey)
        return LXHBitcoinNetworkTypeUndefined;
    
    BTCNetwork *network = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey].network;
    LXHBitcoinNetworkType netType = network.isMainnet ? LXHBitcoinNetworkTypeMainnet : LXHBitcoinNetworkTypeTestnet;
    return netType;
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

+ (BOOL)isValid {
    return [self walletDataGenerated] && ([self isWatchOnly] || [self isFullFunctional]);
}


+ (NSData *)signatureWithNetType:(LXHBitcoinNetworkType)netType path:(NSString *)path hash:(NSData *)hash  {
    BTCNetwork *network;
    if (netType == LXHBitcoinNetworkTypeMainnet) {
        network = [BTCNetwork mainnet];
    } else {
        network = [BTCNetwork testnet];
    }
    
    NSData *rootSeed = [LXHKeychainStore.sharedInstance decryptedDataForKey:kLXHKeychainStoreRootSeed error:nil];
    if (rootSeed) {
        BTCKeychain *masterKeychain = [[BTCKeychain alloc] initWithSeed:rootSeed];
        masterKeychain.network = network;
        BTCKeychain *keychain = [masterKeychain derivedKeychainWithPath:path];
        keychain.network = network;
        return [keychain.key signatureForHash:hash hashType:BTCSignatureHashTypeAll];
    } else {
        return nil;
    }
}

+ (BOOL)isWatchOnly {
    return [LXHKeychainStore.sharedInstance.store contains:kLXHKeychainStoreExtendedPublicKey] && ![LXHKeychainStore.sharedInstance.store contains:kLXHKeychainStoreRootSeed];
}

+ (BOOL)isFullFunctional {
    return [LXHKeychainStore.sharedInstance.store contains:kLXHKeychainStoreRootSeed];
}

+ (BOOL)hasPIN {
    return ([[LXHKeychainStore sharedInstance].store contains:kLXHKeychainStorePIN]);
}

+ (void)clearPIN {
    [[LXHKeychainStore sharedInstance].store setData:nil forKey:kLXHKeychainStorePIN];
}
@end

