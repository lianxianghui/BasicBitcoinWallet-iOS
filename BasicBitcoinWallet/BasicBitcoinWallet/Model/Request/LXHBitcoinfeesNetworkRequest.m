//
//  LXHBitcoinfeesNetworkRequest.m
//  BasicBitcoinWallet
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
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[LXHBitcoinfeesNetworkRequest alloc] init];
    });
    return instance;
}

- (void)requestWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                   failureBlock:(void (^)(NSDictionary *resultDic))failureBlock {
    NSString *url = @"https://bitcoinfees.earn.com/api/v1/fees/recommended";
    [LXHNetworkRequest GETWithUrlString:url parameters:nil successCallback:^(NSDictionary * _Nonnull resultDic) {
        NSMutableDictionary *dic = [self cacheResultDic:resultDic];
        successBlock(dic);
    } failureCallback:^(NSDictionary * _Nonnull resultDic) {
        NSDictionary *cachedData = [self cachedData];
        if (cachedData) {
            NSMutableDictionary *dic = [resultDic mutableCopy];
            dic[@"cachedResult"] = cachedData;
            failureBlock(dic);
        } else {
            failureBlock(nil);
        }
    }];
}

- (NSMutableDictionary *)cacheResultDic:(NSDictionary *)resultDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"responseTime"] = [NSDate date];
    dic[@"responseData"] = resultDic;
    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:dic];
    [data writeToFile:LXHBitcoinfeesNetworkRequestCacheFilePath atomically:YES];
    return dic;
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

//- (BOOL)cacheExpiredWithDate:(NSDate *)date {
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
//    return interval >  2 * 60 * 60;
//}

@end
