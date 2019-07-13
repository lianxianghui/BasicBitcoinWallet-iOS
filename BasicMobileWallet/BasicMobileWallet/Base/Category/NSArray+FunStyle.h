//
//  NSArray+FunStyle.h
//  
//
//  Created by lianxianghui on 17/9/26.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FunStyle)

- (NSMutableArray *)mapWithBlock:(id (^)(id element))block;
- (id)findWithBlock:(BOOL (^)(id element))block;
- (NSArray *)filterWithBlock:(BOOL (^)(id element))block;
@end
