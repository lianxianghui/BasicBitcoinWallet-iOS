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

typedef NS_ENUM(NSUInteger, LXHWalletGenerationType) {
    LXHWalletGenerationTypeGeneratingNew,
    LXHWalletGenerationTypeRestoringExist,
};

@interface LXHWalletDataManager : NSObject

+ (LXHWalletDataManager *)sharedInstance;

@property (nonatomic) LXHWallet *wallet;

- (BOOL)generateNewWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                                  netType:(LXHBitcoinNetworkType)netType;

- (void)restoreExistWalletAndSaveDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                        mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                                   netType:(LXHBitcoinNetworkType)netType
                                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;
@end

NS_ASSUME_NONNULL_END
