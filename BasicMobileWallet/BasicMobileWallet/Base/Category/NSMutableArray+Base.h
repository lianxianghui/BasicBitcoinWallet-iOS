//
//  NSMutableArray+Base.h
//  
//
//  Created by lianxianghui on 17/9/30.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Base)

- (void)insertObjectIfNotNil:(id)object atIndex:(NSUInteger)index;
- (void)addObjectIfNotNil:(id)object;
- (void)removeObjectIfNotNil:(id)object;
- (void)removeObjectIfIndexExist:(NSUInteger)index;
- (void)addObjectsIfNotNil:(NSArray *)array;
- (void)removeObjectsIfNotNil:(NSArray *)array;
- (void)addObjectIfNotContains:(id)object;
- (void)addObjectsIfNotContains:(NSArray *)objects;
@end
