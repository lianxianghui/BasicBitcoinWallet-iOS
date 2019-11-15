//
//  LXHTransactionInput.h
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionInputOutputCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHTransactionInput : LXHTransactionInputOutputCommon <NSSecureCoding>
@property (nonatomic) NSString *unlockingScript;//scriptSig
@property (nonatomic) NSArray *witness;
@property (nonatomic) LXHLockingScriptType scriptType;
@end

NS_ASSUME_NONNULL_END
