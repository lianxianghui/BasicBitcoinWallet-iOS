//
//  LXHTransactionInfoViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHTransactionOutput;
@interface LXHTransactionInfoViewModel : NSObject

- (instancetype)initWithInputs:(NSArray<LXHTransactionOutput *> *)inputs outputs:(NSArray<LXHTransactionOutput *> *)outputs;


- (NSString *)infoDescription;
- (BOOL)signatureButtonsEnabled;
- (void)pushSignedTransactionWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                 failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

- (id)unsignedTransactionTextViewModel;
- (id)signedTransactionTextViewModel;
@end

NS_ASSUME_NONNULL_END
