// LXHAddOutputViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

#import "LXHTransactionOutput.h"

typedef void(^addOrEditOutputCallback)(void);

@interface LXHAddOutputViewController : UIViewController
- (instancetype)initWithViewModel:(id)viewModel addOrEditOutputCallback:(addOrEditOutputCallback)addOutputCallback;
@end
