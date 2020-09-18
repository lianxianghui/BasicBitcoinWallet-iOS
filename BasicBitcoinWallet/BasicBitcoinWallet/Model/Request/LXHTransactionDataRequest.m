//
//  LXHTransactionDataRequest.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/11.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHTransactionDataRequest.h"
#import "LXHNetworkRequest.h"
#import "LXHTransactionDataManager.h"
#import "LXHWallet.h"
#import "BlocksKit.h"
#import "CoreBitcoin.h"
#import "LXHBitcoinWebApiBlockchainInfo.h"
#import "LXHBitcoinWebApiMyElectrs.h"

@implementation LXHTransactionDataRequest

+ (void)requestDataWithSuccessBlock:(nullable void (^)(NSDictionary *resultDic))successBlock
                       failureBlock:(nullable void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *addresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    [self requestTransactionsWithNetworkType:LXHWallet.mainAccount.currentNetworkType addresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        NSArray *transactions = resultDic[@"transactions"];
        if (![[LXHTransactionDataManager sharedInstance] setAndSaveTransactionList:transactions]) {
            NSMutableDictionary* info = [NSMutableDictionary dictionary];
            [info setValue:NSLocalizedString(@"保存交易列表数据失败", nil) forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"LXHErrorDomain" code:-1 userInfo:info];
            failureBlock(@{@"error":error});
        }
        //更新钱包的当前地址
        NSSet *allUsedBase58Addresses = [[LXHTransactionDataManager sharedInstance] allBase58Addresses];
        [LXHWallet.mainAccount updateUsedBase58AddressesIfNeeded:allUsedBase58Addresses];
        if (successBlock)
            successBlock(resultDic);
    } failureBlock:^(NSDictionary * _Nonnull resultDic) {
        if (failureBlock)
            failureBlock(resultDic);
    }];
}

+ (void)requestTransactionsWithNetworkType:(LXHBitcoinNetworkType)type
                                 addresses:(NSArray *)addresses
                              successBlock:(void (^)(NSDictionary *resultDic))successBlock
                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:type];
    [webApi requestAllTransactionsWithAddresses:addresses successBlock:successBlock failureBlock:failureBlock];
}

+ (void)requestTransactionsWithTxid:(NSString *)txid
                        successBlock:(void (^)(NSDictionary *resultDic))successBlock
                        failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:LXHWallet.mainAccount.currentNetworkType];
    [webApi requestTransactionsById:txid successBlock:successBlock failureBlock:failureBlock];
}

//successBlock
//code 0 代表 发送交易和更新交易列表都成功
//code 1 代表 发送交易成功和更新交易列表失败
+ (void)pushTransactionsWithHex:(NSString *)hex
                   successBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:LXHWallet.mainAccount.currentNetworkType];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [webApi pushTransactionWithHex:hex successBlock:^(NSDictionary * _Nonnull resultDic) {
        //发送成功了更新一下交易（只请求一次，如果失败了，用户需要手动刷新余额或交易列表）
        //立刻请求会没有新交易，需要延迟一会儿再请求
        NSString *txid = resultDic[@"txid"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestDataWithSuccessBlock:^(NSDictionary * _Nonnull resultDic) {
            CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start;
                NSArray *transactions = resultDic[@"transactions"];
                NSArray *txids = [transactions bk_map:^id(LXHTransaction *obj) {
                    return obj.txid;
                }];
                if ([txids containsObject:txid]) {//包含刚发送的交易，说明更新成功
                    NSLog(@"%@ %0.3f", @"transaction list updated", took);
                    successBlock(@{@"code":@(0)});
                } else {//还是旧数据
                    NSLog(@"%@ %0.3f", @"transaction list not updated", took);
                    successBlock(@{@"code":@(1)});
                }
            } failureBlock:^(NSDictionary * _Nonnull resultDic) {
                successBlock(@{@"code":@(1)});
            }];
        
/*
            BTCTransaction *transaction = [[BTCTransaction alloc] initWithHex:hex];
            NSArray *inputsTransactionIds = [transaction.inputs bk_map:^id(BTCTransactionInput *input) {
                return input.previousTransactionID;
            }];
            NSSet *inputsTransactionIdSet = [NSSet setWithArray:inputsTransactionIds];
            inputsTransactionIds = inputsTransactionIdSet.allObjects;
            if (!txid || inputsTransactionIds.count == 0)
                return failureBlock(nil);

            NSMutableArray *allTxids = [NSMutableArray arrayWithArray:inputsTransactionIds];
            [allTxids addObject:txid];
            [webApi requestTransactionsByIds:allTxids successBlock:^(NSDictionary * _Nonnull resultDic) {
                NSArray<LXHTransaction *> *array = resultDic[@"transactions"];
                if (array.count != allTxids.count) {
                    CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start;
                    NSLog(@"%@ %0.3f", @"only transaction, related transactions not updated", took);
                    successBlock(@{@"code":@(1)});
                } else {
                    NSMutableArray *transactionList = [[LXHTransactionDataManager sharedInstance] transactionList].mutableCopy;
                    [array enumerateObjectsUsingBlock:^(LXHTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj.txid isEqualToString:txid]) {
                            [LXHTransactionDataManager updateOldTransactionToNewTransaction:obj inArray:transactionList];
                        } else {
                            [LXHTransactionDataManager addTransaction:obj toArray:transactionList];
                        }
                    }];
                    [[LXHTransactionDataManager sharedInstance] setAndSaveTransactionList:transactionList];
                    CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start;
                    NSLog(@"%@ %0.3f", @"only transaction, related transactions updated", took);
                    successBlock(@{@"code":@(0)});
                }
            } failureBlock:^(NSDictionary * _Nonnull resultDic) {
                successBlock(@{@"code":@(1)});
            }];*/
        });
    } failureBlock:failureBlock];
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
    id<LXHBitcoinWebApi> ret = nil;
    NSDictionary *serverData = [LXHWallet selectedServerInfo];
    NSString *apiName = serverData[@"apiName"];
    NSString *endPoint = serverData[@"endPoint"];
    if ([apiName isEqualToString:@"myElectrs"])
        ret = [[LXHBitcoinWebApiMyElectrs alloc] initWithEndPoint:endPoint];
    else if ([apiName isEqualToString:@"smartBit"])
        ret = [[LXHBitcoinWebApiSmartbit alloc] initWithEndPoint:endPoint];
    return ret;
}


@end
