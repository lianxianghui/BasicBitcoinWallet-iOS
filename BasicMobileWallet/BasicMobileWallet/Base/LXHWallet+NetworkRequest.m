//
//  LXHWallet+NetworkRequest.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet+NetworkRequest.h"
#import "AFNetworking.h"
#import "NSJSONSerialization+VLBase.h"
#import "CoreBitcoin.h"

@implementation LXHWallet (NetworkRequest)


//ref https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#Account_discovery
- (void)findLastUsedReceivingAddressIndexWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                               failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    __block NSInteger currentFromIndex = 0;
    NSUInteger count = 20;
    __block BOOL stop = NO;//gap 
    while (!stop) {
        [self findLastUsedReceivingAddressIndexFromIndex:currentFromIndex count:count successBlock:^(NSDictionary *resultDic) {
            NSNumber *index = resultDic[@"index"];
            if (index.integerValue == -1) { //not found
                stop = YES;
            } else {
                currentFromIndex = index.integerValue+1;
            }
        } failureBlock:^(NSDictionary *resultDic) {
            failureBlock(nil);
        }];
    }
    NSDictionary *dic = @{@"lastUsedReceivingAddressIndex":@(currentFromIndex-1)};//-1 代表所有的地址都没有使用过
    successBlock(dic);
}

- (void)findLastUsedReceivingAddressIndexFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count
                                                    successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *addresses = [self receivingAddressesFromIndex:fromIndex count:count];
    [self requestTransactionsWithAddresses:addresses successBlock:^(NSDictionary *resultDic) {
        NSArray *transactions = resultDic[@"items"];
        NSSet *inAddresses = [self inAddressesWithTransactions:transactions];
        for (NSInteger i = addresses.count; i >= 0; i--) { //从后往前查
            NSString *address = addresses[i];
            if ([inAddresses containsObject:address]) {
                NSDictionary *dic = @{@"index":@(fromIndex+i)};
                successBlock(dic);
            }
        }
        NSDictionary *dic = @{@"index":@(-1)}; //not found
        successBlock(dic);
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(nil);
    }];
}

- (NSMutableArray *)receivingAddressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = fromIndex; i < fromIndex+count; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSArray *)receivingAddressesFromZeroToIndex:(NSUInteger)toIndex {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = 0; i <= toIndex; i++) {
        [addresses addObject:[self receivingAddressWithIndex:i]];
    }
    return addresses;
}

- (NSSet *)inAddressesWithTransactions:(NSArray *)transactions {
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

- (NSSet *)outAddressesWithTransactions:(NSArray *)transactions {
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

- (void)requestTransactionsWithAddresses:(NSArray *)address 
                          successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                          failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSMutableString *url = [NSMutableString string];
    if ([self currentNetworkType] == LXHBitcoinNetworkTypeMainnet)
        [url appendString:@"https://insight.bitpay.com/api/"];
    else
        [url appendString:@"https://test-insight.bitpay.com/api/"];
    [url appendString:@"addrs/txs"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"addrs"] = [address componentsJoinedByString:@","];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *json = [NSJSONSerialization objectWithJsonData:responseObject];
        successBlock(json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(nil);
    }];
}

- (void)requestAllTransactionsWithLastUsedReceivingAddressIndex:(NSInteger)lastUsedReceivingAddressIndex
                                                    successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                                    failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSArray *allReceivingAddress = [self receivingAddressesFromZeroToIndex:lastUsedReceivingAddressIndex];
    [self requestTransactionsWithAddresses:allReceivingAddress successBlock:^(NSDictionary *resultDic) {
        NSArray *transactions = resultDic[@"items"];
        if (transactions)
            successBlock(@{@"transactions":transactions});
        else
            successBlock(@{@"transactions":@[]});
    } failureBlock:^(NSDictionary *resultDic) {
        failureBlock(nil);
    }];
} 

- (NSInteger)lastUsedChangeAddressIndexWithAllTransactions:(NSArray *)transactions {
    NSSet *outAddress = [self outAddressesWithTransactions:transactions];//找零地址肯定在里面
    for (NSInteger i = outAddress.count; i >= 0; i--) { //从后往前
        NSString *changeAddress = [self changeAddressWithIndex:i];
        if ([outAddress containsObject:changeAddress])
            return i;
    }
    return NSNotFound;
}



@end
