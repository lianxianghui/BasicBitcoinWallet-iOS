//
//  LXHWalletDataManager.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/19.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHWalletDataManager : NSObject

+ (LXHWalletDataManager *)sharedInstance;

@property (nonatomic) LXHWallet *wallet;

- (BOOL)generateNewWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                            mnemonicPassphrase:(NSString *)mnemonicPassphrase;

- (BOOL)restoreExistWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                        mnemonicPassphrase:(NSString *)mnemonicPassphrase
                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
