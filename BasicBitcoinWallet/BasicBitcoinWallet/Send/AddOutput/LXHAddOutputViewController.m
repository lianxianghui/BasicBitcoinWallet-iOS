// LXHAddOutputViewController.m
// BasicWallet
//
//  Created by lianxianghui on 19-11-7
//  Copyright © 2019年 lianxianghui. All rights reserved.

#import "LXHAddOutputViewController.h"
#import "Masonry.h"
#import "LXHAddOutputView.h"
#import "LXHTopLineCell.h"
#import "LXHInputAddressCell.h"
#import "LXHInputAmountCell.h"
#import "BTCQRCode.h"
#import "LXHGlobalHeader.h"
#import "LXHAddressListViewController.h"
#import "Toast.h"
#import "LXHAddOutputViewModel.h"
#import "UILabel+LXHText.h"
#import "UIViewController+LXHAlert.h"
#import "LXHScanQRViewController.h"
#import "LXHAddressListForSelectionViewModel.h"

#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0 \
        green:((rgbaValue & 0x00FF0000) >>  16)/255.0 \
        blue:((rgbaValue & 0x0000FF00) >>  8)/255.0 \
        alpha:(rgbaValue & 0x000000FF)/255.0]
    
@interface LXHAddOutputViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) LXHAddOutputView *contentView;
@property (nonatomic, copy) addOrEditOutputCallback addOrEditOutputCallback;
@property (nonatomic) LXHAddOutputViewModel *viewModel;
@property (nonatomic) UIView *scanerView;
@property (nonatomic) UITextField *textField;
@end

@implementation LXHAddOutputViewController

- (instancetype)initWithViewModel:(id)viewModel addOrEditOutputCallback:(addOrEditOutputCallback)addOutputCallback {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [_viewModel setTempTextToValueString];
        _addOrEditOutputCallback = addOutputCallback;
    }
    return self;
}

- (void)dealloc {
    [_viewModel setTempText:@""];
}

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
    [self setContentViewProperties];
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

- (void)setContentViewProperties {
    [self.contentView.title updateAttributedTextString:[_viewModel naviBarTitle]];
}

//Actions
- (void)rightTextButtonClicked:(UIButton *)sender {
    sender.alpha = 1;
    if (![_viewModel hasAddress]) {
        [self showOkAlertViewWithMessage:NSLocalizedString(@"请设置地址", nil) handler:nil];
        return;
    }
    if ([_viewModel setValueString:_textField.text]) {
        if (_addOrEditOutputCallback)
            _addOrEditOutputCallback();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showOkAlertViewWithMessage:NSLocalizedString(@"您所输入的值无效，请检查后重新输入", nil) handler:nil];
    }
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

- (void)LXHInputAmountCellTextButtonClicked:(UIButton *)sender {
    _textField.text = [_viewModel.maxValue description];
    [_viewModel setTempText:_textField.text];
    sender.alpha = 1;
}

- (void)LXHInputAmountCellTextButtonTouchDown:(UIButton *)sender {
    sender.alpha = 0.5;
}

- (void)LXHInputAmountCellTextButtonTouchUpOutside:(UIButton *)sender {
    sender.alpha = 1;
}

- (void)refreshListView {
    [_viewModel resetCellDataArrayForListView];
    [self.contentView.listView reloadData];
}

//Delegate Methods
- (NSArray *)dataForTableView:(UITableView *)tableView {
    return _viewModel.cellDataArrayForListView;
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
    if ([cellType isEqualToString:@"LXHInputAmountCell"])
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
    if ([cellType isEqualToString:@"LXHInputAddressCell"]) {
        LXHInputAddressCell *cellView = (LXHInputAddressCell *)view;
        NSString *warningText = [dataForRow valueForKey:@"warningText"];
        if (!warningText)
            warningText = @" ";
        NSMutableAttributedString *warningTextAttributedString = [cellView.warningText.attributedText mutableCopy];
        [warningTextAttributedString.mutableString setString:warningText];
        cellView.warningText.attributedText = warningTextAttributedString;
        NSString *addressText = [dataForRow valueForKey:@"addressText"];
        if (!addressText)
            addressText = @" ";
        NSMutableAttributedString *addressTextAttributedString = [cellView.addressText.attributedText mutableCopy];
        [addressTextAttributedString.mutableString setString:addressText];
        cellView.addressText.attributedText = addressTextAttributedString;
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @" ";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
    }
    if ([cellType isEqualToString:@"LXHInputAmountCell"]) {
        LXHInputAmountCell *cellView = (LXHInputAmountCell *)view;
        NSString *BTC = [dataForRow valueForKey:@"BTC"];
        if (!BTC)
            BTC = @" ";
        NSMutableAttributedString *BTCAttributedString = [cellView.BTC.attributedText mutableCopy];
        [BTCAttributedString.mutableString setString:BTC];
        cellView.BTC.attributedText = BTCAttributedString;
        NSString *maxValue = [dataForRow valueForKey:@"maxValue"];
        if (!maxValue)
            maxValue = @" ";
        NSMutableAttributedString *maxValueAttributedString = [cellView.maxValue.attributedText mutableCopy];
        [maxValueAttributedString.mutableString setString:maxValue];
        cellView.maxValue.attributedText = maxValueAttributedString;
        cellView.maxValue.hidden = [[dataForRow valueForKey:@"maxValueHidden"] boolValue];
        
        NSString *text = [dataForRow valueForKey:@"text"];
        if (!text)
            text = @" ";
        NSMutableAttributedString *textAttributedString = [cellView.text.attributedText mutableCopy];
        [textAttributedString.mutableString setString:text];
        cellView.text.attributedText = textAttributedString;
        NSString *text1 = [dataForRow valueForKey:@"text1"];
        if (!text1)
            text1 = @" ";
        NSMutableAttributedString *text1AttributedString = [cellView.text1.attributedText mutableCopy];
        [text1AttributedString.mutableString setString:text1];
        cellView.text1.attributedText = text1AttributedString;
        cellView.textButton.tag = indexPath.row;
        [cellView.textButton addTarget:self action:@selector(LXHInputAmountCellTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.textButton addTarget:self action:@selector(LXHInputAmountCellTextButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cellView.textButton addTarget:self action:@selector(LXHInputAmountCellTextButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        cellView.textButton.hidden = [[dataForRow valueForKey:@"textButtonHidden"] boolValue];
        
        _textField = cellView.textFieldWithPlaceHolder;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.text = [dataForRow valueForKey:@"textFieldText"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self tableView:tableView cellTypeAtIndexPath:indexPath];
    if (tableView == self.contentView.listView) {
        if ([cellType isEqualToString:@"LXHTopLineCell"])
            return 0.5;
        if ([cellType isEqualToString:@"LXHInputAddressCell"])
            return 50;
        if ([cellType isEqualToString:@"LXHInputAmountCell"])
            return 60;
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
        case 1:
            [self showSettingAddressSheet];
            break;
        default:
            break;
    }
}

- (void)showSettingAddressSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    LXHWeakSelf
    UIAlertAction *pasteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"粘贴地址", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = [UIPasteboard generalPasteboard].string;
        if ([weakSelf.viewModel setBase58AddressOrUrl:text]) {
            [weakSelf refreshListView];
        } else {
            [weakSelf.view makeToast:NSLocalizedString(@"不支持该地址或地址附带的比特币数量无效", nil)];
        }
    }];
    
    UIAlertAction *scanAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"扫描二维码", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *controller = [[LXHScanQRViewController alloc] initWithDetectionBlock:^(NSString *text) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if ([weakSelf.viewModel setBase58AddressOrUrl:text]) {
                [weakSelf refreshListView];
            } else {
                [weakSelf.view makeToast:NSLocalizedString(@"不支持该地址或地址附带的比特币数量无效", nil)];
            }
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    UIAlertAction *selectAddressAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"选择本地地址", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id viewModel = [[LXHAddressListForSelectionViewModel alloc] init];
        LXHAddressListViewController *controller = [[LXHAddressListViewController alloc] initWithViewModel:viewModel];
        controller.addressSelectedCallback = ^(LXHAddress *localAddress) {
            [weakSelf.viewModel setAddress:localAddress];
            [weakSelf refreshListView];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:pasteAction];
    [alertController addAction:scanAction];
    [alertController addAction:selectAddressAction];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textFieldEditingChanged:(UITextField *)textField {//用户手动编辑时会触发
    [_viewModel setTempText:textField.text];
}

@end
