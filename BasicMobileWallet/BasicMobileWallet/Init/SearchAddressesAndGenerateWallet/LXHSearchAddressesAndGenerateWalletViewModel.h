//
//  LXHSearchAddressesAndGenerateWalletViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/1/15.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHSearchAddressesAndGenerateWalletViewModel : NSObject

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                              networkType:(LXHBitcoinNetworkType)networkType;

- (void)searchUsedAddressesAndGenerateExistWalletDataWithSuccessBlock:(void (^)(NSDictionary *resultDic))successBlock
                                                         failureBlock:(void (^)(NSString *errorPrompt))failureBlock;
- (BOOL)generateExistWalletData;
@end

NS_ASSUME_NONNULL_END
