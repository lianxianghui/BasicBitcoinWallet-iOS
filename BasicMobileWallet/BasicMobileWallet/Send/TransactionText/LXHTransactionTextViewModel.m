//
//  LXHTransactionTextViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/5.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTransactionTextViewModel.h"
#import "NSJSONSerialization+VLBase.h"

@interface LXHTransactionTextViewModel ()
@property (nonatomic) NSDictionary *data;
@end

@implementation LXHTransactionTextViewModel


- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}


- (NSString *)text {
    return [NSJSONSerialization jsonStringWithObject:_data] ?: @" ";
}

@end
