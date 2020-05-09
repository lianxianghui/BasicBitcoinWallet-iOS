//
//  LXHBitcoinWebApiSmartbit.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinWebApi.h"
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHBitcoinWebApiSmartbit : NSObject <LXHBitcoinWebApi>
- (instancetype)initWithType:(LXHBitcoinNetworkType)type;
@end

NS_ASSUME_NONNULL_END
