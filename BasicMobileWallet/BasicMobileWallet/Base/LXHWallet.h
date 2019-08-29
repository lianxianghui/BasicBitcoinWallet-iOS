//
//  LXHWallet.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/17.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHAccount.h"
#import "LXHGlobalHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LXHWalletGenerationType) {
    LXHWalletGenerationTypeGeneratingNew,
    LXHWalletGenerationTypeRestoringExist,
};

/**
 * 按着BIP44标准管理地址钱包对象 
 * 目前只支持一个账号，也就是按着”m/44'/coin_type'/account'/change/address_index“路径 account为0的账户
 * BIP44标准请参考 https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki
 
 * 职责也包括管理钱包数据
 * 包括：
 * 1.生成必要的钱包数据并保存到keychain
 * 2.通过扫描区块链网络中的交易找到钱包有哪些地址已使用过，这样就可以按着BIP44来确定下一个要使用的地址
 * 3.提供一个根据当前数据生成LXHWallet实例的方法
 */
@interface LXHWallet : NSObject
@property (nonatomic, readonly) LXHAccount *mainAccount;
- (instancetype)initWithMainAccount:(LXHAccount *)mainAccount;




+ (BOOL)generateNewWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                           netType:(LXHBitcoinNetworkType)netType;

+ (void)restoreExistWalletDataWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                                 mnemonicPassphrase:(NSString *)mnemonicPassphrase
                                            netType:(LXHBitcoinNetworkType)netType
                                       successBlock:(void (^)(NSDictionary *resultDic))successBlock 
                                       failureBlock:(void (^)(NSDictionary *resultDic))failureBlock;

+ (BOOL)clearData;
+ (BOOL)walletDataGenerated;

+ (LXHWallet *)sharedInstance;
+ (LXHAccount *)mainAccount;

+ (NSArray *)mnemonicCodeWordsWithErrorPointer:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
