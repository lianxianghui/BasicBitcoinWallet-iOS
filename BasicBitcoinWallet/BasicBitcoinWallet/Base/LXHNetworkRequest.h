//
//  NetworkRequest.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHNetworkRequest : NSObject

+ (id)POSTWithUrlString:(NSString *)url 
             parameters:(nullable NSDictionary *)parameters
        successCallback:(void (^)(id _Nullable result))successCallback
        failureCallback:(void (^)(NSDictionary *resultDic))failureCallback;

+ (id)GETWithUrlString:(NSString *)url
            parameters:(nullable NSDictionary *)parameters
       successCallback:(void (^)(id _Nullable result))successCallback
       failureCallback:(void (^)(NSDictionary *resultDic))failureCallback;
@end

NS_ASSUME_NONNULL_END
