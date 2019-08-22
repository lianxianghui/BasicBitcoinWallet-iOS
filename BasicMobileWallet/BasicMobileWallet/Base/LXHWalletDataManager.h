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

/**
 * 管理钱包数据。
 * 包括：
 * 1.生成必要的钱包数据并保存到keychain
 * 2.通过扫描区块链网络中的交易找到钱包有哪些地址已使用过，这样就可以按着BIP44来确定下一个要使用的地址
 * 3.提供一个根据当前数据生成LXHWallet实例的方法
 */

@interface LXHWalletDataManager : NSObject

+ (LXHWalletDataManager *)sharedInstance;

- (BOOL)generateNewWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                       mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                                  netType:(LXHBitcoinNetworkType)netType;

- (void)restoreExistWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                        mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                                   netType:(LXHBitcoinNetworkType)netType
                                              successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                              failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

- (LXHWallet *)createWallet;
@end

NS_ASSUME_NONNULL_END
