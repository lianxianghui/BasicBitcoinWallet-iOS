// LXHAddressDetailViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-09-16
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddressDetailViewController.h"
#import "Masonry.h"
#import "LXHAddressDetailView.h"
#import "LXHTransactionDetailViewController.h"
#import "LXHAddressViewController.h"
#import "LXHAddressDetailCell.h"
#import "LXHEmptyWithSeparatorCell.h"
#import "LXHAddressDetailTextRightIconCell.h"
#import "LXHWallet.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHAddressDetailViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHAddressDetailView *contentView;
@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSMutableArray *cellDataArray;
@end

@implementation LXHAddressDetailViewController

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHAddressDetailView alloc] init];
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
- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            LXHAddressType type = [_data[@"addressType"] integerValue];
            NSInteger index = [_data[@"addressIndex"] integerValue];
            LXHAccount *account = LXHWallet.mainAccount;
            //@{@"title":@"地址Base58 ", @"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell", @"text":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE"};
            NSDictionary *addressDetailCellDic = @{@"isSelectable":@"1", @"cellType":@"LXHAddressDetailCell"};
            
            NSMutableDictionary *dic = addressDetailCellDic.mutableCopy;
            dic[@"title"] = NSLocalizedString(@"地址Base58", nil); 
            dic[@"text"] = [account addressWithType:type index:index];
            [_cellDataArray addObject:dic];
            
            dic = addressDetailCellDic.mutableCopy;
            dic[@"title"] = NSLocalizedString(@"本地路径", nil);
            dic[@"text"] = [account addressPathWithType:type index:index];
            [_cellDataArray addObject:dic];

            dic = addressDetailCellDic.mutableCopy;
            dic[@"title"] = NSLocalizedString(@"使用情况", nil);
            dic[@"text"] = @"TODO 重构代码后实现";
            [_cellDataArray addObject:dic];   
            
            dic = addressDetailCellDic.mutableCopy;
            dic[@"title"] = NSLocalizedString(@"地址类型", nil);
            dic[@"text"] = @"P2PKH (Pay-to-Public-Key-Hash)";
            [_cellDataArray addObject:dic];
            
            dic = addressDetailCellDic.mutableCopy;
            dic[@"title"] = NSLocalizedString(@"地址用途", nil);
            dic[@"text"] = type == LXHAddressTypeReceiving ? @"接收" : @"找零";
            [_cellDataArray addObject:dic];
            
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHEmptyWithSeparatorCell"}.mutableCopy;
            [_cellDataArray addObject:dic];
            dic = @{@"text":NSLocalizedString(@"相关交易", nil), @"isSelectable":@"1", @"cellType":@"LXHAddressDetailTextRightIconCell"}.mutableCopy;
            [_cellDataArray addObject:dic];
            dic = @{@"text":NSLocalizedString(@"地址二维码", nil), @"isSelectable":@"1", @"cellType":@"LXHAddressDetailTextRightIconCell"}.mutableCopy;
            [_cellDataArray addObject:dic];
        }
    }
    return _cellDataArray;
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
        return 101;
    if ([cellType isEqualToString:@"LXHAddressDetailTextRightIconCell"])
        return 102;
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
    if ([cellType isEqualToString:@"LXHAddressDetailCell"]) {
        LXHAddressDetailCell *cellView = (LXHAddressDetailCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *title = [dataForRow valueForKey:@"title"];
        if (!title)
            title = @"";
        NSMutableAttributedString *titleAttributedString = [cellView.title.attributedText mutableCopy];
        [titleAttributedString.mutableString setString:title];
        cellView.title.attributedText = titleAttributedString;
    }
    if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"]) {
        LXHEmptyWithSeparatorCell *cellView = (LXHEmptyWithSeparatorCell *)view;
    }
    if ([cellType isEqualToString:@"LXHAddressDetailTextRightIconCell"]) {
        LXHAddressDetailTextRightIconCell *cellView = (LXHAddressDetailTextRightIconCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHAddressDetailCell"])
            return 47;
        if ([cellType isEqualToString:@"LXHEmptyWithSeparatorCell"])
            return 18;
        if ([cellType isEqualToString:@"LXHAddressDetailTextRightIconCell"])
            return 47;
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
    switch(indexPath.row) {
        case 6:
            {
            UIViewController *controller = [[LXHTransactionDetailViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        case 7:
            {
            UIViewController *controller = [[LXHAddressViewController alloc] initWithData:_data];
            [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
}

@end
