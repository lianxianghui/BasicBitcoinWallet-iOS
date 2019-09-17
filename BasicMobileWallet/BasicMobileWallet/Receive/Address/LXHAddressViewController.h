// LXHAddressViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-08-22
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>
#import "LXHAddressView.h"

@interface LXHAddressViewController : UIViewController

@property (nonatomic) LXHAddressView *contentView;

- (instancetype)initWithData:(NSDictionary *)data;

@end
