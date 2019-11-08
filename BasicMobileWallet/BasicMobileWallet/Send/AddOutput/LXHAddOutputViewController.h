// LXHAddOutputViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

#import "LXHTransactionOutput.h"

typedef NS_ENUM(NSUInteger, LXHAddOutputViewControllerType) {
    LXHAddOutputViewControllerTypeAdd,
    LXHAddOutputViewControllerTypeEdit,
};

typedef void(^addOutputCallback)(LXHAddOutputViewControllerType type, LXHTransactionOutput *output);

@interface LXHAddOutputViewController : UIViewController

@end
