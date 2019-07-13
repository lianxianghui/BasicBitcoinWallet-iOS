//
//  NSString+Base.m
//  
//
//  Created by lianxianghui on 17/7/7.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSString+Base.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Base)

- (NSString *)stringByTrimmingWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByEliminateWhiteSpace {
    NSArray* parts = [self componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* ret = [parts componentsJoinedByString:@""];
    return ret;
}
    
- (NSString *)firstLetterCapitalized {
    if (self.length > 0) {
        NSString *firstLetter = [self substringToIndex:1];
        return [NSString stringWithFormat:@"%@%@", firstLetter.capitalizedString, [self substringFromIndex:1]];
    } else {
        return self;
    }
}

- (NSString *)firstLetterLowercase {
    NSString *firstLetter = [self substringToIndex:1];
    return [NSString stringWithFormat:@"%@%@", firstLetter.lowercaseString, [self substringFromIndex:1]];
}

- (NSString *)md5 {
    const char * pointer = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    return string;
}


@end
