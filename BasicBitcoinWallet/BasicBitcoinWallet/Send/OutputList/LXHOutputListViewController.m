// LXHOutputListViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHOutputListViewController.h"
#import "Masonry.h"
#import "LXHOutputListView.h"
#import "LXHAddOutputViewController.h"
#import "LXHTopLineCell.h"
#import "LXHSelectedOutputCell.h"
#import "UILabel+LXHText.h"
#import "UIButton+LXHText.h"
#import "LXHOutputListViewModel.h"
#import "LXHGlobalHeader.h"
#import "LXHAddOutputViewModel.h"
#import "UIViewController+LXHAlert.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHOutputListViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHOutputListView *contentView;
@property (nonatomic) LXHOutputListViewModel *viewModel;
@end

@implementation LXHOutputListViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0xFAFAFAFF);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[LXHOutputListView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self setContentViewProperties];
    [self addActions];
    [self setDelegates];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.modifyOrderButton addTarget:self action:@selector(modifyOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.addOutputButton addTarget:self action:@selector(addOutputButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setContentViewProperties {
    [self refreshHeaderInfo];
}

- (void)refreshView {
    [self refreshHeaderInfo];
    [self refreshListView];
}

- (void)refreshHeaderInfo {
    [self.contentView.text updateAttributedTextString:[_viewModel headerInfoTitle]];
    [self.contentView.value updateAttributedTextString:[_viewModel headerInfoText]];
}

- (void)refreshListView {
    [_viewModel resetCellDataArrayForListview];
    [self.contentView.listView reloadData];
}

//Actions
- (void)modifyOrderButtonClicked:(UIButton *)sender { //调整顺序按钮
    UITableView *listView = self.contentView.listView;
    [listView setEditing:!listView.editing animated:YES];
    NSString *text = listView.editing ? NSLocalizedString(@"完成", nil) : NSLocalizedString(@"调整顺序", nil);
    [sender updateAttributedTitleString:text forState:UIControlStateNormal];
}

- (void)addOutputButtonClicked:(UIButton *)sender {
    LXHAddOutputViewModel *newOutputViewModel = [_viewModel getNewOutputViewModel];
    if (!newOutputViewModel) {
        [self showOkAlertViewWithMessage:NSLocalizedString(@"无法添加输出", nil) handler:nil];
        return;
    }
    LXHWeakSelf
    //todo 去掉测试用代码
//    [newOutputViewModel setBase58Address:@"mqo7674J9Q7hpfPB6qFoYufMdoNjEsRZHx"];
//    //[newOutputViewModel setBase58Address:@"2NAQtG5iToBy64FjpHGsRhxZjTFxvgr3E7Q"];
//    [newOutputViewModel setValueString:@"0.0001"];
    UIViewController *controller = [[LXHAddOutputViewController alloc] initWithViewModel:newOutputViewModel addOrEditOutputCallback:^{
        [weakSelf.viewModel addOutputViewModel:newOutputViewModel];
        [self refreshView];
    }];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

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

//delete button clicked
- (void)LXHSelectedOutputCellButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    LXHWeakSelf
    [self showOkCancelAlertViewWithMessage:NSLocalizedString(@"您确定要删除该输出吗？", nil) okHandler:^(UIAlertAction * _Nonnull action) {
        NSInteger index = sender.tag;
        [weakSelf.viewModel deleteRowAtIndex:index];
        [weakSelf refreshView];
    } cancelHandler:nil];
}

- (void)LXHSelectedOutputCellButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)LXHSelectedOutputCellButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    return _viewModel.cellDataArrayForListview;
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
    if ([cellType isEqualToString:@"LXHSelectedOutputCell"])
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
    if ([cellType isEqualToString:@"LXHSelectedOutputCell"]) {
        LXHSelectedOutputCell *cellView = (LXHSelectedOutputCell *)view;
        NSString *btcValue = [dataForRow valueForKey:@"btcValue"];
        if (!btcValue)
            btcValue = @"";
        NSMutableAttributedString *btcValueAttributedString = [cellView.btcValue.attributedText mutableCopy];
        [btcValueAttributedString.mutableString setString:btcValue];
        cellView.btcValue.attributedText = btcValueAttributedString;
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @"";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *address = [dataForRow valueForKey:@"address"];
        if (!address)
            address = @"";
        NSMutableAttributedString *addressAttributedString = [cellView.address.attributedText mutableCopy];
        [addressAttributedString.mutableString setString:address];
        cellView.address.attributedText = addressAttributedString;
        NSString *addressWarningDesc = [dataForRow valueForKey:@"addressWarningDesc"];
        NSMutableAttributedString *addressAttributesAttributedString = [cellView.addressWarningDesc.attributedText mutableCopy];
        [addressAttributesAttributedString.mutableString setString:addressWarningDesc];
        cellView.addressWarningDesc.attributedText = addressAttributesAttributedString;
        NSNumber *addressWarningDescHidden = [dataForRow valueForKey:@"addressWarningDescHidden"];
        cellView.addressWarningDesc.hidden = addressWarningDescHidden.boolValue;
        
        NSString *addressDesc = [dataForRow valueForKey:@"addressDesc"];
        if (!addressDesc)
            addressDesc = @"";
        NSMutableAttributedString *addressDescAttributedString = [cellView.addressDesc.attributedText mutableCopy];
        [addressDescAttributedString.mutableString setString:addressDesc];
        cellView.addressDesc.attributedText = addressDescAttributedString;
        cellView.addressDesc.hidden = !cellView.addressWarningDesc.hidden;
        
        NSString *deleteImageImageName = [dataForRow valueForKey:@"deleteImage"];
        if (deleteImageImageName)
            cellView.deleteImage.image = [UIImage imageNamed:deleteImageImageName];
        cellView.button.tag = indexPath.row;
        [cellView.button addTarget:self action:@selector(LXHSelectedOutputCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.button addTarget:self action:@selector(LXHSelectedOutputCellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cellView.button addTarget:self action:@selector(LXHSelectedOutputCellButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTopLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHSelectedOutputCell"])
            return 70;
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
    //edit exist output
    id dataForRow = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSInteger index = [dataForRow[@"index"] integerValue];
    LXHAddOutputViewModel *existOutputViewModel = [_viewModel outputViewModels][index];
    [_viewModel refreshViewModelAtIndex:index];
    existOutputViewModel.isEditing = YES;
    UIViewController *controller = [[LXHAddOutputViewController alloc] initWithViewModel:existOutputViewModel addOrEditOutputCallback:^{
        [self refreshView];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

//以下代码使得Tableview cell 可以通过被拖动改变顺序
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHSelectedOutputCell"])
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [_viewModel moveRowAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
