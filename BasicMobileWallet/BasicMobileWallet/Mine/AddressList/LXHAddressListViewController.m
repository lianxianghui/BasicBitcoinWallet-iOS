// LXHAddressListViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddressListViewController.h"
#import "Masonry.h"
#import "LXHAddressListView.h"
#import "LXHAddressDetailViewController.h"
#import "LXHTitleCell.h"
#import "LXHLocalAddressCell.h"
#import "LXHWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHAddressListViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHAddressListView *contentView;
@property (nonatomic) NSMutableArray *dataForCells;
@end

@implementation LXHAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHAddressListView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Actions
- (void)leftImageButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftImageButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)leftImageButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

//Delegate Methods

- (NSArray *)localAddressCellDicArrayWithAddressType:(LXHLocalAddressType)addressType {
    NSMutableArray *ret = [NSMutableArray array];
    LXHAccount *account = LXHWallet.mainAccount;
    NSArray *usedAndCurrentAddresses = [account usedAndCurrentAddressesWithType:addressType];
    NSDictionary *localAddressCellFixedData = @{ @"isSelectable":@"1", @"type":@"P2PKH ", @"cellType":@"LXHLocalAddressCell"};
    //使用过的在前面，当前未用过的在最后一个
    for (NSInteger i = 0; i < usedAndCurrentAddresses.count; i++) {
        NSMutableDictionary *localAddressCellDic = localAddressCellFixedData.mutableCopy;
        localAddressCellDic[@"addressText"] = usedAndCurrentAddresses[i];
        localAddressCellDic[@"used"] = i < [account currentAddressIndexWithType:addressType] ? @"用过的" : @"未用过的";
        localAddressCellDic[@"localPath"] = [account addressPathWithType:addressType index:(uint32_t)i];
        localAddressCellDic[@"type"] = @"P2PKH";
        localAddressCellDic[@"data"] =  @{@"addressType":@(addressType), @"addressIndex":@(i)};
        [ret addObject:localAddressCellDic];
    } 
    return ret;
}

- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (!_dataForCells) {
        _dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            NSDictionary *dic = nil;
            //receiving addresses title
            dic = @{@"title":@"接收地址", @"isSelectable":@"0", @"cellType":@"LXHTitleCell"};
            [_dataForCells addObject:dic];
            //receiving addresses info cells
            [_dataForCells addObjectsFromArray:[self localAddressCellDicArrayWithAddressType:LXHLocalAddressTypeReceiving]];
            //change addresses title
            dic = @{@"title":@"找零地址", @"isSelectable":@"0", @"cellType":@"LXHTitleCell"};
            [_dataForCells addObject:dic];
            //change addresses info cells
            [_dataForCells addObjectsFromArray:[self localAddressCellDicArrayWithAddressType:LXHLocalAddressTypeChange]];
        }
    }
    return _dataForCells;
}

- (id)cellDataForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataForTableView = [self dataForTableView:tableView];
    if (indexPath.row < dataForTableView.count)
        return [dataForTableView objectAtIndex:indexPath.row];
    else
        return nil;
}


- (NSString *)tableView:(UITableView *)tableView cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentView.listView) {
        NSArray *data = [self dataForTableView:tableView];
        if (indexPath.row < data.count) {
            NSDictionary *cellData = [data objectAtIndex:indexPath.row];
            return [cellData valueForKey:@"cellType"];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView viewTagAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHTitleCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHLocalAddressCell"])
        return 101;
    return -1;
}

- (NSString *)tableView:(UITableView *)tableView cellContentViewClassStingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    NSString *classString = cellType;
    return classString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataForTableView:tableView].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    NSInteger tag = [self tableView:tableView viewTagAtIndexPath:indexPath];
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
        NSString *viewClass = [self tableView:tableView cellContentViewClassStingAtIndexPath:indexPath];
        UIView *view = [[NSClassFromString(viewClass) alloc] init];
        view.tag = tag;
        [cell.contentView addSubview:view];
        //if view.backgroudColor is clearColor, need to set backgroundColor of contentView and cell.
        //cell.contentView.backgroundColor = view.backgroundColor;
        //cell.backgroundColor = view.backgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
        if ([isSelectable isEqualToString:@"0"])
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell.contentView viewWithTag:tag];
    if ([cellType isEqualToString:@"LXHTitleCell"]) {
        LXHTitleCell *cellView = (LXHTitleCell *)view;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHLocalAddressCell"]) {
        LXHLocalAddressCell *cellView = (LXHLocalAddressCell *)view;
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @"";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *used = [dataForRow valueForKey:@"used"];
        if (!used)
            used = @"";
        NSMutableAttributedString *usedAttributedString = [cellView.used.attributedText mutableCopy];
        [usedAttributedString.mutableString setString:used];
        cellView.used.attributedText = usedAttributedString;
        NSString *localPath = [dataForRow valueForKey:@"localPath"];
        if (!localPath)
            localPath = @"";
        NSMutableAttributedString *localPathAttributedString = [cellView.localPath.attributedText mutableCopy];
        [localPathAttributedString.mutableString setString:localPath];
        cellView.localPath.attributedText = localPathAttributedString;
        NSString *type = [dataForRow valueForKey:@"type"];
        if (!type)
            type = @"";
        NSMutableAttributedString *typeAttributedString = [cellView.type.attributedText mutableCopy];
        [typeAttributedString.mutableString setString:type];
        cellView.type.attributedText = typeAttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTitleCell"])
            return 28;
        if ([cellType isEqualToString:@"LXHLocalAddressCell"])
            return 74;
    }
    return 0;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
    if ([isSelectable isEqualToString:@"0"])
        return nil;
    else
        return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cellDic = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSMutableDictionary *data = cellDic[@"data"];
    UIViewController *controller = [[LXHAddressDetailViewController alloc] initWithData:data];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
