//
//  LXHQRCodeAndTextViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHQRCodeAndTextViewModel : NSObject
@property (nonatomic) BOOL showText;
@property (nonatomic) BOOL showCopyButton;
@property (nonatomic) BOOL showShareButton;

- (instancetype)initWithString:(NSString *)string;

- (NSString *)text;
- (UIImage *)image;
@end

NS_ASSUME_NONNULL_END
