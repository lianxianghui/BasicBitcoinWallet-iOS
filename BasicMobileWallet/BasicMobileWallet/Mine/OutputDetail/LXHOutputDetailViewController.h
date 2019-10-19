// LXHOutputDetailViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-19
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

@class LXHTransactionOutput;
@interface LXHOutputDetailViewController : UIViewController
- (instancetype)initWithOutput:(LXHTransactionOutput *)output;
@end
