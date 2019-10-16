//
//  LXHBitcoinWebApi.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LXHBitcoinWebApi

- (NSArray<LXHTransaction *> *)transactionsWithAddress:(NSArray<NSString *> *)address;

@end

NS_ASSUME_NONNULL_END
