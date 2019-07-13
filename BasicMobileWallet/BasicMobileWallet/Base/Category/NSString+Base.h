//
//  NSString+Base.h
//  
//
//  Created by lianxianghui on 17/7/7.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLStringADD(A, B) [NSString stringWithFormat:@"%@.%@", (A), (B)]

@interface NSString (Base)
- (NSString *)stringByTrimmingWhiteSpace;
- (NSString *)stringByEliminateWhiteSpace;
- (NSString *)firstLetterCapitalized;
- (NSString *)firstLetterLowercase;
- (NSString *)md5;
@end
