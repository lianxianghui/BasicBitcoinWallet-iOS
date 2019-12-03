//
//  LXHAddress.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddress.h"
#import "LXHGlobalHeader.h"

@implementation LXHAddress

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectOfStringClassStament(base58String);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    LXHEncodeObjectStament(base58String);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _base58String];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
