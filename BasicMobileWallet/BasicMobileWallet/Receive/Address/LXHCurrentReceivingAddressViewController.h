//
//  LXHCurrentReceivingAddressViewController.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/22.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddressViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 作为TabBarController的"接收"Controller, 显示当前地址二维码
 */
@interface LXHCurrentReceivingAddressViewController : LXHAddressViewController

- (void)refreshViewWithCurrentReceivingAddress;

@end

NS_ASSUME_NONNULL_END
