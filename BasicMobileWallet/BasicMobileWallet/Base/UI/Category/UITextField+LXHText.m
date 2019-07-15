//
//  UITextField+LXHText.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UITextField+LXHText.h"

@implementation UITextField (LXHText)
- (void)updateAttributedPlaceholderString:(NSString *)placeholderString {
    NSMutableAttributedString *attributedString = [self.attributedPlaceholder mutableCopy];
    [attributedString.mutableString setString:placeholderString];
    self.attributedPlaceholder = attributedString;
}
@end
