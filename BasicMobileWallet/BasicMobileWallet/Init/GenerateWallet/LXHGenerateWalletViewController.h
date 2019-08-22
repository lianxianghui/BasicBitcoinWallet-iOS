// LXHGenerateWalletViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-08-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>
#import "LXHWalletDataManager.h"

@interface LXHGenerateWalletViewController : UIViewController

- (instancetype)initWithCreationType:(LXHWalletGenerationType)creationType
                   mnemonicCodeWords:(NSArray *)mnemonicCodeWords
                  mnemonicPassphrase:(NSString *)mnemonicPassphrase;
@end