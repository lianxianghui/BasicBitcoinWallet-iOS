//
//  LXHAddressListForSelectionViewController.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddressListViewController+ForSubclassing.h"
#import "LXHAddress.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^addressSelectedCallback)(LXHAddress *localAddress);


/**
 通过覆盖父类的几个方法实现选择某个地址并返回
 通过回调返回选择的地址数据
 */
@interface LXHAddressListForSelectionViewController : LXHAddressListViewController
- (instancetype)initWithAddressSelectedCallback:(addressSelectedCallback)addressSelectedCallback;
@end

NS_ASSUME_NONNULL_END
