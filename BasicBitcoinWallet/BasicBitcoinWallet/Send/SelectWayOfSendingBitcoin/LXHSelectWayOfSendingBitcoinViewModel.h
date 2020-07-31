//
//  LXHSelectWayOfSendingBitcoinViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSelectWayOfSendingBitcoinViewModel : NSObject

- (id)buildTransactionViewModelForFixedOutput;
- (id)buildTransactionViewModelForFixedInput;
@end

NS_ASSUME_NONNULL_END
