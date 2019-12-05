//
//  LXHQRCodeViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHQRCodeViewModel : NSObject

- (instancetype)initWithString:(NSString *)string;

- (UIImage *)image;
@end

NS_ASSUME_NONNULL_END
