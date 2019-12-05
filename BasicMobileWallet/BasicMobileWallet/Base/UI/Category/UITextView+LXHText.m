//
//  UITextView+LXHText.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UITextView+LXHText.h"

@implementation UITextView (LXHText)

- (void)updateAttributedTextString:(NSString *)textString {
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString.mutableString setString:textString];
    self.attributedText = attributedString;
}

@end
