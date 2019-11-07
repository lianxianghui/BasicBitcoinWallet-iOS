//
//  LXHGlobalHeader.h
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#ifndef LXHGlobalHeader_h
#define LXHGlobalHeader_h

typedef NS_ENUM(NSUInteger, LXHBitcoinNetworkType) { //do not modify
    LXHBitcoinNetworkTypeTestnet = 1,
    LXHBitcoinNetworkTypeMainnet = 0,
};

#define LXHAESPassword @"serefddetggg" //TODO 随便写的，用你自己的代替
#define LXHCacheFileDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory ,NSUserDomainMask, YES) objectAtIndex:0]
#define LXHTranactionTimeDateFormat @"yyyy-MM-dd HH:mm:ss"

//encode decode statement macro
#define LXHDecodeObjectStament(propertyName) self.propertyName = [decoder decodeObjectForKey:@#propertyName];
#define LXHEncodeObjectStament(propertyName) [encoder encodeObject:self.propertyName forKey:@#propertyName];

#define LXHDecodeIntegerTypeStament(propertyName) self.propertyName = [[decoder decodeObjectForKey:@#propertyName] integerValue];
#define LXHEncodeIntegerStament(propertyName) [encoder encodeObject:@(self.propertyName) forKey:@#propertyName];

#define LXHDecodeObjectOfStringClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSString class] forKey:@#propertyName];
#define LXHDecodeObjectOfDecimalNumberClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@#propertyName];
#define LXHDecodeObjectOfNumberClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSNumber class] forKey:@#propertyName];
#define LXHDecodeObjectOfMutableArrayClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSMutableArray class] forKey:@#propertyName];
#define LXHDecodeObjectOfArrayClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSArray class] forKey:@#propertyName];

#define LXHDecodeIntegerTypeStament(propertyName) self.propertyName = [[decoder decodeObjectForKey:@#propertyName] integerValue];
#define LXHEncodeIntegerStament(propertyName) [encoder encodeObject:@(self.propertyName) forKey:@#propertyName];


#define LXHWeakSelf __weak typeof(self) weakSelf = self;
#endif /* LXHGlobalHeader_h */
