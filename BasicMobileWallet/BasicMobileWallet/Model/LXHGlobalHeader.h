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
#define LXCacheFileDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory ,NSUserDomainMask, YES) objectAtIndex:0]
#define LXHTranactionTimeDateFormat @"yyyy-MM-dd HH:mm:ss"
#endif /* LXHGlobalHeader_h */
