//
//  UIButton+LXHText.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LXHText)

- (void)updateAttributedTitleString:(NSString *)title forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
