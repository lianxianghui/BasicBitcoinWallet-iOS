//
//  LXHTransactionInfoViewViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionOutput;
@interface LXHTransactionInfoViewViewModel : NSObject

- (instancetype)initWithInputs:(NSArray<LXHTransactionOutput *> *)inputs outputs:(NSArray<LXHTransactionOutput *> *)outputs;


- (NSString *)infoDescription;
- (void)pushSignedTransaction;
@end

NS_ASSUME_NONNULL_END
