//
//  NSString+Base.h
//  
//
//  Created by lianxianghui on 17/7/7.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base)
- (NSString *)stringByTrimmingWhiteSpace;
- (NSString *)stringByEliminatingWhiteSpace;
- (NSString *)firstLetterCapitalized;
- (NSString *)firstLetterLowercase;
- (NSString *)md5;
- (NSDecimalNumber *)decimalValue;
- (BOOL)isInteger;
- (BOOL)isLongLong;
@end
