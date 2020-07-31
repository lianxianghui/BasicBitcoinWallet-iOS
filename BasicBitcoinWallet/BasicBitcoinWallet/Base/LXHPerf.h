//
//  LXHPerf.h
//  BasicBitcoinWallet
//
//  Created by lian on 2020/5/13.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#ifndef LXHPerf_h
#define LXHPerf_h

#define RunWithCount(count, description, expr) \
do { \
CFAbsoluteTime start = CFAbsoluteTimeGetCurrent(); \
for(NSInteger i = 0; i < count; i++) { \
expr; \
} \
\
CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start; \
NSLog(@"%@ %0.3f", description, took); \
\
} while (0)

#define Run(description, expr) \
CFAbsoluteTime start = CFAbsoluteTimeGetCurrent(); \
expr; \
\
CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start; \
NSLog(@"%@ %0.3f", description, took);

#endif /* LXHPerf_h */
