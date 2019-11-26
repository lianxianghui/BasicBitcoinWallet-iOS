// LXHInputFeeViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^dataChangedCallback)(void);

@interface LXHInputFeeViewController : UIViewController
- (instancetype)initWithData:(NSMutableDictionary *)data
         dataChangedCallback:(dataChangedCallback)dataChangedCallback;
- (instancetype)initWithViewModel:(id)viewModel
              dataChangedCallback:(dataChangedCallback)dataChangedCallback;
@end
