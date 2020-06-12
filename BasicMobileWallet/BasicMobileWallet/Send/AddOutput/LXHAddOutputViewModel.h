//
//  LXHAddOutputViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionOutput.h"
#import "LXHAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddOutputViewModel : NSObject

@property (nonatomic) LXHTransactionOutput *output;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListView;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) NSDecimalNumber *maxValue;//最大值约束

- (NSString *)naviBarTitle;
- (NSString *)warningText;

- (void)resetCellDataArrayForListView;
- (BOOL)setBase58AddressOrUrl:(NSString *)address;
- (void)setAddress:(LXHAddress *)address;
- (BOOL)hasAddress;
- (BOOL)setValueString:(NSString *)valueString;
- (void)setTempText:(NSString *)tempText;
- (void)setTempTextToValueString;
- (BOOL)isChangeOutput;
@end

NS_ASSUME_NONNULL_END
