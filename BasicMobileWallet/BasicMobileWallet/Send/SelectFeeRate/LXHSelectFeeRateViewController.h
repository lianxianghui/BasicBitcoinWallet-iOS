// LXHSelectFeeRateViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^dataChangedCallback)(void);

@interface LXHSelectFeeRateViewController : UIViewController

- (instancetype)initWithData:(NSMutableDictionary *)data //key selectedFeeRate
         dataChangedCallback:(dataChangedCallback)dataChangedCallback;
@end
