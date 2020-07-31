//
//  UIButton+LXHText.m
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/7/15.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "UIButton+LXHText.h"

@implementation UIButton (LXHText)

- (void)updateAttributedTitleString:(NSString *)titleString forState:(UIControlState)state {
    NSMutableAttributedString *attributedString = [[self attributedTitleForState:state] mutableCopy];
    [attributedString.mutableString setString:titleString];
    [self setAttributedTitle:attributedString forState:state];
}

@end
