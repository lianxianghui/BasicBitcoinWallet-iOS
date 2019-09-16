//
//  TransactionDataManager.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionDataManager.h"
#import "LXHGlobalHeader.h"

#import <RNCryptor/RNCryptor.h>
#import <RNCryptor/RNDecryptor.h>
#import <RNCryptor/RNEncryptor.h>

#import "LXHNetworkRequest.h"
#import "LXHWallet.h"

static NSString *const cacheFileName = @"LXHTransactionDataManagerCacheFile.aes";
static NSString *const aesPassword = LXHAESPassword;

#define LXHTransactionDataManagerCacheFilePath [NSString stringWithFormat:@"%@/%@",  LXCacheFileDir, cacheFileName]

@implementation LXHTransactionDataManager
@synthesize transactionList = _transactionList;

+ (instancetype)sharedInstance {
    static LXHTransactionDataManager *instance = nil;
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
        instance = [[LXHTransactionDataManager alloc] init];
    });
    return instance;
}

- (NSArray *)transactionList {
    if (!_transactionList) {
        _transactionList = [self transactionListFromCacheFile];
    }
    return _transactionList;
}

- (void)setTransactionList:(NSArray *)transactionList {
    if (!transactionList)
        return;
    [self saveTransactionListToCacheFileWithArray:transactionList];
    _transactionList = transactionList;
}

- (NSArray *)transactionListFromCacheFile {
    NSData *encryptedData = [NSData dataWithContentsOfFile:LXHTransactionDataManagerCacheFilePath];
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withSettings:kRNCryptorAES256Settings password:aesPassword error:nil];
    NSArray *ret = nil;
    if (decryptedData)
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    return ret;
}

- (void)saveTransactionListToCacheFileWithArray:(NSArray *)array {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:nil];
    if (encryptedData)
        [encryptedData writeToFile:LXHTransactionDataManagerCacheFilePath atomically:YES];
}


- (void)requestDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                       failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *addresses = [[LXHWallet mainAccount] usedAddresses];
    [LXHTransactionDataManager requestTransactionsWithAddresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        NSArray *transactions = resultDic[@"items"];
        [self setTransactionList:transactions];
        successBlock(resultDic);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

+ (void)requestTransactionsWithAddresses:(NSArray *)addresses
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *baseUrl;
    if ([[LXHWallet mainAccount] currentNetworkType] == LXHBitcoinNetworkTypeMainnet)
        baseUrl = @"https://insight.bitpay.com/";
    else
        baseUrl = @"https://test-insight.bitpay.com/";
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"api/addrs/txs"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"addrs"] = [addresses componentsJoinedByString:@","];
    [LXHNetworkRequest postWithUrlString:url parameters:parameters
                      successCallback:^(NSDictionary * _Nonnull resultDic) {
                          successBlock(resultDic);
                      } failureCallback:^(NSDictionary * _Nonnull resultDic) {
                          NSError *error = resultDic[@"error"];
                          failureBlock(@{@"error":error.localizedDescription});
                      }];
}

@end

