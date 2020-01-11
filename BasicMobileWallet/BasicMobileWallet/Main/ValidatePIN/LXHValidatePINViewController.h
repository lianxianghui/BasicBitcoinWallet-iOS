// LXHValidatePINViewController.h
// BasicWallet
//
//  Created by lianxianghui on 20-01-11
//  Copyright © 2020年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^LXHValidatePINSuccessBlock)(void);

@interface LXHValidatePINViewController : UIViewController

- (instancetype)initWithValidatePINSuccessBlock:(LXHValidatePINSuccessBlock)successBlock;
@end
