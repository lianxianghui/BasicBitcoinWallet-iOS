//
//  NSDictionary+Enumerate.h
//  
//
//  Created by lianxianghui on 17/7/3.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Enumerate)

/**
 先根的遍历 rootFirst
 */
- (void)enumerateTreeWithSubTreeArrayKey:(NSString *)subTreeArrayKey block:(void (^)(id tree, BOOL *stop))block;
- (void)enumerateTreeWithSubTreeArrayKey:(NSString *)subTreeArrayKey parentTree:(NSDictionary *)parentTree block:(void (^)(id tree, id parentTree, BOOL *stop))block;
@end
