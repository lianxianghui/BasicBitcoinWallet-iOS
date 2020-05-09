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
#import "NSMutableDictionary+Base.h"
#import "LXHAddress+LXHAccount.h"

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
    NSString *url = [NSString stringWithFormat:[self transactionByAddressesUrlFormat], addressesString];
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

- (void)requestTransactionsByIds:(NSArray<NSString *> *)txids
                    successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *txidsString = [txids componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:[self transactionByIdsUrlFormat], txidsString];
    [LXHNetworkRequest GETWithUrlString:url parameters:nil successCallback:^(NSDictionary * _Nonnull resultDic) {
        BOOL success =  [resultDic[@"success"] boolValue];
        if (!success) {
            failureBlock(nil);
            return;
        }
        NSArray *transactions = resultDic[@"transactions"];
        if (!transactions) {
            NSDictionary *transaction = resultDic[@"transaction"];
            if (transaction)
                transactions = @[transaction];
        }
        if (!transactions) { //应该不会发生
            failureBlock(nil);
            return;
        }
            
        NSArray *models = [self allTransactionModelsWithTransactionDics:transactions];
        NSMutableDictionary *ret = [NSMutableDictionary dictionary];
        ret[@"transactions"] = models;
        if (transactions.count == 1) //for convenience
            ret[@"transaction"] = models[0];
        successBlock(ret);
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
}

//参考 https://testnet-api.smartbit.com.au/v1/blockchain/address/mrQoR4BMyZWyAZfHF4NuqRmkVtp87AqsUh,n1dAqxk6UCb6568d5f28W2sh6LvwkP5snW/wallet 的返回值
- (NSArray<LXHTransaction *> *)allTransactionModelsWithTransactionDics:(NSArray *)transactionDics {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSDictionary *originalDic  in transactionDics) {
        NSMutableDictionary *dic = [originalDic mutableCopy];
        [dic eliminateAllNullObjectValues];
        LXHTransaction *model = [[LXHTransaction alloc] init];
        model.txid = dic[@"txid"];
        model.blockhash = dic[@"hash"];
        model.block = dic[@"block"];
        model.time = dic[@"time"];
        model.firstSeen = dic[@"first_seen"];
        model.confirmations = dic[@"confirmations"];
        model.inputAmount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"input_amount"]]];
        model.outputAmount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"output_amount"]]];
        model.fees = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", dic[@"fee"]]];
        NSArray *inputs = dic[@"inputs"];
        [inputs enumerateObjectsUsingBlock:^(NSDictionary *originalInputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *inputDic = [originalInputDic mutableCopy];
            [inputDic eliminateAllNullObjectValues];
            LXHTransactionInput *input = [LXHTransactionInput new];
            input.index = idx;
            input.valueBTC =  [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", inputDic[@"value"]]];
            input.txid = inputDic[@"txid"];
            input.vout = [inputDic[@"vout"] unsignedIntegerValue];
            NSArray *inputAddresses = [inputDic valueForKey:@"addresses"];
            if (inputAddresses.count == 1) //目前只处理每个输入只有一个输入地址的情况
                input.address = [LXHAddress addressWithBase58String:inputAddresses[0]];
            input.unlockingScript = [inputDic valueForKeyPath:@"script_sig.asm"];
            input.witness = inputDic[@"witness"];
            input.scriptType = [self scriptTypeByTypeString:inputDic[@"type"]];
            input.sequence = [inputDic[@"sequence"] unsignedIntegerValue];
            [model.inputs addObject:input];
        }];
        NSArray *outputs = dic[@"outputs"];
        [outputs enumerateObjectsUsingBlock:^(NSDictionary *originalOutputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *outputDic = [originalOutputDic mutableCopy];
            [outputDic eliminateAllNullObjectValues];
            LXHTransactionOutput *output = [LXHTransactionOutput new];
            output.index = [outputDic[@"n"] unsignedIntegerValue];
            output.valueBTC = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", outputDic[@"value"]]];
            output.spendTxid = outputDic[@"spend_txid"];
            NSArray *outputAddresses = [outputDic valueForKey:@"addresses"];
            if (outputAddresses.count == 1) //目前只处理每个输出只有一个输出地址的情况
                output.address = [LXHAddress addressWithBase58String:outputAddresses[0]];
            output.lockingScript = [outputDic valueForKeyPath:@"script_pub_key.asm"];
            output.lockingScriptHex = [outputDic valueForKeyPath:@"script_pub_key.hex"];
            output.scriptType = [self scriptTypeByTypeString:outputDic[@"type"]];
            output.txid = model.txid;
            [model.outputs addObject:output];
        }];
        [ret addObject:model];
    }
    return ret;
}

- (LXHLockingScriptType)scriptTypeByTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:@"pubkeyhash"])
        return LXHLockingScriptTypeP2PKH;
    if ([typeString isEqualToString:@"scripthash"])
        return LXHLockingScriptTypeP2SH;
    if ([typeString isEqualToString:@"witness_v0_keyhash"])
        return LXHLockingScriptTypeP2WPKH;
    if ([typeString isEqualToString:@"witness_v0_scripthash"])
        return LXHLockingScriptTypeP2WSH;
    if ([typeString isEqualToString:@"nulldata"])
        return LXHLockingScriptTypeNullData;
    //其他暂时不支持  witness_v0_keyhash   Pay-to-Witness-Public-Key-Hash
    //nulldata  无实际输出，用OP_RETURN 存放数据的输出会返回 nulldata
    return LXHLockingScriptTypeUnSupported;
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

- (NSString *)transactionByAddressesUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"address/%@/wallet"];
}

- (NSString *)transactionByIdsUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"tx/%@"];
}

- (NSString *)bashUrl {
    return _type == LXHBitcoinNetworkTypeTestnet ?
    @"https://testnet-api.smartbit.com.au/v1/blockchain/" :  @"https://api.smartbit.com.au/v1/blockchain/";
}

- (void)pushTransactionWithHex:(NSString *)hex
                  successBlock:(void (^)(NSDictionary *resultDic))successBlock
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    if (!hex)
        return;
    NSString *url = [[self bashUrl] stringByAppendingString:@"pushtx"];
    [LXHNetworkRequest POSTWithUrlString:url parameters:@{@"hex":hex} successCallback:successBlock failureCallback:failureBlock];
}

@end
