//
//  LXHSelectInputViewModelForFixedOutputs.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/29.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHSelectInputViewModel.h"
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

/**
 覆盖了父类的 infoText 方法
 */
@interface LXHSelectInputViewModelForFixedOutput : LXHSelectInputViewModel

@property (nonatomic) LXHBTCAmount fixedOutputValueSum;

@end

NS_ASSUME_NONNULL_END
