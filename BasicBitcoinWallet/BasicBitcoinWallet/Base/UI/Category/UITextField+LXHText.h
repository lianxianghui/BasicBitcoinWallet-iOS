//
//  UITextField+LXHText.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/7/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LXHText)
- (void)updateAttributedPlaceholderString:(NSString *)placeholderString;
- (void)updateAttributedTextString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
