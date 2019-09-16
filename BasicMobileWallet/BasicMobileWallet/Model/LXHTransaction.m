//
//  LXHTransaction.m
//  BasicMobileWallet
//
//  Created by lianxianghui on 2019/9/16.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransaction.h"
#import "LXHWallet.h"

@interface LXHTransaction ()
@property (nonatomic, readwrite) NSDictionary *dic;
@end

@implementation LXHTransaction

- (instancetype)initWithDic:(NSDictionary *)dic;
{
    self = [super init];
    if (self) {
        _dic = dic;
    }
    return self;
}

@end
