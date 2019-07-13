//
//  NSArray+Base.m
//  
//
//  Created by lianxianghui on 17/10/8.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSArray+Base.h"

@implementation NSArray (Base)

- (NSArray *)intersectionWithArray:(NSArray *)array {
    NSMutableSet *intersection = [NSMutableSet setWithArray:self];
    [intersection intersectSet:[NSSet setWithArray:array]];
    NSArray *ret = [intersection allObjects];
    return ret;
}

- (NSMutableArray *)duplicatedElementsRemovedArray {
    NSMutableSet *set = [NSMutableSet setWithArray:self];
    return [set allObjects].mutableCopy;
}
@end
