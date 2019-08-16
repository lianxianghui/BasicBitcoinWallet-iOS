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
    NSArray *addresses = [self addressesFromIndex:fromIndex count:count];
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

- (NSMutableArray *)addressesFromIndex:(NSUInteger)fromIndex count:(NSUInteger)count {
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSUInteger i = fromIndex; i < fromIndex+count; i++) {
        [addresses addObject:[self receivingAddressWithIndex:(uint32_t)i]];
    }
    return addresses;
}

- (NSSet *)inAddressesWithTransactions:(NSArray *)transactions {
    NSMutableSet *ret = [NSMutableSet set];
    for (NSDictionary *dic in transactions) {
        NSArray *vins = dic[@"vin"];
        for (NSString *vin in vins) {
            if (vin)
                [ret addObject:vin];
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



@end
