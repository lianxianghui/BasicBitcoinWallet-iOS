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

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    if (![object isMemberOfClass:[LXHAddress class]])
        return NO;
    LXHAddress *address = (LXHAddress *)object;
    return [self.base58String isEqualToString:address.base58String];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _base58String];
}

+ (LXHAddress *)addressWithBase58String:(NSString *)base58String {
    LXHAddress *ret = [LXHAddress new];
    ret.base58String = base58String;
    return ret;
}

@end
