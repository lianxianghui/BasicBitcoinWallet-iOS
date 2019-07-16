// LXHWalletMnemonicWordsViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LXHWalletMnemonicWordsViewControllerType) {
    LXHWalletMnemonicWordsViewControllerTypeForCreatingNewWallet,
    LXHWalletMnemonicWordsViewControllerTypeForRestoringExistingWallet,
};

@interface LXHWalletMnemonicWordsViewController : UIViewController
@property (nonatomic) LXHWalletMnemonicWordsViewControllerType type;
@property NSArray *words;
@end
