//
//  LXHBitcoinWebApiSmartbit.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinWebApiSmartbit.h"
#import "LXHNetworkRequest.h"

@interface LXHBitcoinWebApiSmartbit ()
@property (nonatomic) LXHBitcoinNetworkType type;
@end

@implementation LXHBitcoinWebApiSmartbit

- (instancetype)initWithType:(LXHBitcoinNetworkType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)requestAllTransactionsWithAddresses:(NSArray<NSString *> *)addresses
                               successBlock:(void (^)(NSDictionary *resultDic))successBlock
                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *addressesString = [addresses componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:[self urlFormat], addressesString];
    NSDictionary *parameters = @{@"limit" : @(100)};
    NSMutableArray *allTransactionDics = [NSMutableArray array];
    [self requestTransactionsWithUrlString:url
                                parameters:parameters
                            resultTransactions:allTransactionDics
    successBlock:^(NSDictionary *resultDic) {
        NSArray<LXHTransaction *> *allTransactionModels = [self allTransactionModelsWithTransactionDics:allTransactionDics];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"transactions"] = allTransactionModels;
        successBlock(dic);
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(resultDic);
    }];
}

- (NSArray<LXHTransaction *> *)allTransactionModelsWithTransactionDics:(NSArray *)transactionDics {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSDictionary *dic  in transactionDics) {
        LXHTransaction *model = [[LXHTransaction alloc] init];
    }
}

- (void)requestTransactionsWithUrlString:(NSString *)url
                              parameters:(NSDictionary *)parameters
                       resultTransactions:(NSMutableArray<NSDictionary *> *)resultTransactions
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    [LXHNetworkRequest GETWithUrlString:url parameters:parameters successCallback:^(NSDictionary * _Nonnull resultDic) {
        NSDictionary *dic = resultDic[@"wallet"];
        NSArray *transactions = dic[@"transactions"];
        if (transactions.count > 0)
            [resultTransactions addObjectsFromArray:transactions];
        NSString *nextLink = [dic valueForKeyPath:@"transaction_paging.next_link"];
        BOOL hasValidNextLink = nextLink && ![nextLink isEqualToString:@"<null>"] && [nextLink hasPrefix:@"https:"];
        if (!hasValidNextLink) { //结束返回
            successBlock(nil);
        } else { //递归调用，这时候直接用nextLink
            [self requestTransactionsWithUrlString:nextLink parameters:nil resultTransactions:resultTransactions successBlock:^(NSDictionary *resultDic) {
                successBlock(nil);
            } failureBlock:^(NSDictionary *resultDic) {
                failureBlock(resultDic);
            }];
        }
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
    
}

- (NSString *)urlFormat {
    return _type == LXHBitcoinNetworkTypeTestnet ?
    @"https://testnet-api.smartbit.com.au/v1/blockchain/address/%@/wallet" :  @"https://api.smartbit.com.au/v1/blockchain/address/%@/wallet";
}

@end
