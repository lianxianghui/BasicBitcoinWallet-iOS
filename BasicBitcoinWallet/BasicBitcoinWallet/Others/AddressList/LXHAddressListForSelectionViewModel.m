//
//  LXHAddressListForSelectionViewModel.m
//  BasicBitcoinWallet
//
//  Created by lian on 2020/4/30.
//  Copyright © 2020年 lianxianghui. All rights reserved.
//

#import "LXHAddressListForSelectionViewModel.h"
#import "LXHWallet.h"

@implementation LXHAddressListForSelectionViewModel

- (BOOL)cellDisclosureIndicatorHidden {
    return YES;
}

- (NSDictionary *)clickCellNavigationInfoAtIndex:(NSInteger)index {
    NSString *navigationType = @"pop";
    return @{@"navigationType":navigationType};
}

@end
