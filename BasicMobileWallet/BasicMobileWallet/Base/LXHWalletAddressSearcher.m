//
//  LXHWalletAddressSearcher.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWalletAddressSearcher.h"
#import "AFNetworking.h"
#import "NSJSONSerialization+VLBase.h"
#import "CoreBitcoin.h"

@interface LXHWalletAddressSearcher ()
@property (nonatomic) LXHWallet *wallet;
@property (nonatomic) AFHTTPSessionManager *manager;
@end

@implementation LXHWalletAddressSearcher

- (instancetype)initWithWallet:(LXHWallet *)wallet {
    self = [super init];
    if (self) {
        _wallet = wallet;
    }
    return self;
}

//- (void)searchWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
//            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
//    [self findLastUsedReceivingAddressIndexWithSuccessBlock:^(NSDictionary *resultDic) {
//        NSMutableDictionary *dic = [resultDic mutableCopy];
//        NSArray *allTransactions = resultDic[@"allTransactions"];
//        dic[@"lastUsedChangeAddressIndex"] = @([self lastUsedChangeAddressIndexWithAllTransactions:allTransactions]);
//        successBlock(dic);
//    } failureBlock:^(NSDictionary *resultDic) {
//        failureBlock(nil);
//    }];
//}

- (void)searchWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSMutableArray *allTransactions = [NSMutableArray array];
    [self searchFirstUnusedReceivingAddressesGapFromIndex:0 allTransactions:allTransactions successBlock:^(NSDictionary *resultDic) {
        NSNumber *FirstUnusedReceivingAddressesGapStartIndex = resultDic[@"FirstUnusedReceivingAddressesGapStartIndex"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"currentUnusedReceivingAddressIndex"] = FirstUnusedReceivingAddressesGapStartIndex;
        //allTransactions是搜索UnusedReceivingAddressesGap过程中从网络获取的
        //因为找零肯定都是从接收地址发出去的，所以包含找零地址的交易肯定都在allTransactions中
        //这里直接使用allTransactions获取下一个找零地址
        dic[@"currentUnusedChangeAddressIndex"] = @([self currentUnusedChangeAddressIndexWithAllTransactions:allTransactions]);
        dic[@"allTransactions"] = allTransactions;
        successBlock(dic);
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(resultDic);
    }];
}

/**
 找到当前账户的第一个未使用的ReceivingAddressGap, gap limit为20
 具体逻辑参考https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#Account_discovery
 异步+递归的实现稍微有点复杂
 返回值有两个：1.通过successBlock返回第一个未使用ReceivingAddressGap的起始index 2.通过一开始传入的allTransactions NSMutableArray累积从网络获取的交易数据
 */
- (void)searchFirstUnusedReceivingAddressesGapFromIndex:(NSUInteger)fromIndex
                         allTransactions:(NSMutableArray *)allTransactions
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSUInteger gapLimit = 20;
    NSArray *addressesForRequesting = [_wallet receivingAddressesFromIndex:fromIndex count:gapLimit];
    [self requestTransactionsWithAddresses:addressesForRequesting successBlock:^(NSDictionary *resultDic) {
        NSArray *transactions = resultDic[@"items"];
        if (transactions.count == 0) { //未找到新的交易，说明当前的20个地址都未用过，所以就是要找的Gap
            successBlock(@{@"FirstUnusedAddressesGapStartIndex":@(fromIndex)});
        } else {
            [allTransactions addObjectsFromArray:transactions];
            //查找从哪里开始进行下一次搜索
            NSSet *allInAddressesSet = [self inAddressesWithTransactions:transactions];//所有可能的接收地址
            //总共20个请求地址。现在从后往前查，找到第一个用过的地址index，然后以这个index+1为fromIndex递归调用
            for (NSInteger i = addressesForRequesting.count-1; i >= 0; i--) {
                NSString *address = addressesForRequesting[i];
                if ([allInAddressesSet containsObject:address]) {//找到第一个使用过的地址
                    NSUInteger nextFromIndex = fromIndex + i + 1;
                    [self searchFirstUnusedReceivingAddressesGapFromIndex:nextFromIndex allTransactions:allTransactions successBlock:successBlock failureBlock:failureBlock];
                    return;
                }
            }
            NSAssert(YES, @"");//不应该到这里，因为如果有交易返回，说明在地址中肯定有用过的，所以一定能走到上面"找到第一个used地址"那里
            failureBlock(@{@"error":@"logic error"});
        }
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(nil);
    }];
}

//异步请求，通过successBlock传回事务数据
- (void)requestTransactionsWithAddresses:(NSArray *)address 
                            successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                            failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *baseUrl;
    if ([_wallet currentNetworkType] == LXHBitcoinNetworkTypeMainnet)
        baseUrl = @"https://insight.bitpay.com/";
    else
        baseUrl = @"https://test-insight.bitpay.com/";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    self.manager = manager;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"addrs"] = [address componentsJoinedByString:@","];
    [manager POST:@"api/addrs/txs" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(nil);
    }];
}

- (NSMutableSet *)inAddressesWithTransactions:(NSArray *)transactions {
    NSMutableSet *ret = [NSMutableSet set];
    for (NSDictionary *dic in transactions) {
        NSArray *vins = dic[@"vin"];
        for (NSDictionary *vin in vins) {
            if (vin[@"addr"])
                [ret addObject:vin[@"addr"]];
        }
    }
    return ret;
}

- (NSMutableSet *)outAddressesWithTransactions:(NSArray *)transactions {
    NSMutableSet *ret = [NSMutableSet set];
    for (NSDictionary *dic in transactions) {
        NSArray *vouts = dic[@"vout"];
        for (NSDictionary *vout in vouts) {
            NSString *address = vout[@"scriptPubKey"][@"addresses"][0];//TODO check
            if (address)
                [ret addObject:address];
        }
    }
    return ret;
}

//- (void)requestAllTransactionsWithLastUsedReceivingAddressIndex:(NSInteger)lastUsedReceivingAddressIndex
//                                                   successBlock:(void (^)(NSDictionary *resultDic))successBlock 
//                                                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
//    NSArray *allReceivingAddress = [_wallet receivingAddressesFromZeroToIndex:lastUsedReceivingAddressIndex];
//    [self requestTransactionsWithAddresses:allReceivingAddress successBlock:^(NSDictionary *resultDic) {
//        NSArray *transactions = resultDic[@"items"];
//        if (transactions)
//            successBlock(@{@"transactions":transactions});
//        else
//            successBlock(@{@"transactions":@[]});
//    } failureBlock:^(NSDictionary *resultDic) {
//        failureBlock(nil);
//    }];
//} 

- (NSInteger)currentUnusedChangeAddressIndexWithAllTransactions:(NSArray *)allTransactions {
    NSSet *allOutAddressSet = [self outAddressesWithTransactions:allTransactions];
    NSInteger maxPossibleUsedChangeAddressCount = allOutAddressSet.count; //找零地址肯定在allOutAddressSet里面，所以最大不会超过allOutAddressSet的数量
    for (NSInteger i = maxPossibleUsedChangeAddressCount-1; i >= 0; i--) { //找到倒数第一个用过的，也就是最后一个用过的，加一就得到下一个准备使用的找零地址
        NSString *changeAddress = [_wallet changeAddressWithIndex:i];
        if ([allOutAddressSet containsObject:changeAddress])
            return i+1;
    }
    return 0;//没有使用过找零地址
}
@end
