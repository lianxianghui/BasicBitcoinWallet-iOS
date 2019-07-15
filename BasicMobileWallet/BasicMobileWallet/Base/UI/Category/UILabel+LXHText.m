//
//  UILabel+LXHText.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/7/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UILabel+LXHText.h"

@implementation UILabel (LXHText)

- (void)updateAttributedTextString:(NSString *)textString {
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString.mutableString setString:textString];
    self.attributedText = attributedString;
}

@end
