// LXHSelectInputViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-10-21
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHSelectInputViewController.h"
#import "Masonry.h"
#import "LXHSelectInputView.h"
#import "LXHOutputDetailViewController.h"
#import "LXHTopLineCell.h"
#import "LXHSelectInputCell.h"
#import "UILabel+LXHText.h"
#import "UIButton+LXHText.h"
#import "LXHSelectInputViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHSelectInputViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHSelectInputView *contentView;
@property (nonatomic) LXHSelectInputViewModel *viewModel;
@end

@implementation LXHSelectInputViewController

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
    self.contentView = [[LXHSelectInputView alloc] init];
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
    [self setContentViewProperties];
}

- (void)swipeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addActions {
    [self.contentView.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    [self refreshInfoText];
}

- (void)refreshInfoText {
    [self.contentView.text updateAttributedTextString:[_viewModel infoText]];
}

//Actions
- (void)buttonClicked:(UIButton *)sender { //调整顺序按钮
    UITableView *listView = self.contentView.listView;
    [listView setEditing:!listView.editing animated:YES];
    NSString *text = listView.editing ? NSLocalizedString(@"完成", nil) : NSLocalizedString(@"调整顺序", nil);
    [sender updateAttributedTitleString:text forState:UIControlStateNormal];
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

- (void)LXHSelectInputCellButtonClicked:(UIButton *)sender {
    NSUInteger index = (NSUInteger)sender.tag;
    id viewModel = [_viewModel outputDetailViewModelAtIndex:index];
    UIViewController *controller = [[LXHOutputDetailViewController alloc] initWithViewModel:viewModel];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES]; 
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    if (tableView == self.contentView.listView) {
        return _viewModel.cellDataArrayForListview;
    } else {
        return nil;
    }
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
    if ([cellType isEqualToString:@"LXHSelectInputCell"])
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
        cell.contentView.backgroundColor = view.backgroundColor;
        cell.backgroundColor = view.backgroundColor;
//        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.backgroundColor = [UIColor clearColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NSString *isSelectable = [dataForRow valueForKey:@"isSelectable"];
        if ([isSelectable isEqualToString:@"0"])
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell.contentView viewWithTag:tag];
    if ([cellType isEqualToString:@"LXHSelectInputCell"]) {
        LXHSelectInputCell *cellView = (LXHSelectInputCell *)view;
        NSString *btcValue = [dataForRow valueForKey:@"btcValue"];
        if (!btcValue)
            btcValue = @"";
        NSMutableAttributedString *btcValueAttributedString = [cellView.btcValue.attributedText mutableCopy];
        [btcValueAttributedString.mutableString setString:btcValue];
        cellView.btcValue.attributedText = btcValueAttributedString;
        cellView.btcValue.hidden = [[dataForRow valueForKey:@"btcValueHidden"] boolValue];
        
        NSString *btcValueForWarning = [dataForRow valueForKey:@"btcValueForWarning"];
        if (!btcValueForWarning)
            btcValueForWarning = @"";
        NSMutableAttributedString *btcValueForWarningAttributedString = [cellView.btcValueForWarning.attributedText mutableCopy];
        [btcValueForWarningAttributedString.mutableString setString:btcValueForWarning];
        cellView.btcValueForWarning.attributedText = btcValueForWarningAttributedString;
        cellView.btcValueForWarning.hidden = [[dataForRow valueForKey:@"btcValueForWarningHidden"] boolValue];
        
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @"";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *timeValue = [dataForRow valueForKey:@"timeValue"];
        if (!timeValue)
            timeValue = @"";
        NSMutableAttributedString *timeValueAttributedString = [cellView.timeValue.attributedText mutableCopy];
        [timeValueAttributedString.mutableString setString:timeValue];
        cellView.timeValue.attributedText = timeValueAttributedString;
        NSString *time = [dataForRow valueForKey:@"time"];
        if (!time)
            time = @"";
        NSMutableAttributedString *timeAttributedString = [cellView.time.attributedText mutableCopy];
        [timeAttributedString.mutableString setString:time];
        cellView.time.attributedText = timeAttributedString;
        NSString *circleImageImageName = [dataForRow valueForKey:@"circleImage"];
        if (circleImageImageName)
            cellView.circleImage.image = [UIImage imageNamed:circleImageImageName];
        NSString *checkedImageImageName = [dataForRow valueForKey:@"checkedImage"];
        if (checkedImageImageName)
            cellView.checkedImage.image = [UIImage imageNamed:checkedImageImageName];
        BOOL isChecked = [[dataForRow valueForKey:@"isChecked"] boolValue];
        cellView.checkedImage.hidden = !isChecked;
        cellView.circleImage.hidden = isChecked;
        cellView.button.tag = indexPath.row;
        [cellView.button addTarget:self action:@selector(LXHSelectInputCellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTopLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHSelectInputCell"])
            return 80;
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
    NSMutableDictionary *cellData = [self cellDataForTableView:tableView atIndexPath:indexPath];
    NSString *cellType = cellData[@"cellType"];
    if (![cellType isEqualToString:@"LXHSelectInputCell"])
        return;
    [_viewModel toggleCheckedStateOfRow:indexPath.row];
    [self refreshInfoText];
    [self.contentView.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

//以下代码使得Tableview cell 可以通过被拖动改变顺序
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if ([cellType isEqualToString:@"LXHSelectInputCell"])
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
