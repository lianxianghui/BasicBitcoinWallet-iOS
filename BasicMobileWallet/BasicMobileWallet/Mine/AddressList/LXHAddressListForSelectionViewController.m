//
//  LXHAddressListForSelectionViewController.m
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddressListForSelectionViewController.h"
#import "LXHLocalAddressCell.h"
#import "LXHAddress.h"
#import "LXHWallet.h"

@interface LXHAddressListForSelectionViewController ()
@property (nonatomic, copy) addressSelectedCallback addressSelectedCallback;
@end

@implementation LXHAddressListForSelectionViewController

- (instancetype)initWithAddressSelectedCallback:(addressSelectedCallback)addressSelectedCallback {
    self = [super init];
    if (self) {
        _addressSelectedCallback = addressSelectedCallback;
    }
    return self;
}

//隐藏disclosureIndicator图标
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHLocalAddressCell"]) {
        NSInteger tag = [self tableView:tableView viewTagAtIndexPath:indexPath];
        UIView *view = [cell.contentView viewWithTag:tag];
        LXHLocalAddressCell *cellView = (LXHLocalAddressCell *)view;
        cellView.disclosureIndicator.hidden = YES;
    }
    return cell;
}

//通过回调返回选择的地址数据并pop返回上一页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cellDic = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSMutableDictionary *data = cellDic[@"data"];
    if (!data) //应该不会发生
        return;
    LXHAccount *account = [LXHWallet mainAccount];
    LXHLocalAddressType type = [data[@"addressType"] integerValue];
    uint32_t index = [data[@"addressIndex"] unsignedIntValue];
    LXHAddress *address = [account localAddressWithWithType:type index:index];
    _addressSelectedCallback(address);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
