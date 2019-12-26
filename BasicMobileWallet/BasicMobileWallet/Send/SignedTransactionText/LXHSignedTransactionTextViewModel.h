//
//  LXHSignedTransactionTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSignedTransactionTextViewModel : NSObject

- (instancetype)initWithData:(NSDictionary *)transactionDictionary;

- (NSString *)text;
- (id)qrCodeAndTextViewModel;
- (void)pushSignedTransactionWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                 failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
