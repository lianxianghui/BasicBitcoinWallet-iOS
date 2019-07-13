//
//  NSArray+Base.h
//  
//
//  Created by lianxianghui on 17/10/8.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Base)

- (NSArray *)intersectionWithArray:(NSArray *)array;

/**
 返回去重后的数组

 @return  去重后的数组
 */
- (NSMutableArray *)duplicatedElementsRemovedArray;
@end
