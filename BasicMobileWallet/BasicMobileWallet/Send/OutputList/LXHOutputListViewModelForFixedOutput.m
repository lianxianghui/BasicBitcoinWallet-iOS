//
//  LXHOutputListViewModelForFixedOutput.m
//  BasicMobileWallet
//
//  Created by lian on 2019/12/4.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHOutputListViewModelForFixedOutput.h"
#import "LXHAddOutputViewModel.h"

@implementation LXHOutputListViewModelForFixedOutput

- (LXHAddOutputViewModel *)getNewOutputViewModel {
    return [[LXHAddOutputViewModel alloc] init];
}

@end
