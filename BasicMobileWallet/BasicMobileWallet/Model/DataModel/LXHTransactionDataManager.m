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

#define LXHTransactionDataManagerCacheFilePath [NSString stringWithFormat:@"%@/%@",  LXHCacheFileDir, cacheFileName]//todo 交易数据不应该保存到缓存目录下

@interface LXHTransactionDataManager ()
@property (nonatomic) NSDictionary *transactionData;
@end

@implementation LXHTransactionDataManager

+ (instancetype)sharedInstance {
    static LXHTransactionDataManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
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
//    NSLog(@"[self transactionList].count %ld", [[self transactionList] count]);
//    NSLog(@"transactionList.count %ld", [transactionList count]);
//    if ([[self transactionList] isEqualToArray:transactionList])
//        return;
    NSArray *sortedArray = [transactionList sortedArrayUsingComparator:^NSComparisonResult(LXHTransaction * _Nonnull obj1, LXHTransaction * _Nonnull obj2) {
        return [@(obj2.firstSeen.longLongValue) compare:@(obj1.firstSeen.longLongValue)];
    }];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"date"] = [NSDate date];
    dic[@"transactions"] = sortedArray;
    _transactionData = dic;
    [self saveTransactionListToCacheFile];
}

+ (void)addTransaction:(LXHTransaction *)transaction toArray:(NSMutableArray *)array {
    if (!transaction)
        return;
    NSArray *txids = [array bk_map:^id(LXHTransaction *obj) {
        return obj.txid;
    }];
    if ([txids containsObject:transaction.txid])
        return;
    else {
        [array addObject:transaction];
    }
}

+ (void)updateOldTransactionToNewTransaction:(LXHTransaction *)newTransaction inArray:(NSMutableArray *)array {
    LXHTransaction *oldTransaction = [array bk_match:^BOOL(LXHTransaction *transaction) {
        return [transaction.txid isEqualToString:newTransaction.txid];
    }];
    if (oldTransaction) {
        [array removeObject:oldTransaction];
        [array addObject:newTransaction];
    }
}

- (NSMutableSet *)allBase58Addresses {
    NSMutableSet *ret = [NSMutableSet set];
    for (LXHTransaction *transaction in [self transactionList]) {
        for (LXHTransactionOutput *output in transaction.outputs) {
            if (output.address.base58String)
                [ret addObject:output.address.base58String];
        }
        for (LXHTransactionInput *input in transaction.inputs) {
            if (input.address.base58String)
                [ret addObject:input.address.base58String];
        }
    }
    return ret;
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

- (void)saveTransactionListToCacheFile {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_transactionData];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:nil];
    if (encryptedData)
        [encryptedData writeToFile:LXHTransactionDataManagerCacheFilePath atomically:YES];
}

//从全部交易列表里过滤出 输入地址或输出地址为address的交易
- (NSArray *)transactionListByAddress:(NSString *)address {
    return [self.transactionList bk_select:^BOOL(LXHTransaction *transaction) {
        BOOL inputContainsAddress = [transaction.inputs bk_any:^BOOL(LXHTransactionInput *input) {
            return [input.address.base58String isEqualToString:address];
        }];
        BOOL outputContainsAddress =[transaction.outputs bk_any:^BOOL(LXHTransactionOutput *output) {
            return [output.address.base58String isEqualToString:address];
        }];
        return inputContainsAddress || outputContainsAddress;
    }];
}

- (LXHTransaction *)transactionByTxid:(NSString *)txid {
    return [self.transactionList bk_match:^BOOL(LXHTransaction *transaction) {
        return [transaction.txid isEqualToString:txid];
    }];
}

- (NSMutableArray<LXHTransactionOutput *> *)utxosOfAllTransactions {
    NSMutableArray *utxos = [NSMutableArray array];
    [self.transactionList enumerateObjectsUsingBlock:^(LXHTransaction *transaction, NSUInteger idx, BOOL * _Nonnull stop) {
        [utxos addObjectsFromArray:[transaction myUtxos]];
    }];
    return utxos;
}

- (NSDecimalNumber *)balance {
    NSArray *utxos = [self utxosOfAllTransactions];
    return [LXHTransactionOutput valueSumOfOutputs:utxos];
}

@end

