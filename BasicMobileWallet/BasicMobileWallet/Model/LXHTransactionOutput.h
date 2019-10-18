//
//  LXHTransactionOutput.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHTransactionOutput : NSObject
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *value;
@property (nonatomic) NSString *spendTxid;
@end

NS_ASSUME_NONNULL_END
