//
//  LXHWallet+CreateNewOrRestoreExistWallet.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWallet (CreateNewOrRestoreExistWallet)
- (void)createNewWalletInit;
- (void)restoreExistWalletInitWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                  failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
