//
//  BuyABViewController.m
//  OTC
//
//  Created by David on 2018/11/17.
//  Copyright © 2018年 yang peng. All rights reserved.
//

//#import "BuyHV.h"

#import "PaymentAccountVM.h"
#import "PayVM.h"
#import "Buy_CommitOrderVC.h"
#import "SecuritySettingVC.h"
#import "XcSecuritySettingsVC.h"
#import "TransactionModel.h"
#import "Buy_HeadTBVCell.h"
#import "Buy_CommitOrder_ContentTBVCell.h"
#import "Buy_NotifyTBVCell.h"
#import "PostAdsReplyCell.h"
#import "BaseCell.h"
#import "SubmitOrderPopView.h"
#import "OrderDetailModel.h"
#import "BuyBubDetailVC.h"
#import "TransactionVC.h"

@interface Buy_CommitOrderVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    TransactionData *itemData;
    
    SubmitOrderPopView *submitOrderPopView;
    
    LoginModel *userInfoModel;
}

@property(nonatomic,strong)TransactionData * requestParams;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)PaywayType paywayType;
@property(nonatomic,assign)PaywayOccurType paywayOccurType;
@property(nonatomic,copy)NSString *transactionAmountType;
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;
@property(nonatomic,assign)OrderType orderType;
@property (nonatomic, assign) SubmitOrderPopView *submitOrderPopViewTemp;
@end

@implementation Buy_CommitOrderVC

#pragma mark - life cycle

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
 withTransactionAmountType:(NSString *)transactionAmountType
           paywayOccurType:(PaywayOccurType)paywayOccurType
                   success:(DataBlock)block{
    
    Buy_CommitOrderVC *vc = [[Buy_CommitOrderVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;//总数据
    
    vc.transactionAmountType = transactionAmountType;//限额 还是 固额
    
    vc.orderDetailModel = requestParams;
    
    vc.paywayOccurType = paywayOccurType;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    
    return vc;
}

-(void)dealloc{
    
//    NSLog(@"%s",__FUNCTION__);
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    self.orderType = BuyerOrderTypeAllPay;
    
    SetUserDefaultKeyWithObject(@"orderType", @(self.orderType));
    
    UserDefaultSynchronize;
    
    self.title = @"买币";
    
    [self initView];
}

-(void)initView{

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);
    }];
}

-(TransactionAmountType)choiceTransactionAmountType{
    
    TransactionData* itemData = self.requestParams;
    
    switch ([itemData.amountType intValue]) {//金额类型 : 1、限额 2、固额
        case 1:
            return TransactionAmountTypeLimit;//单笔限额
            break;
        case 2:
            return TransactionAmountTypeFixed;//单笔固额
            break;
            
        default:
            break;
    }
    
    return TransactionAmountTypeNone;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            
            return [Buy_HeadTBVCell cellHeightWithModel:NULL];
        }
            break;
        case 1:{
            
            NSDictionary *dic = @{
                                  @"TransactionAmountType":self.transactionAmountType
                                  };
            
            return [Buy_CommitOrder_ContentTBVCell cellHeightWithModel:dic];
        }
            break;
        case 2:{
            
            return [Buy_NotifyTBVCell cellHeightWithModel:NULL];
        }
            break;
        default:
            
            return 0.0f;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(NSString *)surplusPurchasableNumData{
    
//金额类型 : 1、限额 2、固额
    switch ([itemData.amountType intValue]) {
        case 1:
            
            return [NSString stringWithFormat:@"%@ BUB",itemData.balance];
            break;
        case 2:
            
            return [NSString stringWithFormat:@"%@ BUB",itemData.fixedAmount];
            break;
            
        default:
            
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
            NSDictionary *dataDic = @{
                                      @"userType":userInfoModel.userinfo.userType,
                                      @"orderDetailModel":self.orderDetailModel,
                                      @"orderType":@(self.orderType)
                                      };
            
            Buy_HeadTBVCell *cell = [Buy_HeadTBVCell cellWith:tableView With:dataDic];
            
            return cell;
        }
            break;
        case 1:{
            
            itemData = self.requestParams;
            
            NSDictionary *dataDic = @{
                                      @"TransactionAmountType":@([self choiceTransactionAmountType]),
                                      @"Paymentway":itemData.paymentway,
                                      @"NickName":itemData.nickName,
                                      @"OrderAllNumber":[NSString stringWithFormat:@"交易量:%@",itemData.orderAllNumber],
                                      @"SuccessRate":[NSString stringWithFormat:@"成功率:%@",itemData.successRate],
                                      @"SurplusPurchasableNumStr":[self surplusPurchasableNumData],
                                      @"OncePurchasableNumStr":[NSString stringWithFormat:@"¥%@ ~¥%@",itemData.limitMinAmount,itemData.limitMaxAmount],
                                      @"UnitPriceStr":[NSString stringWithFormat:@"¥%0.2f",[itemData.price floatValue]],
                                      @"Prompt":self.orderDetailModel.prompt
                                      };
            
            Buy_CommitOrder_ContentTBVCell *cell = [Buy_CommitOrder_ContentTBVCell cellWith:tableView];
            
            [cell richElementsInCellWithModel:dataDic];
            
            //        NSLog(@"itemData.userId = %@",itemData.userId);
            
            return cell;
        }
            break;
        case 2:{
            
            Buy_NotifyTBVCell *cell = [Buy_NotifyTBVCell cellWith:tableView];
            
            [cell richElementsInCellWithModel:NULL];
            
            kWeakSelf(self);
            
            [cell actionBlock:^(id data) {
                
                kStrongSelf(self);
                
                if (![self isCommitOrder]) return;
                
                //推出弹窗
                if ([self.transactionAmountType isEqualToString:@"1"]) {//限额
                    
                    self->submitOrderPopView = [[SubmitOrderPopView alloc]initWithPaymentWay:self->itemData.paymentway
                                                                                  QuotaStyle:TransactionAmountTypeLimit];
                }else if ([self.transactionAmountType isEqualToString:@"2"]){//固额
                    
                    self->submitOrderPopView = [[SubmitOrderPopView alloc]initWithPaymentWay:self->itemData.paymentway
                                                                                  QuotaStyle:TransactionAmountTypeFixed];
                }
                self.submitOrderPopViewTemp = self->submitOrderPopView;
                RAC(self,paywayType) = RACObserve(self.submitOrderPopViewTemp, paymentStyle);
                
                self->submitOrderPopView.quotaStr = [NSString stringWithFormat:@"¥%@ ~¥%@",[NSString isEmpty:self->itemData.limitMinAmount]?@"?":self->itemData.limitMinAmount,[NSString isEmpty:self->itemData.limitMaxAmount]?@"?":self->itemData.limitMaxAmount];
                
                self->submitOrderPopView.remainingStr = [NSString stringWithFormat:@"%@ BUB",[NSString isEmpty:self->itemData.balance]?@"?":self->itemData.balance];
                
                self->submitOrderPopView.fixedAmountStr = [NSString isEmpty:self->itemData.fixedAmount]?@"?":self->itemData.fixedAmount;
                
                [self->submitOrderPopView showInApplicationKeyWindow];
                
                kWeakSelf(self);
                
                self->submitOrderPopView.MyBlock = ^{
                    
                    kStrongSelf(self);
                    
                    if ([self->itemData.amountType isEqualToString:@"1"]) {//限额
                        
                        if (![NSString isEmpty:self->submitOrderPopView.leftTextField.text]){
                            
                            int my = [self->submitOrderPopView.leftTextField.text intValue];
                            
                            int minOnce = [self->itemData.limitMinAmount intValue];//单次购买最小值
                            
                            int maxOnce = [self->itemData.limitMaxAmount intValue];//单次购买最大值
                            
                            int remaining = [self->itemData.balance intValue];//剩余可购买数量
                            
                            if (my < minOnce) {
                                //弹出限额标示
                                //小于最小交易额度
                                
                                [self->submitOrderPopView showWarning:MoreOrLessOnce_less];
                                
                            }else if (my > maxOnce){
                                //弹出限额标示
                                //大于最大交易额度
                                
                                [self->submitOrderPopView showWarning:MoreOrLessOnce_more];
                            }else if (my > remaining){
                                //
                                [self->submitOrderPopView showWarning:MoreOrLessRemain];
                            }else{
                                //正常的 可以放行
                                [self->submitOrderPopView resignFirstResponder];
                                
                                //进行网络请求获取订单的情况
                                [PayVM.new network_postPayListWithPage:1
                                                     WithRequestParams:@{
                                                                         @"ugOtcAdvertId":self->itemData.ugOtcAdvertId,//广告ID
                                                                         @"number":self->submitOrderPopView.leftTextField.text,//购买数量
                                                                         @"paymentWay":[self paymentWay:self.paywayType],//支付方式 (1、微信;2、支付宝;3、银行卡)
                                                                         @"remark":@""//备注
                                                                         }
                                                               success:^(id data2) {
                                                                   [self->submitOrderPopView disMissView];
                                                                   @weakify(self)
                                                                   [[RACScheduler mainThreadScheduler]afterDelay:.4 schedule:^{
                                                                       @strongify(self)
                                                                       UINavigationController *nv = self.navigationController;
                                                                       [self.navigationController popViewControllerAnimated:NO];
                                                                       OrderDetailModel *mo = data2;
                                                                       [BuyBubDetailVC pushFromVC:nv requestParams:mo.orderNo?mo.orderNo:mo.orderId success:^(id data) {}];
                                                                       
                                                                   }];
                                                               }
                                                                failed:^(id data) {
                                                                    
//                                                                    NSLog(@"failed_%@",data);
                                                                    
                                                                    if ([data isKindOfClass:[NSDictionary class]]) {
                                                                        
                                                                        [SVProgressHUD showWithStatus:(NSString *)data[@"msg"]];
                                                                        
                                                                        [self performSelector:@selector(SVProgressHUD_Dismiss)
                                                                                   withObject:nil
                                                                                   afterDelay:1.7];
                                                                    }
                                                                }
                                                                 error:^(id data) {
                                                                     
//                                                                     NSLog(@"error_%@",data);
                                                                 }];
                            }
                        }
                    }else if ([self->itemData.amountType isEqualToString:@"2"]){//固额
                        
                        [PayVM.new network_postPayListWithPage:1
                                             WithRequestParams:@{
                                                                 @"ugOtcAdvertId":self->itemData.ugOtcAdvertId,//广告ID
                                                                 @"number":self->itemData.fixedAmount,//购买数量
                                                                 @"paymentWay":[self paymentWay:self.paywayType],//支付方式 (1、微信;2、支付宝;3、银行卡)
                                                                 @"remark":@""//备注
                                                                 }
                                                       success:^(id data2) {
                                                           [self->submitOrderPopView disMissView];
                                                           
                                                           @weakify(self)
                                                           [[RACScheduler mainThreadScheduler]afterDelay:.4 schedule:^{
                                                               @strongify(self)
//                                                               if (lietVC) {
                                                               UINavigationController *nv = self.navigationController;
                                                                   [self.navigationController popViewControllerAnimated:NO];
                                                               OrderDetailModel *mo = data2;
                                                               [BuyBubDetailVC pushFromVC:nv requestParams:mo.orderNo?mo.orderNo:mo.orderId success:^(id data) {}];
//                                                               
                                                           }];
                                                       }
                                                        failed:^(id data) { 
                                                            
//                                                            NSLog(@"failed_%@",data);
                                                            
                                                            if ([data isKindOfClass:[NSDictionary class]]) {
                                                                
                                                                self->submitOrderPopView.fixedAmountMsg = data[@"msg"];
                                                            }
                                                        }
                                                         error:^(id data) {
                                                             
//                                                             NSLog(@"error_%@",data);
                                                         }];
                    }
                };
                
                [self->submitOrderPopView actionBlock:^(id data) {
                    
                    //                    kStrongSelf(self);
                }];
            }];
            
            return cell;
        }
            break;
        default:
            
            return UITableViewCell.new;
            
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
    }else {
        
        return 10 * SCALING_RATIO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = UIView.new;
    
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    return view;
}

-(NSString *)paymentWay:(PaywayType)paywayType{
    
    switch (paywayType) {
        case PaywayTypeWX:
            return @"1";
            break;
        case PaywayTypeZFB:
            return @"2";
            break;
        case PaywayTypeCard:
            return @"3";
            break;
            
        default:
            break;
    }
    
    return @"";
}

-(BOOL)isCommitOrder{
    
    LoginModel *model = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    LoginData *loginData = model.userinfo;
    
    if (loginData.istrpwd && [loginData.istrpwd isEqualToString:@"1"]) { //

        return YES;
        
    }else{ // 去设置交易密码

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲，您还未设置交易密码哦"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"稍后设置"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"现在去设置"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {

            [XcSecuritySettingsVC pushFromVC:self
                               requestParams:@1
                                     success:^(id data) {
                
            }];
        }]];
        
        [self presentViewController:alert
                           animated:true
                         completion:nil];
        
        return NO;
    }
}

#pragma mark - lazyload
-(UITableView *)tableView{

    if (!_tableView) {

        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];

        _tableView.dataSource = self;

        _tableView.delegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.tableFooterView = UIView.new;
    }

    return _tableView;
}

-(void)actionBlock:(ActionBlock)block{
    
    self.block = block;
}

-(void)SVProgressHUD_Dismiss{
    
    [SVProgressHUD dismiss];
}

@end
