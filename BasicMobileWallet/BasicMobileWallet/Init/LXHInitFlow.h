//
//  LXHInitFlow.h
//  BasicMobileWallet
//
//  Created by lian on 2020/4/17.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHInitFlow : NSObject

@property (nonatomic) NSUInteger mnemonicWordsLength;
@property (nonatomic) NSArray *mnemonicWords;
@property (nonatomic) NSString *mnemonicPassphrase;
//@property (nonatomic) LXHBitcoinNetworkType networkType;//目前未使用

+ (LXHInitFlow *)currentFlow;
+ (void)startCreatingNewWalletFlow;
+ (void)startRestoringExistWalletFlow;
+ (void)startResettingPINFlow;
+ (void)endFlow;

//SelectMnemonicWordLengthView
- (NSDictionary *)selectMnemonicWordLengthViewClickRowNavigationInfo;
//CheckWalletMnemonicWordsView
- (NSDictionary *)checkWalletMnemonicWordsClickNextButtonNavigationInfo;
//SetPassphraseView
- (NSDictionary *)setPassphraseViewClickOKButtonNavigationInfoWithWithPassphrase:(NSString *)passphrase;
//GenerateWalletView
- (NSDictionary *)generateWalletViewClickMainnetNavigationInfo;
- (NSDictionary *)generateWalletViewClickTestnetButtonNavigationInfo;
@end

NS_ASSUME_NONNULL_END
