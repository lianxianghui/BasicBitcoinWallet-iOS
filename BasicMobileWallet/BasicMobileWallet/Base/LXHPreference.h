//
//  LXHPreference.h
//
//  Created by lianxianghui on 17/11/24.
//  Copyright © 2017年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LXHBitcoinNetworkType) {
    LXHBitcoinNetworkTypeMainnet,
    LXHBitcoinNetworkTypeTestnet,
};

#define kLXHPreferenceBitcoinNetworkType @"kLXHPreferenceBitcoinNetworkType"

@interface LXHPreference : NSObject

@property (nonatomic, readonly) NSUserDefaults *mainPreference;

+ (LXHPreference *)sharedInstance;

- (void)saveMainPreferenceWithKey:(NSString *)key value:(id)value;

@end
