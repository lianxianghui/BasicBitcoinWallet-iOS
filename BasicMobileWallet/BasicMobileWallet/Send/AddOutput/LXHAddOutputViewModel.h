//
//  LXHAddOutputViewModel.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHTransactionOutput.h"
#import "LXHLocalAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddOutputViewModel : NSObject

@property (nonatomic, readonly) NSMutableArray *cellDataArrayForListView;
@property (nonatomic) LXHLocalAddress *localAddress;
@property (nonatomic, readonly) LXHTransactionOutput *output;
@property (nonatomic) BOOL isEditing;

- (NSString *)naviBarTitle;
- (void)resetCellDataArrayForListView;
- (BOOL)setAddress:(NSString *)address;
- (BOOL)setValueString:(NSString *)valueString;
@end

NS_ASSUME_NONNULL_END
