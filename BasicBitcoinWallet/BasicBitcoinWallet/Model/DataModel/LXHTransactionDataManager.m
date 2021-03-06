//
//  TransactionDataManager.m
//  BasicBitcoinWallet
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
//注：如果有人通过某种方式获得了被加密的数据文件，这种加密可以起到一定的保护作用。但如果同时也获得了app的二进制文件，是可以通过静态分析查看到这个密码的，就无法保护数据文件了。
static NSString *const aesPassword = LXHAESPassword;

#define LXHTransactionDataManagerCacheFilePath [NSString stringWithFormat:@"%@/%@",  LXHDocumentDir, cacheFileName]//由于交易数据涉及隐私，所以加密后存到Document目录下

@interface LXHTransactionDataManager ()
@property (nonatomic, readwrite) NSDictionary *transactionData;
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

- (BOOL)setAndSaveTransactionList:(NSArray *)transactionList {
    if (!transactionList)
        transactionList = @[];
    NSArray *sortedArray = [transactionList sortedArrayUsingComparator:^NSComparisonResult(LXHTransaction * _Nonnull obj1, LXHTransaction * _Nonnull obj2) {
        NSInteger obj1BlockTime = obj1.firstSeen ? obj1.firstSeen.integerValue : NSIntegerMax;
        NSInteger obj2BlockTime = obj2.firstSeen ? obj2.firstSeen.integerValue : NSIntegerMax;
        return [@(obj2BlockTime) compare:@(obj1BlockTime)];
    }];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"date"] = [NSDate date];
    dic[@"transactions"] = sortedArray;
    if ([self saveTransactionDataToCacheFile:dic]) {
        self.transactionData = dic;
        return YES;
    } else {
        return NO;
    }
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

- (BOOL)saveTransactionDataToCacheFile:(NSDictionary *)transactionData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:transactionData];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aesPassword
                                               error:nil];

    NSString *filePath = LXHTransactionDataManagerCacheFilePath;
    //for privacy, using FileProtectionComplete
    BOOL success = encryptedData && [encryptedData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:nil];
    success = success && [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey : NSFileProtectionComplete} ofItemAtPath:filePath error:nil];
    if (!success)
        return NO;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    success = [self addSkipBackupAttributeToItemAtURL:fileUrl];//for privacy, not backup to iCloud
    if (!success) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        return NO;
    } else {
        return YES;
    }
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

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end

