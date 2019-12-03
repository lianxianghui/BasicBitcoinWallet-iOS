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

@interface LXHAddOutputViewModel : NSObject {
    LXHTransactionOutput *_output;
}

@property (nonatomic, nullable) LXHAddress *localAddress;
@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListView;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) NSDecimalNumber *maxValue;//最大值约束

- (NSString *)naviBarTitle;
- (NSString *)warningText;

- (void)resetCellDataArrayForListView;
- (BOOL)setAddress:(NSString *)address;
- (BOOL)setValueString:(NSString *)valueString;

- (void)setOutput:(LXHTransactionOutput *)output;
- (LXHTransactionOutput *)output;
- (BOOL)isChangeOutput;
@end

NS_ASSUME_NONNULL_END
