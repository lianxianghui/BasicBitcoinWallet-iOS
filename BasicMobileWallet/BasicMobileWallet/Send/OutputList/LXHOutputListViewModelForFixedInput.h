//
//  LXHOutputListViewModelForFixedInput.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/4.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHOutputListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHOutputListViewModelForFixedInput : LXHOutputListViewModel

@property (nonatomic) NSArray *inputs;
@property (nonatomic) NSUInteger feeRateInSat;

@end

NS_ASSUME_NONNULL_END
