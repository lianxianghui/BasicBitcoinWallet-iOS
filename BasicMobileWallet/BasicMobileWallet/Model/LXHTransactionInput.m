//
//  LXHTransactionInput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/10/18.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionInput.h"
#import "LXHGlobalHeader.h"

@implementation LXHTransactionInput

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    LXHDecodeObjectOfStringClassStament(unlockingScript);
    LXHDecodeIntegerTypeStament(scriptType);
//    LXHDecodeObjectOfArrayClassStament(witness);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    LXHEncodeObjectStament(unlockingScript);
    LXHEncodeIntegerStament(scriptType);
//    LXHEncodeObjectStament(witness);
}

@end
