//
//  LXHBitcoinWebApiMyElectrs.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/9/15.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinWebApiMyElectrs.h"
#import "LXHNetworkRequest.h"
#import "LXHTransaction.h"
#import "NSMutableDictionary+Base.h"
#import "LXHAddress+LXHAccount.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "CoreBitcoin.h"


@interface LXHBitcoinWebApiMyElectrs ()
@property (nonatomic) NSString * endPoint;
@end
@implementation LXHBitcoinWebApiMyElectrs

- (instancetype)initWithEndPoint:(NSString *)endPoint {
    self = [super init];
    if (self) {
        _endPoint = endPoint;
    }
    return self;
}


- (void)requestAllTransactionsWithAddresses:(NSArray<NSString *> *)addresses
                               successBlock:(void (^)(NSDictionary *resultDic))successBlock
                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *addressesString = [addresses componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:[self transactionByAddressesUrlFormat], addressesString];
    NSDictionary *parameters = @{};
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

- (void)requestTransactionsByUrl:(NSString *)url
                    successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
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

- (void)requestTransactionsById:(NSString *)txid
                   successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *url = [NSString stringWithFormat:[self transactionByIdsUrlFormat], txid];
    [LXHNetworkRequest GETWithUrlString:url parameters:nil successCallback:^(NSDictionary * _Nonnull resultDic) {
        NSArray *transactions = @[resultDic];
        NSArray *models = [self allTransactionModelsWithTransactionDics:transactions];
        NSMutableDictionary *ret = [NSMutableDictionary dictionary];
        ret[@"transactions"] = models;
        if (transactions.count == 1) //for convenience
            ret[@"transaction"] = models[0];
        successBlock(ret);
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];}

- (void)requestTransactionsByIds:(NSArray<NSString *> *)txids
                    successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *txidsString = [txids componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:[self transactionByIdsUrlFormat], txidsString];
    [self requestTransactionsByUrl:url successBlock:successBlock failureBlock:failureBlock];
}

- (NSArray<LXHTransaction *> *)allTransactionModelsWithTransactionDics:(NSArray *)transactionDics {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSDictionary *originalDic  in transactionDics) {
        NSMutableDictionary *dic = [originalDic mutableCopy];
        [dic eliminateAllNullObjectValues];
        LXHTransaction *model = [[LXHTransaction alloc] init];
        model.txid = dic[@"txid"];
        model.block = [dic valueForKeyPath:@"status.block_height"];
        model.time = [dic valueForKeyPath:@"status.block_time"];
        model.firstSeen = model.time;
        model.confirmations = dic[@"confirmations"];
        
        model.fees = [NSDecimalNumber decimalBTCValueWithSatValue:[dic[@"fee"] longLongValue]];
        NSArray *inputs = dic[@"vin"];
        __block LXHBTCAmount inputAmount = 0;
        [inputs enumerateObjectsUsingBlock:^(NSDictionary *originalInputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *inputDic = [originalInputDic mutableCopy];
            [inputDic eliminateAllNullObjectValues];
            LXHTransactionInput *input = [LXHTransactionInput new];
            input.index = idx;
            LXHBTCAmount value = [[inputDic valueForKeyPath:@"prevout.value"] longLongValue];
            inputAmount += value;
            input.valueSat = value;
            input.txid = [inputDic valueForKeyPath:@"txid"];
            input.vout = [[inputDic valueForKeyPath:@"vout"] unsignedIntegerValue];//todo 检查,应该是
            NSString *inputAddress = [inputDic valueForKeyPath:@"prevout.scriptpubkey_address"];
            input.address = [LXHAddress addressWithBase58String:inputAddress];
            NSString *unlockingScriptHex = [inputDic valueForKeyPath:@"scriptsig"];//todo jiancha
            BTCScript *script = [[BTCScript alloc] initWithHex:unlockingScriptHex];
            input.unlockingScript = script.string;
            input.witness = inputDic[@"witness"];
            NSString *scriptTypeString = [inputDic valueForKeyPath:@"prevout.scriptpubkey_type"];
            input.scriptType = [self scriptTypeByTypeString:scriptTypeString];
            input.sequence = [inputDic[@"sequence"] unsignedIntegerValue];
            [model.inputs addObject:input];
        }];
        model.inputAmount =  [NSDecimalNumber decimalBTCValueWithSatValue:inputAmount];
        
        NSArray *outputs = dic[@"vout"];
        __block LXHBTCAmount outputAmount = 0;
        [outputs enumerateObjectsUsingBlock:^(NSDictionary *originalOutputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *outputDic = [originalOutputDic mutableCopy];
            [outputDic eliminateAllNullObjectValues];
            LXHTransactionOutput *output = [LXHTransactionOutput new];
            output.index = idx;
            LXHBTCAmount value = [outputDic[@"value"] longLongValue];
            outputAmount += value;
            output.valueSat = value;
            
            output.spent = [outputDic[@"spent"] boolValue];//todo
            output.address = [LXHAddress addressWithBase58String:outputDic[@"scriptpubkey_address"]];//todo
            output.lockingScriptHex = [outputDic valueForKeyPath:@"scriptpubkey"];
            BTCScript *lockingScript = [[BTCScript alloc] initWithHex:output.lockingScriptHex];
            output.lockingScript = lockingScript.string;
            NSString *scriptTypeString = [outputDic valueForKeyPath:@"scriptpubkey_type"];
            output.scriptType = [self scriptTypeByTypeString:scriptTypeString];
            output.txid = model.txid;
            [model.outputs addObject:output];
        }];
        model.outputAmount = [NSDecimalNumber decimalBTCValueWithSatValue:outputAmount];
        [ret addObject:model];
    }
    return ret;
}

- (LXHLockingScriptType)scriptTypeByTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:@"p2pkh"])
        return LXHLockingScriptTypeP2PKH;
    if ([typeString isEqualToString:@"p2sh"])
        return LXHLockingScriptTypeP2SH;
    if ([typeString isEqualToString:@"v0_p2wpkh"])
        return LXHLockingScriptTypeP2WPKH;
    if ([typeString isEqualToString:@"v0_p2wsh"])
        return LXHLockingScriptTypeP2WSH;
//    if ([typeString isEqualToString:@"nulldata"])
//        return LXHLockingScriptTypeNullData;
    //其他暂时不支持
    //nulldata  无实际输出，用OP_RETURN 存放数据的输出会返回 nulldata
    return LXHLockingScriptTypeUnSupported;
}

- (void)requestTransactionsWithUrlString:(NSString *)url
                              parameters:(NSDictionary *)parameters
                      resultTransactions:(NSMutableArray<NSDictionary *> *)resultTransactions
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    [LXHNetworkRequest GETWithUrlString:url parameters:parameters successCallback:^(NSArray * _Nonnull result) {
        NSArray *transactions = result;
        if (transactions) {
            [resultTransactions addObjectsFromArray:transactions];
            successBlock(nil);
        } else {
            failureBlock(nil);
        }
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
    
}

- (NSString *)transactionByAddressesUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"addresses/%@/txs"];
}

- (NSString *)transactionByIdsUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"tx/%@"];
}

- (NSString *)bashUrl {
    return [NSString stringWithFormat:@"http://%@/", _endPoint];
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
