//
//  NSDictionary+Enumerate.m
//  
//
//  Created by lianxianghui on 17/7/3.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSDictionary+Enumerate.h"

@implementation NSDictionary (Enumerate)

- (void)enumerateTreeWithSubTreeArrayKey:(NSString *)subTreeArrayKey block:(void (^)(id tree, BOOL *stop))block {
    BOOL stop = NO;
    block(self, &stop);
    if (stop) {
        return;
    } else {
        if (!subTreeArrayKey)
            return;
        NSArray *subTreeArray = self[subTreeArrayKey];
        for (NSDictionary *subTree in subTreeArray)
            [subTree enumerateTreeWithSubTreeArrayKey:subTreeArrayKey block:block];
    }
}

- (void)enumerateTreeWithSubTreeArrayKey:(NSString *)subTreeArrayKey parentTree:(NSDictionary *)parentTree block:(void (^)(id tree, id parentTree, BOOL *stop))block {
    BOOL stop = NO;
    block(self, parentTree, &stop);
    if (stop) {
        return;
    } else {
        if (!subTreeArrayKey)
            return;
        NSArray *subTreeArray = self[subTreeArrayKey];
        for (NSDictionary *subTree in subTreeArray)
            [subTree enumerateTreeWithSubTreeArrayKey:subTreeArrayKey parentTree:self block:block];
    }
}


@end
