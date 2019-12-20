//
//  LXHOutputDetailViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/20.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionOutput;
@interface LXHOutputDetailViewModel : NSObject

- (instancetype)initWithOutput:(LXHTransactionOutput *)output;

- (NSMutableArray *)dataForCells;

- (id)transactionDetailViewModel;
@end

NS_ASSUME_NONNULL_END
