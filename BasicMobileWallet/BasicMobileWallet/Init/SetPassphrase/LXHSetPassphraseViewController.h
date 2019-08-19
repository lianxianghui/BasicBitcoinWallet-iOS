// LXHSetPassphraseViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>
#import "LXHWallet+CreateNewOrRestoreExistWallet.h"


@interface LXHSetPassphraseViewController : UIViewController
@property (nonatomic) LXHWalletCreationType type;
@property (nonatomic) NSArray *words;
@end
