//
//  LXHSelectInputViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXHSelectInputViewModel : NSObject
@property (nonatomic, readonly) NSArray *selectedUtxos;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListview;

- (NSString *)valueText;
- (void)toggleCheckedStateOfRow:(NSInteger)row;
- (void)moveRowAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
@end

NS_ASSUME_NONNULL_END
