//
//  LXHTransactionDataRequest.m
//  BasicMobileWallet
//
//  Created by lian on 2020/5/11.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHTransactionDataRequest.h"
#import "LXHNetworkRequest.h"
#import "LXHTransactionDataManager.h"
#import "LXHWallet.h"

@implementation LXHTransactionDataRequest

+ (void)requestDataWithSuccessBlock:(nullable void (^)(NSDictionary *resultDic))successBlock
                       failureBlock:(nullable void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *addresses = [[LXHWallet mainAccount] usedAndCurrentAddresses];
    [self requestTransactionsWithNetworkType:LXHWallet.mainAccount.currentNetworkType addresses:addresses successBlock:^(NSDictionary * _Nonnull resultDic) {
        NSArray *transactions = resultDic[@"transactions"];
        [[LXHTransactionDataManager sharedInstance] setTransactionList:transactions];
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

+ (void)requestTransactionsWithTxids:(NSArray *)txids
                        successBlock:(void (^)(NSDictionary *resultDic))successBlock
                        failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:LXHWallet.mainAccount.currentNetworkType];
    [webApi requestTransactionsByIds:txids successBlock:successBlock failureBlock:failureBlock];
}

+ (void)pushTransactionsWithHex:(NSString *)hex
                   successBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    id<LXHBitcoinWebApi> webApi = [self webApiWithType:LXHWallet.mainAccount.currentNetworkType];
    [webApi pushTransactionWithHex:hex successBlock:^(NSDictionary * _Nonnull resultDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //发送成功了更新一下交易列表（只请求一次，如果失败了，用户需要手动刷新交易列表
            [self requestDataWithSuccessBlock:nil failureBlock:nil];
        });
        successBlock(resultDic);
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
    id<LXHBitcoinWebApi> ret = [[LXHBitcoinWebApiSmartbit alloc] initWithType:type];
    return ret;
}


@end
