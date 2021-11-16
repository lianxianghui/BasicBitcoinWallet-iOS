//
//  LXHWallet.m
//  BasicBitcoinWallet
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
#define kLXHKeychainStorePIN @"PIN" //Using AES encrypt
#define kLXHKeychainStorePINSalt @"PINSalt" //Using AES encrypt
#define kLXHKeychainStoreMnemonicCodeWords @"MnemonicCodeWords" //AES encrypt
#define kLXHKeychainStoreRootSeed @"RootSeed" //AES encrypt
#define kLXHKeychainStoreExtendedPublicKey @"ExtendedPublicKey" //AES encrypt
#define kLXHKeychainStoreWalletDataGenerated @"kLXHKeychainStoreWalletDataGenerated"
#define MainAccountIndex 0

//Server Setting
#define kLXHKeychainStoreServerSettingData @"kLXHKeychainStoreServerSettingData"

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
            if ([[LXHTransactionDataManager sharedInstance] setAndSaveTransactionList:allTransactions])
                successBlock(resultDic);//has @"allTransactions":allTransaction
            else {
                [self clearAccount];
                failureBlock(nil);
            }
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
            //二者有一个被更新了就算有更新
            BOOL updated = [account.receiving setCurrentAddressIndex:currentUnusedReceivingAddressIndex error:nil];
            updated = updated || [account.change setCurrentAddressIndex:currentUnusedChangeAddressIndex error:nil];
            if (updated)
                resultDicCopy[@"indexUpdated"] = @(YES);
            else
                resultDicCopy[@"indexUpdated"] = @(NO);
        } else {
            resultDicCopy[@"indexUpdated"] = @(NO);
        }
        //充分利用已经请求到的数据，不用重新请求交易数据
        NSArray *allTransactions = resultDicCopy[@"allTransactions"];
        [[LXHTransactionDataManager sharedInstance] setAndSaveTransactionList:allTransactions];
        successBlock(resultDicCopy);
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
            if ([[LXHTransactionDataManager sharedInstance] setAndSaveTransactionList:allTransactions])
                successBlock(resultDic);//has @"allTransactions":allTransaction
            else {
                [self clearAccount];
                failureBlock(nil);
            }
        }
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

+ (BOOL)clearAccount {
    [[self sharedInstance].mainAccount clearSavedPublicKeys];//clear generated public keys
    [self sharedInstance].mainAccount = nil;
    BOOL saveResult = [self encryptAndSetMnemonicCodeWords:nil];//clear kLXHKeychainStoreMnemonicCodeWords
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
    return ([[LXHKeychainStore sharedInstance].store contains:kLXHKeychainStorePIN] && [[LXHKeychainStore sharedInstance].store contains:kLXHKeychainStorePINSalt]);
}

+ (void)clearPIN {
    [[LXHKeychainStore sharedInstance].store setData:nil forKey:kLXHKeychainStorePIN];
    [[LXHKeychainStore sharedInstance].store setData:nil forKey:kLXHKeychainStorePINSalt];
}

//把哈希过的PIN和生成的随机盐加密后保存到keychain里
+ (BOOL)savePIN:(nonnull NSString *)pin {
    NSDictionary *hashedPINAndSalt = [self hashedPINAndSaltWithPIN:pin];
    if (!hashedPINAndSalt)
        return NO;
    NSData *hashedPIN = hashedPINAndSalt[@"hashedPIN"];
    NSData *salt = hashedPINAndSalt[@"salt"];
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetData:salt forKey:kLXHKeychainStorePINSalt];
    saveResult = saveResult && [LXHKeychainStore.sharedInstance encryptAndSetData:hashedPIN forKey:kLXHKeychainStorePIN];
    if (!saveResult) {
        [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStorePINSalt];
        [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStorePIN];
        return NO;
    }
    return YES;
}

+ (BOOL)verifyPIN:(nonnull NSString *)pin {
    NSData *savedSalt = [LXHKeychainStore.sharedInstance decryptedDataForKey:kLXHKeychainStorePINSalt error:nil];
    if (!savedSalt)
        return NO;
    NSData* pinData = [pin dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hashedPIN = [self hashedPINWithPINData:pinData saltData:savedSalt];
    return [LXHKeychainStore.sharedInstance data:hashedPIN isEqualToEncryptedDataForKey:kLXHKeychainStorePIN];
}

+ (NSDictionary *)hashedPINAndSaltWithPIN:(NSString *)pin {
    NSData* pinData = [pin dataUsingEncoding:NSUTF8StringEncoding];
    NSData *saltData = BTCRandomDataWithLength(64);
    NSData *hashedPIN = [self hashedPINWithPINData:pinData saltData:saltData];
    if (saltData && hashedPIN)
        return @{@"hashedPIN":hashedPIN, @"salt":saltData};
    else
        return nil;
}

+ (NSData*)hashedPINWithPINData:(NSData *)pinData saltData:(NSData *)saltData {
    const NSUInteger resultLength = 64;
    NSMutableData* result = [NSMutableData dataWithLength:resultLength];
    CCKeyDerivationPBKDF(kCCPBKDF2,
                         pinData.bytes,
                         pinData.length,
                         saltData.bytes,
                         saltData.length,
                         kCCPRFHmacAlgSHA512,
                         2048,
                         result.mutableBytes,
                         resultLength);
    
    return result;
}

+ (NSDictionary *)selectedServerInfoWithNetworkType:(LXHBitcoinNetworkType)networkType {
    NSDictionary *ret = nil;
    NSData *decryptedData = [LXHKeychainStore.sharedInstance decryptedDataForKey:kLXHKeychainStoreServerSettingData error:nil];
    if (decryptedData)
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    NSString *currentNetworkString = [LXHBitcoinNetwork networkStringWithType:networkType];
    NSArray *currentNetworkItems = [self serverDataDic][currentNetworkString];
    if (ret) {
        if (![currentNetworkItems containsObject:ret]) //如果之前选的与目前的所有选项都不符，选第一个为默认的
            ret = currentNetworkItems[0];
        return ret;
    } else {
        ret = currentNetworkItems[0];//没有设置过，选第一个为默认的
    }
    return ret;
}
	
+ (BOOL)saveSelectedServerInfo:(nonnull NSDictionary *)selectedServerInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:selectedServerInfo];
    BOOL saveResult = [LXHKeychainStore.sharedInstance encryptAndSetData:data forKey:kLXHKeychainStoreServerSettingData];
    return saveResult;
}

+ (void)clearSelectedServerInfo {
    [LXHKeychainStore.sharedInstance encryptAndSetData:nil forKey:kLXHKeychainStoreServerSettingData];
}

+ (NSMutableDictionary *)serverDataDic {
    static NSMutableDictionary *serverDataDic = nil;
    if (!serverDataDic) {
        serverDataDic = [NSMutableDictionary dictionary];
        //testnet
        NSDictionary *testnetMyElectrsItem = @{@"apiName":@"myElectrs", @"endPoint":@"123.57.225.73", @"title":@"123.57.225.73",};
//        NSDictionary *testnetSmartbitItem = @{@"apiName":@"smartBit", @"endPoint":@"testnet-api.smartbit.com.au", @"title":@"testnet-api.smartbit.com.au",};
        serverDataDic[@"testnet"] = @[testnetMyElectrsItem];
        //mainnet
//        NSDictionary *mainnetSmartbitItem = @{@"apiName":@"smartBit", @"endPoint":@"api.smartbit.com.au", @"title":@"api.smartbit.com.au",};
//        serverDataDic[@"mainnet"] = @[mainnetSmartbitItem];
    }
    return serverDataDic;
}
@end

