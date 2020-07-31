// LXHAddressListViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>
#import "LXHAddress.h"

typedef void(^addressSelectedCallback)(LXHAddress *localAddress);

@interface LXHAddressListViewController : UIViewController

- (instancetype)initWithViewModel:(id)viewModel;

@property (nonatomic, copy) addressSelectedCallback addressSelectedCallback;
@end
