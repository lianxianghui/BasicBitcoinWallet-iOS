// LXHSetPassphraseViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-07-13
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LXHSetPassphraseViewControllerType) {
    LXHSetPassphraseViewControllerForCreating,
    LXHSetPassphraseViewControllerForRestoring,
};

@interface LXHSetPassphraseViewController : UIViewController
@property (nonatomic) LXHSetPassphraseViewControllerType type;
@property (nonatomic) NSArray *words;
@end
