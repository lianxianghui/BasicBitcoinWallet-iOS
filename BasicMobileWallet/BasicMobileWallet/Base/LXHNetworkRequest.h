//
//  NetworkRequest.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHNetworkRequest : NSObject

+ (id)postWithUrlString:(NSString *)url 
             parameters:(NSDictionary *)parameters 
        successCallback:(void (^)(NSDictionary *resultDic))successCallback 
        failureCallback:(void (^)(NSDictionary *resultDic))failureCallback;
@end

NS_ASSUME_NONNULL_END
