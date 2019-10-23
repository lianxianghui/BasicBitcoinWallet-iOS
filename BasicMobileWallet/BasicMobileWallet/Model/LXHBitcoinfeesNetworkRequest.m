//
//  LXHBitcoinfeesNetworkRequest.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/23.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHBitcoinfeesNetworkRequest.h"
#import "LXHNetworkRequest.h"
#import "LXHGlobalHeader.h"

static NSString *const cacheFileName = @"LXHBitcoinfeesNetworkRequestCache";

#define LXHBitcoinfeesNetworkRequestCacheFilePath [NSString stringWithFormat:@"%@/%@",  LXHCacheFileDir, cacheFileName]

@implementation LXHBitcoinfeesNetworkRequest


+ (instancetype)sharedInstance {
    static LXHBitcoinfeesNetworkRequest *instance = nil;
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
        instance = [[LXHBitcoinfeesNetworkRequest alloc] init];
    });
    return instance;
}

- (void)requestWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSDictionary *cachedDate = [self cachedData];
    if (cachedDate && [self cacheExpiredWithDate:cachedDate[@"responseTime"]]) {
        successBlock(cachedDate[@"responseData"]);
        return;
    } else {
        NSString *url = @"https://bitcoinfees.earn.com/api/v1/fees/recommended";
        [LXHNetworkRequest GETWithUrlString:url parameters:nil successCallback:^(NSDictionary * _Nonnull resultDic) {
            [self cacheResultDic:resultDic];
            successBlock(resultDic);
        } failureCallback:^(NSDictionary * _Nonnull resultDic) {
            failureBlock(resultDic);
        }];
    }
}

- (void)cacheResultDic:(NSDictionary *)resultDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"responseTime"] = [NSDate date];
    dic[@"responseData"] = resultDic;
    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:dic];
    [data writeToFile:LXHBitcoinfeesNetworkRequestCacheFilePath atomically:YES];
}

- (NSDictionary *)cachedData {
    NSData *data = [NSData dataWithContentsOfFile:LXHBitcoinfeesNetworkRequestCacheFilePath];
    if (data) {
        NSDictionary *ret = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return ret;
    } else {
        return nil;
    }
}

- (BOOL)cacheExpiredWithDate:(NSDate *)date {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    return interval >  2 * 60 * 60;
}

@end
