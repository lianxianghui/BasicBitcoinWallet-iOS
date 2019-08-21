//
//  VLPreference.m
//
//  Created by lianxianghui on 17/11/24.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import "LXHPreference.h"

@interface LXHPreference ()
@property (nonatomic, readwrite) NSUserDefaults *mainPreference;
@end

@implementation LXHPreference

+ (LXHPreference *)sharedInstance { 
    static LXHPreference *sharedInstance = nil;  
    static dispatch_once_t once;  
    dispatch_once(&once, ^{ 
        sharedInstance = [[self alloc] init];  
    });  
    return sharedInstance; 
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TODO keychain or userDefaults ?
        _mainPreference = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveMainPreferenceWithKey:(NSString *)key value:(id)value {
    if (key) {
        [self.mainPreference setValue:value forKey:key];
        [self.mainPreference synchronize];
    }
}

@end
