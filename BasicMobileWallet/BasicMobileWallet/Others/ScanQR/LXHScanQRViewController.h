// LXHScanQRViewController.h
// BasicWallet
//
//  Created by lianxianghui on 19-12-17
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^LXHScanQRViewDetectionBlock)(NSString* message);
@interface LXHScanQRViewController : UIViewController

- (instancetype)initWithDetectionBlock:(LXHScanQRViewDetectionBlock)detectionBlock;
@end
