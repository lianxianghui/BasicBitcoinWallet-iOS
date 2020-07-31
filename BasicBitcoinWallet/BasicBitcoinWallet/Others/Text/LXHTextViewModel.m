//
//  LXHTextViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/26.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHTextViewModel.h"

@interface LXHTextViewModel ()
@property (nonatomic, readwrite) NSString *text;
@end

@implementation LXHTextViewModel

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

@end
