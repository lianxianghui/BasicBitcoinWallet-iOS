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
    [LXHNetworkRequest GETWithUrlString:url parameters:parameters successCallback:^(NSDictionary * _Nonnull resultDic) {
        
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        
    }];
}

- (NSString *)urlFormat {
    return _type == LXHBitcoinNetworkTypeTestnet ?
    @"https://testnet-api.smartbit.com.au/v1/blockchain/address/%@/wallet" :  @"https://api.smartbit.com.au/v1/blockchain/address/%@/wallet";
}

@end
