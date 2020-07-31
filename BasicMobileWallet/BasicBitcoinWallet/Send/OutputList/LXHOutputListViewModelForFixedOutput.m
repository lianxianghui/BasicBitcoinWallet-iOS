//
//  LXHOutputListViewModelForFixedOutput.m
//  BasicBitcoinWallet
//
//  Created by lian on 2019/12/4.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModelForFixedOutput.h"
#import "LXHAddOutputViewModel.h"

@implementation LXHOutputListViewModelForFixedOutput

- (NSString *)headerInfoTitle {
    return @"输出总值";
}

- (NSString *)headerInfoText {
    NSDecimalNumber *sum = [LXHTransactionOutput valueSumOfOutputs:[self outputs]];
    return  [NSString stringWithFormat:@"%@BTC", sum];
}

- (LXHAddOutputViewModel *)getNewOutputViewModel {
    return [[LXHAddOutputViewModel alloc] init];
}

@end
