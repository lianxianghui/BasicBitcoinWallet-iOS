//
//  LXHBitcoinWebApiMyElectrs.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/9/15.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinWebApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHBitcoinWebApiMyElectrs : NSObject <LXHBitcoinWebApi>
- (instancetype)initWithEndPoint:(NSString *)endPoint;
@end

NS_ASSUME_NONNULL_END
