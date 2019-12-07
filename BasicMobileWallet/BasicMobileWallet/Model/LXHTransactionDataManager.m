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

@interface LXHTransactionDataManager ()
@property (nonatomic) NSDictionary *transactionData;
@end

@implementation LXHTransactionDataManager

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
    self.transactionData = nil;
}

- (NSDictionary *)transactionData {
    if (!_transactionData) {
        _transactionData = [self transactionDataFromCacheFile];
    }
    return _transactionData;
}

- (NSArray *)transactionList {
    return self.transactionData[@"transactions"];
}

- (NSDate *)dataUpdatedTime {
    return self.transactionData[@"date"];
}

- (void)setTransactionList:(NSArray *)transactionList {
    if (!transactionList || transactionList.count == 0)
        return;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"date"] = [NSDate date];
    dic[@"transactions"] = transactionList;
    _transactionData = dic;
    [self saveTransactionListToCacheFileWithDic:dic];
    
}

- (NSDictionary *)transactionDataFromCacheFile {
    NSData *encryptedData = [NSData dataWithContentsOfFile:LXHTransactionDataManagerCacheFilePath];
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withSettings:kRNCryptorAES256Settings password:aesPassword error:nil];
    NSDictionary *ret = nil;
    if (decryptedData) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    return ret;
}

- (void)saveTransactionListToCacheFileWithDic:(NSDictionary *)dic {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:nil];
    if (encryptedData)
        [encryptedData writeToFile:LXHTransactionDataManagerCacheFilePath atomically:YES];
}

- (void)requestDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                       failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *addresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
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

+ (void)pushTransactionsWithHex:(NSString *)hex
                              successBlock:(void (^)(NSDictionary *resultDic))successBlock
                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [LXHTransactionDataManager webApiWithType:LXHWallet.mainAccount.currentNetworkType];
    [webApi pushTransactionWithHex:hex successBlock:successBlock failureBlock:failureBlock];
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
            return [input.address.base58String isEqualToString:address];
        }] || [transaction.outputs bk_any:^BOOL(LXHTransactionOutput *output) {
            return [output.address.base58String isEqualToString:address];
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
        [utxos addObjectsFromArray:[transaction myUtxos]];
        return utxos;
    }];
}

- (NSDecimalNumber *)balance {
    NSArray *utxos = [self utxosOfAllTransactions];
    return [LXHTransactionOutput valueSumOfOutputs:utxos];
}

@end

