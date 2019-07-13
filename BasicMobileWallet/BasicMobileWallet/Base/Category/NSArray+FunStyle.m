//
//  NSArray+FunStyle.m
//  
//
//  Created by lianxianghui on 17/9/26.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSArray+FunStyle.h"

@implementation NSArray (FunStyle)

- (NSMutableArray *)mapWithBlock:(id (^)(id element))block {
    NSMutableArray *ret = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id mapped = block(obj);
        if (mapped)
            [ret addObject:mapped];
    }];
    return ret;
}


- (id)findWithBlock:(BOOL (^)(id element))block {
    __block id ret = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            ret = obj;
            *stop = YES;
        }
    }];
    return ret;
}

- (NSArray *)filterWithBlock:(BOOL (^)(id element))block {
    NSMutableArray *ret = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [ret addObject:obj];
        }
    }];
    return ret;
}

@end
