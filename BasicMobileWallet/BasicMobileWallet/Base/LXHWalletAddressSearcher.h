//
//  LXHWalletAddressSearcher.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletAddressSearcher : NSObject

@property (nonatomic) NSMutableArray *allTransactions;
- (void)search;
@end

NS_ASSUME_NONNULL_END
