//
//  LXHInputDetailViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionInput;
@interface LXHInputDetailViewModel : NSObject
- (instancetype)initWithInput:(LXHTransactionInput *)input;

@property (nonatomic, readonly) NSMutableArray *dataForCells;
@end

NS_ASSUME_NONNULL_END
