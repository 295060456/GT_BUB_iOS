//
//  XcPostAdsXETVC.m
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsXETVC.h"
#import "XcPostAdsTableViewCell.h"

@interface XcPostAdsXETVC ()
@property (weak, nonatomic) IBOutlet UILabel *tips1;
@property (weak, nonatomic) IBOutlet UITextField *priceLow;
@property (weak, nonatomic) IBOutlet UITextField *priceHigh;

@property (weak, nonatomic) IBOutlet UILabel *tips2;
@property (weak, nonatomic) IBOutlet UITextField *sellNumber;
@property (weak, nonatomic) IBOutlet UILabel *tips3;
@property (weak, nonatomic) IBOutlet UITextField *minute;

@property (weak, nonatomic) IBOutlet UIButton *autonym;
@property (weak, nonatomic) IBOutlet UIButton *highAutonym;
@property (weak, nonatomic) IBOutlet UIImageView *autonymImage;
@property (weak, nonatomic) IBOutlet UIImageView *highAutonymImg;

@end

@implementation XcPostAdsXETVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModelRequest];
}

- (XcPostAdsXEViewModel *)viewModel{
    if (!_viewModel) { _viewModel = XcPostAdsXEViewModel.new;}
    return _viewModel;
}

- (void)bindViewModelRequest{
    @weakify(self)
    
    RACChannelTo(self.viewModel,priceLowString)  = RACChannelTo(self.priceLow,text);
    RACChannelTo(self.viewModel,priceHighString) = RACChannelTo(self.priceHigh,text);
    RAC(self.tips1,text)                         = self.viewModel.jyeJudgeText;

    RACChannelTo(self.viewModel,sellNumberString)    = RACChannelTo(self.sellNumber,text);
    RAC(self.tips2,text)                    = self.viewModel.mslJudge;
    RAC(self.tips2,textColor)               = RACObserve(self.viewModel, tips2Color);
    
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

- (IBAction)showAlertView:(UIButton *)sender {
    if (self.viewModel.alertBlock) {
        self.viewModel.alertBlock(1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==3){
        @weakify(self)
        XcPostAdsTableViewCell *cell = (XcPostAdsTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.type = TransactionAmountTypeLimit;
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

- (NSDictionary *)parameter1{
    [self.view endEditing:NO];
    if (self.tips1.text.length>0) {Toast(@"请输入正确的单笔限额");return nil;}
    if (![[self.tips2 textColor] isEqual:RGBCOLOR(140, 150, 165)]) {Toast(@"请输入正确的卖出数量");return nil;}
    if (self.tips3.text.length>0) {Toast(@"请输入正确的收款时间");return nil;}
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([dic setObject:self.viewModel.priceHighString forKey:@"limitMaxAmount" toast:@"最高价格"]) {return nil;}
    if ([dic setObject:self.viewModel.priceLowString forKey:@"limitMinAmount" toast:@"最低价格"]) {return nil;}
    if ([dic setObject:self.viewModel.sellNumberString forKey:@"number" toast:@"卖出数量"]) {return nil;}
    if ([dic setObject:self.viewModel.minuteString forKey:@"prompt" toast:@"收款时间"]) {return nil;}
    
    NSMutableString *pamentWay = [NSMutableString string];
    for (AccountPaymentWayModel *miniModel in singLeton.chooseModelAr1) {
        if (pamentWay.length>0) {
            [pamentWay appendString:@","];
        }
        [pamentWay appendString:miniModel.paymentWayId];
    }
    if ([dic setObject:pamentWay forKey:@"pamentWay" toast:@"收款方式"]) {return nil;}
    
    [dic setObject:self.autonym.selected?@"1":@"2" forKey:@"isIdNumber"];
    [dic setObject:self.highAutonym.selected?@"1":@"2" forKey:@"isSeniorCertification"];
    [dic setObject:@"1" forKey:@"amountType"];
    [dic setObject:@"" forKey:@"fixedAmount"];//固额
    return dic;
}
@end
