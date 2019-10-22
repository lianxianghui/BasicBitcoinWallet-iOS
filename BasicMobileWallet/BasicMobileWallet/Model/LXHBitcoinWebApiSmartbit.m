//
//  LXHBitcoinWebApiSmartbit.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinWebApiSmartbit.h"
#import "LXHNetworkRequest.h"
#import "LXHTransaction.h"

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
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"transactions"] = [self allTransactionModelsWithTransactionDics:allTransactionDics];
        successBlock(dic);
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(resultDic);
    }];
}

//参考 https://testnet-api.smartbit.com.au/v1/blockchain/address/mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh,n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW/wallet 的返回值
- (NSArray<LXHTransaction *> *)allTransactionModelsWithTransactionDics:(NSArray *)transactionDics {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSDictionary *dic  in transactionDics) {
        LXHTransaction *model = [[LXHTransaction alloc] init];
        model.txid = dic[@"txid"];
        model.blockhash = dic[@"hash"];//todo
        model.block = dic[@"block"];
        model.time = dic[@"time"];
        model.confirmations = dic[@"confirmations"];
        model.inputAmount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"input_amount"]]];
        model.outputAmount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"output_amount"]]];
        model.fees = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"fee"]]];
        NSArray *inputs = dic[@"inputs"];
        for (NSDictionary *inputDic in inputs) {
            LXHTransactionInput *input = [LXHTransactionInput new];
            input.value =  [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", inputDic[@"value"]]];
            input.txid = inputDic[@"txid"];
            NSArray *inputAddresses = [inputDic valueForKey:@"addresses"];
            if (inputAddresses.count == 1) //目前只处理每个输入只有一个输入地址的情况
                input.address = inputAddresses[0];
            [model.inputs addObject:input];
        }
        NSArray *outputs = dic[@"outputs"];
        for (NSDictionary *outputDic in outputs) {
            LXHTransactionOutput *output = [LXHTransactionOutput new];
            output.value = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", outputDic[@"value"]]];
            output.spendTxid = outputDic[@"spend_txid"];
            NSArray *outputAddresses = [outputDic valueForKey:@"addresses"];
            if (outputAddresses.count == 1) //目前只处理每个输出只有一个输出地址的情况
                output.address = outputAddresses[0];
            output.lockingScript = [outputDic valueForKeyPath:@"script_pub_key.asm"];
            output.scriptType = [self scriptTypeByTypeString:[outputDic valueForKeyPath:@"type"]];
            output.txid = model.txid;
            [model.outputs addObject:output];
        }
        [ret addObject:model];
    }
    return ret;
}

- (LXHLockingScriptType)scriptTypeByTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:@"pubkeyhash"])
        return LXHLockingScriptTypeP2PKH;
    if ([typeString isEqualToString:@"scripthash"])
        return LXHLockingScriptTypeP2SH;
    return LXHLockingScriptTypeUnSupported;//其他暂时不支持
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
            [resultTransactions addObjectsFromArray:transactions];
        id nextLink = [dic valueForKeyPath:@"transaction_paging.next_link"];
        BOOL hasValidNextLink = NO;
        if (!nextLink)
            hasValidNextLink = NO;
        else {
            if ([nextLink isEqual:[NSNull null]])
                hasValidNextLink = NO;
            else if ([nextLink isKindOfClass:[NSString class]]) {
                if (![nextLink isEqualToString:@"<null>"] && [nextLink hasPrefix:@"https:"])
                    hasValidNextLink = YES;
                else
                    hasValidNextLink = NO;
            }
        }
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
