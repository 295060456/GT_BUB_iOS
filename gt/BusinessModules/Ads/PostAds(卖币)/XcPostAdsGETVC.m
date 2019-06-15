//
//  XcPostAdsGETVC.m
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsGETVC.h"
#import "XcPostAdsTableViewCell.h"

@interface XcPostAdsGETVC ()
@property (weak, nonatomic) IBOutlet UILabel *tips2;
@property (weak, nonatomic) IBOutlet UITextField *sellNumber;
@property (weak, nonatomic) IBOutlet UILabel *tips3;
@property (weak, nonatomic) IBOutlet UITextField *minute;

@property (weak, nonatomic) IBOutlet UIButton *autonym;
@property (weak, nonatomic) IBOutlet UIButton *highAutonym;
@property (weak, nonatomic) IBOutlet UIImageView *autonymImage;
@property (weak, nonatomic) IBOutlet UIImageView *highAutonymImg;
@end

@implementation XcPostAdsGETVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModelRequest];
}

- (void)bindViewModelRequest{
    @weakify(self)
    [RACObserve(self.viewModel, adsModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    RACChannelTo(self.viewModel,sellNumberString) = RACChannelTo(self.sellNumber,text);
    RAC(self.tips2,text) = self.viewModel.mslJudge;
    RAC(self.tips2,textColor) = RACObserve(self.viewModel, tips2Color);
    
    RACChannelTo(self.viewModel,minuteString) = RACChannelTo(self.minute,text);
    RAC(self.tips3,text) = self.viewModel.timeJudge;
    RAC(self.tips3,textColor) = RACObserve(self.viewModel, tips3Color);
    
    [RACObserve(self.viewModel, myAccs) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    /* 买家条件限制
     */
    [[self.autonym rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel upBuyerAstrict:self.autonym :self.autonymImage :self.highAutonym :self.highAutonymImg :YES];
    }];
    
    [[self.highAutonym rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel upBuyerAstrict:self.autonym :self.autonymImage :self.highAutonym :self.highAutonymImg :NO];
    }];
    
    if (self.viewModel.requestParams) {
        self.viewModel.requestParams = self.viewModel.requestParams;
        [self.viewModel upBuyerAstrict:self.autonym :self.autonymImage :self.highAutonym :self.highAutonymImg :[self.viewModel.requestParams.isSeniorCertification isEqualToString:@"2"]];
    }
}

- (XcPostAdsGEViewModel *)viewModel{
    if (!_viewModel) { _viewModel = XcPostAdsGEViewModel.new;}
    return _viewModel;
}

- (IBAction)showAlertView:(UIButton *)sender {
    if (self.viewModel.alertBlock) {
        self.viewModel.alertBlock(2);
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        NSArray *list = [self.viewModel.adsModel.price componentsSeparatedByString:@","];        
        return (ceil(list.count/4)+1)*XcPostAdsTableViewCell_GE_HEIGHT;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1) {
        static NSString *identifier = @"XcPostAdsTableViewCell";
        XcPostAdsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[XcPostAdsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.fixedAmount = self.viewModel.fixedAmount;
        cell.price = self.viewModel.adsModel.price;
        
        @weakify(self)
        cell.block = ^(id data) {
            @strongify(self)
            self.viewModel.fixedAmount = data;
            [self.view endEditing:NO];
        };
        
        return cell;
    } else if (indexPath.row==4){
        @weakify(self)
        XcPostAdsTableViewCell *cell = (XcPostAdsTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.type = TransactionAmountTypeFixed;
        cell.datas = self.viewModel.myAccs;
        cell.block = ^(id data) {
            @strongify(self)
            [self.view endEditing:NO];
            [self showAlertView:nil];
        };
        self.viewModel.reloadDataView = ^{
            [cell reloadDataView];
        };
        return cell;
    }
    else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (NSDictionary *)parameter2{
    [self.view endEditing:NO];
    if (![[self.tips2 textColor] isEqual:RGBCOLOR(140, 150, 165)]) {Toast(@"请输入正确的卖出数量");return nil;}
    if (self.tips3.text.length>0) {Toast(@"请输入正确的收款时间");return nil;}
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"limitMaxAmount"];
    [dic setObject:@"" forKey:@"limitMinAmount"];
    if ([dic setObject:self.viewModel.fixedAmount forKey:@"fixedAmount" toast:@"单笔固额"]) return nil;//固额
    if ([dic setObject:self.viewModel.sellNumberString forKey:@"number" toast:@"卖出数量"]) {return nil;}
    if ([dic setObject:self.viewModel.minuteString forKey:@"prompt" toast:@"收款时间"]) {return nil;}
    
    NSMutableString *pamentWay = [NSMutableString string];
    for (AccountPaymentWayModel *miniModel in singLeton.chooseModelAr2) {
        if (pamentWay.length>0) {
            [pamentWay appendString:@","];
        }
        [pamentWay appendString:miniModel.paymentWayId];
    }
    if ([dic setObject:pamentWay forKey:@"pamentWay" toast:@"收款方式"]) {return nil;}
    
    [dic setObject:self.autonym.selected?@"1":@"2" forKey:@"isIdNumber"];
    [dic setObject:self.highAutonym.selected?@"1":@"2" forKey:@"isSeniorCertification"];
    [dic setObject:@"2" forKey:@"amountType"];
    return dic;
}
@end
