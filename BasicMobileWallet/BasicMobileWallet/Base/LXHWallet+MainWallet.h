//
//  LXHWallet+MainWallet.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/22.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWallet (MainWallet)

/**
 * 主钱包实例
 */
+ (LXHWallet *)mainWallet;
@end

NS_ASSUME_NONNULL_END
