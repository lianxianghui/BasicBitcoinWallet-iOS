//
//  UITextField+LXHText.m
//  BasicBitcoinWallet
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

- (void)updateAttributedTextString:(NSString *)string {
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString.mutableString setString:string];
    self.attributedText = attributedString;
}
@end
