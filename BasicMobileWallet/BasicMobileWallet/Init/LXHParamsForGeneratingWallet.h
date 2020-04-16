//
//  LXHParamsForGeneratingWallet.h
//  BasicMobileWallet
//
//  Created by lian on 2020/3/13.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHBitcoinNetwork.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LXHWalletGenerationType) {
    LXHWalletGenerationTypeUndefined,
    LXHWalletGenerationTypeForCreatingNewWallet,
    LXHWalletGenerationTypeForRestoringExistingWallet,
};

@interface LXHParamsForGeneratingWallet : NSObject

@property (nonatomic) LXHWalletGenerationType type;
@property (nonatomic) NSArray *mnemonicWords;
@property (nonatomic) NSString *MnemonicPassphrase;
@property (nonatomic) LXHBitcoinNetworkType networkType;
@end

NS_ASSUME_NONNULL_END
