//
//  LXHGlobalHeader.h
//  BasicBitcoinWallet
//
//  Created by lianxianghui on 2019/8/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#ifndef LXHGlobalHeader_h
#define LXHGlobalHeader_h

#import "LXHBitcoinNetwork.h"


typedef long long LXHBTCAmount;
static const LXHBTCAmount LXHBTCCoin = 100000000;
static const LXHBTCAmount LXHBTC_MAX_MONEY = 21000000 * LXHBTCCoin;
static const LXHBTCAmount LXHBTCAmountError = -1;

#define LXHAESPassword @"serefddetggg" //随便写的，可以用你自己的代替
#define LXHCacheFileDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory ,NSUserDomainMask, YES) firstObject]
#define LXHDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define LXHTransactionTimeDateFormat @"yyyy-MM-dd HH:mm:ss"

//encode decode statement macro
#define LXHEncodeObjectStament(propertyName) [encoder encodeObject:self.propertyName forKey:@#propertyName];
#define LXHEncodeIntegerStament(propertyName) [encoder encodeObject:@(self.propertyName) forKey:@#propertyName];
#define LXHEncodeUnsignedIntegerStament(propertyName) LXHEncodeIntegerStament(propertyName);
#define LXHEncodeBOOLStament(propertyName) LXHEncodeIntegerStament(propertyName);

#define LXHDecodeObjectStament(propertyName) self.propertyName = [decoder decodeObjectForKey:@#propertyName];
#define LXHDecodeIntegerTypeStament(propertyName) self.propertyName = [[decoder decodeObjectForKey:@#propertyName] integerValue];
#define LXHDecodeUnsignedIntegerTypeStament(propertyName) self.propertyName = [[decoder decodeObjectForKey:@#propertyName] unsignedIntegerValue];
#define LXHDecodeBOOLTypeStament(propertyName) self.propertyName = [[decoder decodeObjectForKey:@#propertyName] boolValue];

#define LXHDecodeObjectOfStringClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSString class] forKey:@#propertyName];
#define LXHDecodeObjectOfDecimalNumberClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSDecimalNumber class] forKey:@#propertyName];
#define LXHDecodeObjectOfNumberClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSNumber class] forKey:@#propertyName];
#define LXHDecodeObjectOfMutableArrayClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSMutableArray class] forKey:@#propertyName];
#define LXHDecodeObjectOfArrayClassStament(propertyName) self.propertyName = [decoder decodeObjectOfClass:[NSArray class] forKey:@#propertyName];


#define LXHWeakSelf __weak typeof(self) weakSelf = self;
#endif /* LXHGlobalHeader_h */
