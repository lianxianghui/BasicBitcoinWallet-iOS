// LXHSelectMnemonicWordLengthViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LXHSelectMnemonicWordLengthViewControllerType) {
    LXHSelectMnemonicWordLengthViewControllerTypeForCreatingNewWallet,
    LXHSelectMnemonicWordLengthViewControllerTypeForRestoringExistingWallet,
};

@interface LXHSelectMnemonicWordLengthViewController : UIViewController
@property (nonatomic) LXHSelectMnemonicWordLengthViewControllerType type;
@end
