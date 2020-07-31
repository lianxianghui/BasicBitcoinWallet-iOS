//
//  NSJSONSerialization+VLBase.m
//  
//
//  Created by lianxianghui on 17/12/1.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "NSJSONSerialization+VLBase.h"

@implementation NSJSONSerialization (VLBase)

+ (NSString *)jsonStringWithObject:(id)object {
    if (!object)
        return nil;
    if ([NSJSONSerialization isValidJSONObject:object]) {  
        NSError *error;  
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error]; 
        if (error == NULL) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        } else 
            return nil;
    } 
    return nil;
}

+ (id)objectWithJsonData:(NSData *)data {
    if (!data)
        return nil;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil)
        return jsonObject;
    else
        return nil;
}

+ (id)objectWithJsonString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self objectWithJsonData:data];
}


@end
