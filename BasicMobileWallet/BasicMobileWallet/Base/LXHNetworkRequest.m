//
//  NetworkRequest.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHNetworkRequest.h"
#import "AFNetworking.h"

@implementation LXHNetworkRequest

+ (id)postWithUrlString:(NSString *)url 
             parameters:(NSDictionary *)parameters 
        successCallback:(void (^)(NSDictionary *resultDic))successCallback 
        failureCallback:(void (^)(NSDictionary *resultDic))failureCallback {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    return [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureCallback(@{@"error":error});
    }];
}

@end
