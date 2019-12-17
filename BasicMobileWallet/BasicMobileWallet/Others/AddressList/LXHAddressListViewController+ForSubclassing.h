//
//  LXHAddressListViewController+ForSubclassing.h
//  BasicMobileWallet
//
//  Created by lian on 2019/11/8.
//  Copyright © 2019年 lianxianghui. All rights reserved.
//

#import "LXHAddressListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXHAddressListViewController (ForSubclassing)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;//子类覆盖
- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;//子类调用
- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath;//子类调用
- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath;//子类调用
@end

NS_ASSUME_NONNULL_END
