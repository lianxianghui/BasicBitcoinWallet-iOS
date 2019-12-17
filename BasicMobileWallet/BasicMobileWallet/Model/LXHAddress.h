//
//  LXHAddress.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LXHLocalAddressType) {
    LXHLocalAddressTypeReceiving = 0,
    LXHLocalAddressTypeChange = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddress : NSObject <NSSecureCoding>
@property (nonatomic) NSString *base58String;

@property (nonatomic) BOOL isLocalAddress;
@property (nonatomic) NSString *localAddressPath;
@property (nonatomic) LXHLocalAddressType localAddressType;
@property (nonatomic) BOOL localAddressUsed;

@end

NS_ASSUME_NONNULL_END
