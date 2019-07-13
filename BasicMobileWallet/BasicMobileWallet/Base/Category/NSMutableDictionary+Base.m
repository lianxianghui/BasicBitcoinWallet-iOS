//
//  NSMutableDictionary+Base.m
//  
//
//  Created by lianxianghui on 17/9/3.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSMutableDictionary+Base.h"

@implementation NSMutableDictionary (Base)

- (void)ensureSetValue:(nullable id)value forKeyPath:(nonnull NSString *)keyPath {
    [self setValue:value forKeyPath:keyPath];
    id value1 = [self valueForKeyPath:keyPath];
    if (!value1) {
        NSArray *parts = [keyPath componentsSeparatedByString:@"."];
        NSMutableDictionary *currDic = self;
        for (int i = 0; i < parts.count-1; i++) {
            NSString *key = parts[i];
            id dic = [currDic valueForKey:key];
            if (dic && [dic isMemberOfClass:[self class]]) {
                currDic = dic;
            } else {
                dic = [NSMutableDictionary dictionary];
                currDic[key] = dic;
                currDic = dic;
            }
        }
        [currDic setValue:value forKey:parts[parts.count-1]];
    }
}

- (void)setValue:(nullable id)value forNullableKey:(nullable NSString *)key {
    if (key)
        [self setValue:value forKey:key];
}

@end
