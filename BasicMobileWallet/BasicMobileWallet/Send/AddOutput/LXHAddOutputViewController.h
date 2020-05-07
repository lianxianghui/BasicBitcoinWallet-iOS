// LXHAddOutputViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

#import "LXHTransactionOutput.h"

typedef void(^addOutputCallback)(void);
typedef void(^editOutputCallback)(BOOL needDelete);


@interface LXHAddOutputViewController : UIViewController
- (instancetype)initWithViewModel:(id)viewModel addOutputCallback:(addOutputCallback)addOutputCallback;
- (instancetype)initWithViewModel:(id)viewModel editOutputCallback:(editOutputCallback)addOutputCallback;
@end
