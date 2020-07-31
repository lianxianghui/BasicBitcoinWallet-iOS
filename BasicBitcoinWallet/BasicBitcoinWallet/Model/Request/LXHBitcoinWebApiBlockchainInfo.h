//
//  LXHBitcoinWebApiBlockchainInfo.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/7/25.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinWebApi.h"
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

//testnet不能用pushTransactionWithHex，blockChainInfo的push接口不支持testnet
@interface LXHBitcoinWebApiBlockchainInfo : NSObject <LXHBitcoinWebApi>
- (instancetype)initWithType:(LXHBitcoinNetworkType)type;
@end

NS_ASSUME_NONNULL_END
