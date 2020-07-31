//
//  NSMutableArray+Base.m
//  
//
//  Created by lianxianghui on 17/9/30.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSMutableArray+Base.h"

@implementation NSMutableArray (Base)

- (void)insertObjectIfNotNil:(id)object atIndex:(NSUInteger)index {
    if (object)
        [self insertObject:object atIndex:index];
}

- (void)addObjectIfNotNil:(id)object {
    if (object)
        [self addObject:object];
}

- (void)removeObjectIfNotNil:(id)object {
    if (object)
        [self removeObject:object];
}

- (void)removeObjectIfIndexExist:(NSUInteger)index {
    if (index < self.count)
        [self removeObjectAtIndex:index];
}

- (void)addObjectsIfNotNil:(NSArray *)array {
    if (array)
        [self addObjectsFromArray:array];
}
- (void)removeObjectsIfNotNil:(NSArray *)array {
    if (array)
        [self removeObjectsInArray:array];
}

- (void)addObjectIfNotContains:(id)object {
    if (![self containsObject:object])
        [self addObjectIfNotNil:object];
}

- (void)addObjectsIfNotContains:(NSArray *)objects {
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addObjectIfNotContains:obj];
    }];
}

@end
