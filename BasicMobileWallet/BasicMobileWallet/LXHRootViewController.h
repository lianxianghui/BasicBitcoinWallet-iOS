//
//  ViewController.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/12.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHRootViewController : UINavigationController

@property (nonatomic) BOOL showValidatePINViewControllerIfNeeded;//默认YES
+ (void)reset;
@end

