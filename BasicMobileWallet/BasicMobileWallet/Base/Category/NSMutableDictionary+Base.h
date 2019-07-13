//
//  NSMutableDictionary+Base.h
//  
//
//  Created by lianxianghui on 17/9/3.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Base)

/**
 保证按着keyPath能加入进去，如果keyPath里有不存在的dic，也会先生成一个空的，然后把值放进去
 */
- (void)ensureSetValue:(nullable id)value forKeyPath:(nonnull NSString *)keyPath;

/**
 如果key为null则什么都不做
 */
- (void)setValue:(nullable id)value forNullableKey:(nullable NSString *)key;
@end
