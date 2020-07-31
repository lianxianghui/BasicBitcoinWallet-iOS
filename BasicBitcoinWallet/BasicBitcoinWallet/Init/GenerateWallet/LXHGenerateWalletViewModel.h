//
//  LXHGenerateWalletViewModel.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHGenerateWalletViewModel : NSObject

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                  mnemonicPassphrase:(NSString *)mnemonicPassphrase;
- (NSDictionary *)clickMainnetNavigationInfo;
- (NSDictionary *)clickTestnetButtonNavigationInfo;
@end


NS_ASSUME_NONNULL_END
