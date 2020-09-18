//
//  LXHBitcoinWebApiSmartbit.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinWebApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHBitcoinWebApiSmartbit : NSObject <LXHBitcoinWebApi>
- (instancetype)initWithEndPoint:(NSString *)endPoint;
@end

NS_ASSUME_NONNULL_END
