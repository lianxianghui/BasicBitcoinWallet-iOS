//
//  LXHGenerateWalletViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2020/1/14.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHGenerateWalletViewModel : NSObject
@property (nonatomic) NSArray *mnemonicCodeWords;
@property (nonatomic) NSString *mnemonicPassphrase;

- (instancetype)initWithMnemonicCodeWords:(NSArray *)mnemonicCodeWords
                  mnemonicPassphrase:(NSString *)mnemonicPassphrase;
- (NSDictionary *)clickMainnetNavigationInfo;
- (NSDictionary *)clickTestnetButtonNavigationInfo;
@end

@interface LXHGenerateNewWalletViewModel : LXHGenerateWalletViewModel

@end

@interface LXHRestoreExistWalletViewModel : LXHGenerateWalletViewModel

@end


NS_ASSUME_NONNULL_END
