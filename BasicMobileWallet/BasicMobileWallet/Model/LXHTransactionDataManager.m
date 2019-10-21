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
#import "LXHBitcoinWebApiSmartbit.h"
#import "BlocksKit.h"

static NSString *const cacheFileName = @"LXHTransactionDataManagerCacheFile.aes";
static NSString *const aesPassword = LXHAESPassword;

#define LXHTransactionDataManagerCacheFilePath [NSString stringWithFormat:@"%@/%@",  LXHCacheFileDir, cacheFileName]

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

- (void)clearCachedData {
    [[NSFileManager defaultManager] removeItemAtPath:LXHTransactionDataManagerCacheFilePath error:nil];
    _transactionList = nil;
}

- (NSArray *)transactionList {
    if (!_transactionList) {
        _transactionList = [self transactionListFromCacheFile];
    }
    return _transactionList;
}

- (void)setTransactionList:(NSArray *)transactionList {
    if (!transactionList || transactionList.count == 0)
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
    [LXHTransactionDataManager requestTransactionsWithNetworkType:LXHWallet.mainAccount.currentNetworkType addresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        NSArray *transactions = resultDic[@"transactions"];
        [self setTransactionList:transactions];
        successBlock(resultDic);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

+ (void)requestTransactionsWithNetworkType:(LXHBitcoinNetworkType)type
                            addresses:(NSArray *)addresses
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:type];
    [webApi requestAllTransactionsWithAddresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        successBlock(resultDic);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

//bitpay insight code
//+ (void)requestTransactionsWithNetworkType:(LXHBitcoinNetworkType)type
//                                 addresses:(NSArray *)addresses
//                              successBlock:(void (^)(NSDictionary *resultDic))successBlock
//                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
//    NSString *baseUrl;
//    if (type == LXHBitcoinNetworkTypeMainnet)
//        baseUrl = @"https://insight.bitpay.com/";
//    else
//        baseUrl = @"https://test-insight.bitpay.com/";
//    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"api/addrs/txs"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"addrs"] = [addresses componentsJoinedByString:@","];
//    [LXHNetworkRequest POSTWithUrlString:url parameters:parameters
//                         successCallback:^(NSDictionary * _Nonnull resultDic) {
//                             successBlock(resultDic);
//                         } failureCallback:^(NSDictionary * _Nonnull resultDic) {
//                             NSError *error = resultDic[@"error"];
//                             failureBlock(@{@"error":error.localizedDescription});
//                         }];
//
//}

+ (id<LXHBitcoinWebApi>)webApiWithType:(LXHBitcoinNetworkType)type {
    id<LXHBitcoinWebApi> ret = [[LXHBitcoinWebApiSmartbit alloc] initWithType:type];
    return ret;
}

//从全部交易列表里过滤出 输入地址或输出地址为address的交易
- (NSArray *)transactionListByAddress:(NSString *)address {
    return [self.transactionList bk_select:^BOOL(LXHTransaction *transaction) {
        return [transaction.inputs bk_any:^BOOL(LXHTransactionInput *input) {
            return [input.address isEqualToString:address];
        }] || [transaction.outputs bk_any:^BOOL(LXHTransactionOutput *output) {
            return [output.address isEqualToString:address];
        }];
    }];
}

- (LXHTransaction *)transactionByTxid:(NSString *)txid {
    return [self.transactionList bk_match:^BOOL(LXHTransaction *transaction) {
        return [transaction.txid isEqualToString:txid];
    }];
}

- (NSMutableArray<LXHTransactionOutput *> *)utxosOfAllTransactions {
    return [self.transactionList bk_reduce:[NSMutableArray array] withBlock:^id(NSMutableArray *utxos, LXHTransaction *transaction) {
        [utxos addObjectsFromArray:[transaction utxos]];
        return utxos;
    }];
}

- (NSDecimalNumber *)balance {
    NSArray *utxos = [self utxosOfAllTransactions];
    return [utxos bk_reduce:[NSDecimalNumber zero] withBlock:^id(NSDecimalNumber *sum, LXHTransactionOutput *utxo) {
        return [sum decimalNumberByAdding:utxo.value];
    }];
    return [LXHTransactionOutput valueSumOfOutputs:utxos];
}

@end

