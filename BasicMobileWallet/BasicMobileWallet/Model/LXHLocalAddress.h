//
//  LXHLocalAddress.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LXHAddressType) {
    LXHAddressTypeReceiving = 0,
    LXHAddressTypeChange = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface LXHLocalAddress : NSObject
@property (nonatomic) NSString *addressString;
@property (nonatomic) NSString *addressPath;
@property (nonatomic) LXHAddressType type;
@property (nonatomic) BOOL used;
@end

NS_ASSUME_NONNULL_END
