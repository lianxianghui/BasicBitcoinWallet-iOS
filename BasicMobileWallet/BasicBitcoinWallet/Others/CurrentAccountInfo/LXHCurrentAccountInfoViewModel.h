//
//  LXHCurrentAccountInfoViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LXHQRCodeAndTextViewModel;
@interface LXHCurrentAccountInfoViewModel : NSObject

- (NSString *)netTypeText;
- (NSString *)walletTypeText;
- (LXHQRCodeAndTextViewModel *)qrCodeAndTextViewModel;
- (void)searchAndUpdateCurrentAddressIndexWithSuccessBlock:(void (^)(NSString *prompt))successBlock
                                              failureBlock:(void (^)(NSString *errorPrompt))failureBlock;
@end

NS_ASSUME_NONNULL_END
