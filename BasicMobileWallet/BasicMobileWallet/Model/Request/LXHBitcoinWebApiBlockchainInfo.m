//
//  LXHBitcoinWebApiBlockchainInfo.m
//  BasicMobileWallet
//
//  Created by lian on 2020/7/25.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinWebApiBlockchainInfo.h"
#import "LXHNetworkRequest.h"
#import "LXHTransaction.h"
#import "NSMutableDictionary+Base.h"
#import "LXHAddress+LXHAccount.h"
#import "NSDecimalNumber+LXHBTCSatConverter.h"
#import "CoreBitcoin.h"

@interface LXHBitcoinWebApiBlockchainInfo ()
@property (nonatomic) LXHBitcoinNetworkType type;
@end

@implementation LXHBitcoinWebApiBlockchainInfo

- (instancetype)initWithType:(LXHBitcoinNetworkType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)requestAllTransactionsWithAddresses:(NSArray<NSString *> *)addresses
                               successBlock:(void (^)(NSDictionary *resultDic))successBlock //keys 1.transactions
                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *url = [self transactionByAddressesUrlFormat];
    NSMutableArray *allTransactionDics = [NSMutableArray array];
    [self requestTransactionsWithUrl:(NSString *)url
                        pageIndex:0
                           addresses:(NSArray *)addresses
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
    
}


- (void)pushTransactionWithHex:(NSString *)hex
                  successBlock:(void (^)(NSDictionary *resultDic))successBlock
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    
}

- (void)requestTransactionsWithUrl:(NSString *)url
                         pageIndex:(NSUInteger)pageIndex
                         addresses:(NSArray *)addresses
                      resultTransactions:(NSMutableArray<NSDictionary *> *)resultTransactions
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSUInteger limit = 50;//max 100
    NSUInteger offset = pageIndex * limit;
    NSString *active = [addresses componentsJoinedByString:@"|"];
    NSDictionary *parameters = @{@"active":active, @"n":@(limit), @"offset":@(offset)};
    [LXHNetworkRequest GETWithUrlString:url parameters:parameters successCallback:^(NSDictionary * _Nonnull dic) {
        NSArray *transactions = dic[@"txs"];
        if (transactions.count > 0)
            [resultTransactions addObjectsFromArray:transactions];
        
        BOOL hasNotNextPage = (transactions.count < limit);
        if (hasNotNextPage) { //结束返回
            successBlock(nil);
        } else { //递归调用
            [self requestTransactionsWithUrl:url pageIndex:pageIndex+1 addresses:addresses resultTransactions:resultTransactions
                                successBlock:^(NSDictionary *resultDic) {
                                    successBlock(nil);
                                } failureBlock:^(NSDictionary *resultDic) {
                                    failureBlock(resultDic);
                                }];
        }
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        failureBlock(resultDic);
    }];
    
}

- (NSArray<LXHTransaction *> *)allTransactionModelsWithTransactionDics:(NSArray *)transactionDics {
    NSMutableArray *ret = [NSMutableArray array];
    for (NSDictionary *originalDic  in transactionDics) {
        NSMutableDictionary *dic = [originalDic mutableCopy];
        [dic eliminateAllNullObjectValues];
        LXHTransaction *model = [[LXHTransaction alloc] init];
        model.txid = dic[@"hash"];
//        model.blockhash = dic[@"hash"];
        model.block = dic[@"block_height"];
        model.time = dic[@"time"];
        model.firstSeen = model.time;//没有发起时间，只能用打包时间
//        model.confirmations = dic[@"confirmations"];

        model.fees = [NSDecimalNumber decimalBTCValueWithSatValue:[dic[@"fee"] longLongValue]];
        NSArray *inputs = dic[@"inputs"];
        __block LXHBTCAmount inputAmount = 0;
        [inputs enumerateObjectsUsingBlock:^(NSDictionary *originalInputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *inputDic = [originalInputDic mutableCopy];
            [inputDic eliminateAllNullObjectValues];
            LXHTransactionInput *input = [LXHTransactionInput new];
            input.index = idx;
            LXHBTCAmount value = [[inputDic valueForKeyPath:@"prev_out.value"] longLongValue];
            inputAmount += value;
            input.valueSat = value;
            input.txid = model.txid;
            input.vout = [[inputDic valueForKeyPath:@"prev_out.n"] unsignedIntegerValue];
            NSString *inputAddress = [inputDic valueForKeyPath:@"prev_out.addr"];
            input.address = [LXHAddress addressWithBase58String:inputAddress];
            NSString *unlockingScriptHex = [inputDic valueForKeyPath:@"prev_out.script"];
            BTCScript *script = [[BTCScript alloc] initWithHex:unlockingScriptHex];
            input.unlockingScript = script.string;
//            input.witness = inputDic[@"witness"]; todo
//            input.scriptType = [self scriptTypeByTypeString:inputDic[@"type"]]; todo
            input.sequence = [inputDic[@"sequence"] unsignedIntegerValue];
            [model.inputs addObject:input];
        }];
        model.inputAmount =  [NSDecimalNumber decimalBTCValueWithSatValue:inputAmount];

        NSArray *outputs = dic[@"out"];
        __block LXHBTCAmount outputAmount = 0;
        [outputs enumerateObjectsUsingBlock:^(NSDictionary *originalOutputDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *outputDic = [originalOutputDic mutableCopy];
            [outputDic eliminateAllNullObjectValues];
            LXHTransactionOutput *output = [LXHTransactionOutput new];
            output.index = [outputDic[@"n"] unsignedIntegerValue];
            LXHBTCAmount value = [outputDic[@"value"] longLongValue];
            outputAmount += value;
            output.valueSat = value;
            
            output.spent = [outputDic[@"spent"] boolValue];//todo
            output.address = [LXHAddress addressWithBase58String:outputDic[@"addr"]];
            output.lockingScriptHex = [outputDic valueForKeyPath:@"script"];
            BTCScript *lockingScript = [[BTCScript alloc] initWithHex:output.lockingScriptHex];
            output.lockingScript = lockingScript.string;
//            output.scriptType = [self scriptTypeByTypeString:outputDic[@"type"]]; //0
            output.txid = model.txid;
            [model.outputs addObject:output];
        }];
        model.outputAmount = [NSDecimalNumber decimalBTCValueWithSatValue:outputAmount];
        [ret addObject:model];
    }
    return ret;
}

- (LXHLockingScriptType)scriptTypeByType:(NSUInteger)type {
    switch (type) {
        case 0:
            return LXHLockingScriptTypeP2PKH;
            break;
            
        default:
            return LXHLockingScriptTypeUnSupported;
            break;
    }
    
//    if ([typeString isEqualToString:@"pubkeyhash"])
//        return LXHLockingScriptTypeP2PKH;
//    if ([typeString isEqualToString:@"scripthash"])
//        return LXHLockingScriptTypeP2SH;
//    if ([typeString isEqualToString:@"witness_v0_keyhash"])
//        return LXHLockingScriptTypeP2WPKH;
//    if ([typeString isEqualToString:@"witness_v0_scripthash"])
//        return LXHLockingScriptTypeP2WSH;
//    if ([typeString isEqualToString:@"nulldata"])
//        return LXHLockingScriptTypeNullData;
    //其他暂时不支持
    //nulldata  无实际输出，用OP_RETURN 存放数据的输出会返回 nulldata
    
}


- (NSString *)transactionByAddressesUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"multiaddr"];
}

- (NSString *)transactionByIdsUrlFormat {
    return [[self bashUrl] stringByAppendingString:@"rawtx/%@"];
}

- (NSString *)bashUrl {
    return _type == LXHBitcoinNetworkTypeTestnet ?
    @"https://testnet.blockchain.info/" :  @"https://blockchain.info/";
}


@end
