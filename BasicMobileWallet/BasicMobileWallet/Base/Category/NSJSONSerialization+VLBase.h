//
//  NSJSONSerialization+VLBase.h
//  
//
//  Created by lianxianghui on 17/12/1.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (VLBase)

+ (NSString *)jsonStringWithObject:(id)object;
+ (id)objectWithJsonData:(NSData *)data;
+ (id)objectWithJsonString:(NSString *)string;
@end
