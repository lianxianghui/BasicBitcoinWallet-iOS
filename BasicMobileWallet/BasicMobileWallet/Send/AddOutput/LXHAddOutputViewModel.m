//
//  LXHAddOutputViewModel.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/21.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddOutputViewModel.h"
#import "LXHTransactionOutput.h"
#import "LXHLocalAddress.h"
#import "NSString+Base.h"
#import "BTCAddress.h"
#import "LXHWallet.h"

@interface LXHAddOutputViewModel ()
@property (nonatomic, readwrite) NSMutableArray *cellDataArrayForListView;
@end

@implementation LXHAddOutputViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TODO 临时的
        [self setAddress:@"mqo7674J9Q7hpfPB6qFoYufMdoNjEsRZHx"];
        [self setValueString:@"0.005"];
    }
    return self;
}

- (NSString *)naviBarTitle {
    return _isEditing ? NSLocalizedString(@"编辑输出", nil) : NSLocalizedString(@"添加输出", nil);
}

- (NSMutableArray *)cellDataArrayForListView {
    if (!_cellDataArrayForListView) {
        _cellDataArrayForListView = [NSMutableArray array];
        NSDictionary *dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
        [_cellDataArrayForListView addObject:dic];
        
        NSString *text, *warningText, *addressText;
        if (self.output.address) {
            text = NSLocalizedString(@"地址: ", nil);
            addressText = self.output.address ?: @" ";
        } else {
            text = NSLocalizedString(@"地址: 点击添加", nil);
            addressText = @" ";
        }
        warningText = [self warningText];
        dic = @{@"text":text, @"warningText":warningText, @"isSelectable":@"1", @"cellType":@"LXHInputAddressCell", @"addressText":addressText};
        [_cellDataArrayForListView addObject:dic];
        
        NSString *maxValueString = _maxValue ? [NSString stringWithFormat:NSLocalizedString(@"可输入最大值: %@", nil), _maxValue] : @" ";
        BOOL maxValueHidden = [self maxValuePromptLabelHidden];
        BOOL textButtonHidden = [self maxValueButtonHidden];
        dic = @{@"maxValue":maxValueString,
                @"text1":@"数量:",
                @"isSelectable":@"0",
                @"text":@"输入最大值",
                @"cellType":@"LXHInputAmountCell",
                @"BTC":@" BTC",
                @"textFieldText":[self valueString],
                @"maxValueHidden":@(maxValueHidden),
                @"textButtonHidden":@(textButtonHidden),
                };
        [_cellDataArrayForListView addObject:dic];
    }
    return _cellDataArrayForListView;
}

- (NSString *)warningText {
    if (_localAddress) {
        NSString *format = NSLocalizedString(@"%@本地%@地址", nil); //例如 "用过的本地找零地址"
        NSString *string1 = _localAddress.used ? NSLocalizedString(@"用过的", nil) : @"";
        NSString *string2 = _localAddress.type == LXHAddressTypeChange ? NSLocalizedString(@"找零", nil) : NSLocalizedString(@"接收", nil);
        NSString *text = [NSString stringWithFormat:format, string1, string2];
        return text;
    } else
        return @" ";
}

- (void)resetCellDataArrayForListView {
    _cellDataArrayForListView = nil;
}

- (BOOL)maxValuePromptLabelHidden {
    return _maxValue == nil;
}

- (BOOL)maxValueButtonHidden {
    return _maxValue == nil;
}


- (BOOL)setAddress:(NSString *)address {
    NSString *validAddress = [LXHAddOutputViewModel validAddress:address];
    if (validAddress) {
        LXHLocalAddress *localAddress = [LXHWallet.mainAccount localAddressWithBase58Address:validAddress];
        if (localAddress)
            [self setLocalAddress:localAddress];
        else
            self.output.address = validAddress;
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)valueString {
    if (self.output.value)
        return [NSString stringWithFormat:@"%@", self.output.value];
    else
        return @"";
}

- (BOOL)setValueString:(NSString *)valueString {
    //todo check
    BOOL valueIsValid = YES;
    if (valueIsValid) {
        self.output.value = [[NSDecimalNumber alloc] initWithString:valueString];
        [self resetCellDataArrayForListView];
        return YES;
    } else {
        return NO;
    }
}

/**
 返回有效的地址，如果无效返回nil
 */
+ (NSString *)validAddress:(NSString *)address { //todo 放到一个公共的地方，比如AddressUtil
    address = [address stringByTrimmingWhiteSpace];
    address = [address stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
    if ([BTCAddress addressWithString:address]) //有效
        return address;
    else
        return nil;
}

- (void)setLocalAddress:(LXHLocalAddress *)localAddress {
    _localAddress = localAddress;
    self.output.address = localAddress.addressString;
}

- (void)setOutput:(LXHTransactionOutput *)output {
    _output = output;
    _localAddress = [LXHWallet.mainAccount localAddressWithBase58Address:output.address];
    
}
- (LXHTransactionOutput *)output {
    if (!_output)
        _output = [LXHTransactionOutput new];
    return _output;
}

- (BOOL)isChangeOutput {
    if (_localAddress)
        return _localAddress.type == LXHAddressTypeChange;
    return NO;
}

@end
