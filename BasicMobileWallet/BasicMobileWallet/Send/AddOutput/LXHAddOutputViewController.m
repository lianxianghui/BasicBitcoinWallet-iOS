// LXHAddOutputViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddOutputViewController.h"
#import "Masonry.h"
#import "LXHAddOutputView.h"
#import "LXHAddressListViewController.h"
#import "LXHTopLineCell.h"
#import "LXHInputAddressCell.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHAddOutputViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHAddOutputView *contentView;

@end

@implementation LXHAddOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHAddOutputView alloc] init];
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
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.rightTextButton addTarget:self action:@selector(rightTextButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.contentView.leftImageButton addTarget:self action:@selector(leftImageButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setDelegates {
    self.contentView.listView.dataSource = self;
    self.contentView.listView.delegate = self;
}

//Actions
- (void)rightTextButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightTextButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)rightTextButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

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

- (void)LXHInputAddressCellTextButton1Clicked:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)LXHInputAddressCellTextButton1TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)LXHInputAddressCellTextButton1TouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)LXHInputAddressCellTextButton2Clicked:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)LXHInputAddressCellTextButton2TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)LXHInputAddressCellTextButton2TouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)LXHInputAddressCellTextButton3Clicked:(UIButton *)sender {
    sender.alpha = 1;
    UIViewController *controller = [[LXHAddressListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

- (void)LXHInputAddressCellTextButton3TouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)LXHInputAddressCellTextButton3TouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    static NSMutableArray *dataForCells = nil;
    if (!dataForCells) {
        dataForCells = [NSMutableArray array];
        if (tableView == self.contentView.listView) {
            NSDictionary *dic = nil;
            dic = @{@"isSelectable":@"0", @"cellType":@"LXHTopLineCell"};
            [dataForCells addObject:dic];
            dic = @{@"text1":@"扫描", @"text3":@"地址: ", @"cellType":@"LXHInputAddressCell", @"text2":@"选择", @"addressText":@"mnJeCgC96UT76vCDhqxtzxFQLkSmm9RFwE ", @"text":@"粘贴", @"isSelectable":@"0", @"warningText":@"用过的本地找零地址 "};
            [dataForCells addObject:dic];
        }
    }
    return dataForCells;
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
    if ([cellType isEqualToString:@"LXHTopLineCell"])
        return 100;
    if ([cellType isEqualToString:@"LXHInputAddressCell"])
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
    if ([cellType isEqualToString:@"LXHTopLineCell"]) {
        LXHTopLineCell *cellView = (LXHTopLineCell *)view;
    }
    if ([cellType isEqualToString:@"LXHInputAddressCell"]) {
        LXHInputAddressCell *cellView = (LXHInputAddressCell *)view;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @"";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *text1 = [dataForRow valueForKey:@"text1"];
        if (!text1)
            text1 = @"";
        NSMutableAttributedString *text1AttributedString = [cellView.text1.attributedText mutableCopy];
        [text1AttributedString.mutableString setString:text1];
        cellView.text1.attributedText = text1AttributedString;
        NSString *text2 = [dataForRow valueForKey:@"text2"];
        if (!text2)
            text2 = @"";
        NSMutableAttributedString *text2AttributedString = [cellView.text2.attributedText mutableCopy];
        [text2AttributedString.mutableString setString:text2];
        cellView.text2.attributedText = text2AttributedString;
        NSString *warningText = [dataForRow valueForKey:@"warningText"];
        if (!warningText)
            warningText = @"";
        NSMutableAttributedString *warningTextAttributedString = [cellView.warningText.attributedText mutableCopy];
        [warningTextAttributedString.mutableString setString:warningText];
        cellView.warningText.attributedText = warningTextAttributedString;
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @"";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *text3 = [dataForRow valueForKey:@"text3"];
        if (!text3)
            text3 = @"";
        NSMutableAttributedString *text3AttributedString = [cellView.text3.attributedText mutableCopy];
        [text3AttributedString.mutableString setString:text3];
        cellView.text3.attributedText = text3AttributedString;
        cellView.textButton1.tag = indexPath.row;
        [cellView.textButton1 addTarget:self action:@selector(LXHInputAddressCellTextButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.textButton1 addTarget:self action:@selector(LXHInputAddressCellTextButton1TouchDown:) forControlEvents:UIControlEventTouchDown];
        [cellView.textButton1 addTarget:self action:@selector(LXHInputAddressCellTextButton1TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        cellView.textButton2.tag = indexPath.row;
        [cellView.textButton2 addTarget:self action:@selector(LXHInputAddressCellTextButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.textButton2 addTarget:self action:@selector(LXHInputAddressCellTextButton2TouchDown:) forControlEvents:UIControlEventTouchDown];
        [cellView.textButton2 addTarget:self action:@selector(LXHInputAddressCellTextButton2TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        cellView.textButton3.tag = indexPath.row;
        [cellView.textButton3 addTarget:self action:@selector(LXHInputAddressCellTextButton3Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.textButton3 addTarget:self action:@selector(LXHInputAddressCellTextButton3TouchDown:) forControlEvents:UIControlEventTouchDown];
        [cellView.textButton3 addTarget:self action:@selector(LXHInputAddressCellTextButton3TouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTopLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHInputAddressCell"])
            return 65;
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
        case 0:
            {
            }
            break;
        case 1:
            {
            }
            break;
        default:
            break;
    }
}

@end
