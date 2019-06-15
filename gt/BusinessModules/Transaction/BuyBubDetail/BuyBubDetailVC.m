//
//  BuyBubDetailVC.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

//typedef NS_ENUM(NSUInteger,UserType){
//    UserTypeNone = 0 ,
//
//    UserTypeBuyer  , // 买家
//    UserTypeSeller   // 买家
//};

#import "BuyBubDetailVC.h"
#import "BuyBubDetailBuyView.h"
#import "OrderDetailModel.h"
#import "BuyBubDetailModel.h"
#import "OrderDetailVM.h"
#import "PostAppealVC.h"
#import "AssetsVC.h"
#import "ScanCodeVC.h"
#import "OrderDetailModel.h" // 没办法目前就这样衔接吧
#import "InputPWPopUpView.h"
#import "PayVM.h"
#import "CancelTipPopUpView.h"

@interface BuyBubDetailVC ()
@property(nonatomic, strong) NSString  *requestParamsID;
@property(nonatomic, strong) BuyBubDetailModel *myData;
@property(nonatomic ,strong) OrderDetailModel *orderDetailModel;
@property(nonatomic ,strong) OrderDetailVM *vm;
@property(nonatomic ,strong) BuyBubDetailBuyView  *buyView;   // 买家角色布局
@end

@implementation BuyBubDetailVC

+ (instancetype)pushFromVC:(UINavigationController *)naVC
             requestParams:( id )orderNO
                   success:(DataBlock)block{
    BuyBubDetailVC *vc = [[BuyBubDetailVC alloc] init];
    vc.requestParamsID = orderNO;
    [naVC pushViewController:vc animated:true];
    return vc;
}

-(OrderDetailVM*)vm{
    if (_vm == nil) {
        _vm = [[OrderDetailVM alloc] init];
    } return _vm;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getNewData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    kWeakSelf(self);
    self.buyView = [[BuyBubDetailBuyView alloc] initWithFrame:self.view.bounds actionBlock:^(NSInteger types, id data) {
        [weakself mainViewTapActionWtth:types andData:data];
    }];
    [self.view addSubview:self.buyView];
    [self.buyView reloadTableViewDataWith:nil andHeaderTitleAr:nil];
}

-(void)reloadViewWithData{
    
    NSArray *ar = nil;
    if (self.myData.userTpye == UserTypeSeller) { // 自己就是卖家
        self.title = @"卖币";
        ar = @[@"买家下单",@"买家付款",@"放行订单",@"交易完成"];
    }else if (self.myData.userTpye == UserTypeBuyer){
        self.title = @"买币";
        ar = @[@"提交订单",@"向卖家转账",@"等待放行",@"交易完成"];
    }else{}
    [self.buyView reloadTableViewDataWith:self.myData andHeaderTitleAr:ar]; // 刷新
}

-(void)mainViewTapActionWtth:(BuyTapType) type andData:(id)data{  // 界面点击事件
    NSLog(@"-- %ld  %@",type,data);
    switch (type) {
        case BuyTapTypeToOrthApp: //  data   1 微信  2 支付宝
            [self toWeiXingOrZFBApp:(NSInteger)data];
            break;
        case BuyTapTypeContactOther: // 联系对方
            [self pushContactEvent];
            break;
        case BuyTapTypeTimeReloadDa: // 刷新数据
            [self getNewData];
            break;
        case BuyTapTypeCancelOrders: // 取消订单
            [self cancelOrdersWithOrdesNO:data];
            break;
        case BuyTapTypeToAppeal: // 去申诉
            [self pushAppealVC];
            break;
        case BuyTapTypeSellReleaseOrders: // 卖家确认收款，放行订单
            [self sellSuerOrderPay];
            break;
        case BuyTapTypeSeeMyaSsets: // 查看资产
            [self toSeeMyAssets];
            break;
        case BuyTapTypeSeeToConsumption: // 消费
            [ScanCodeVC pushFromVC:self];
            break;
        case BuyTapTypeCloseAppeal: // 取消申诉
            [self closeAppeal];
            break;
        case BuyTapTypeBuyRelease: // 买家确认已付款
            [self buyRelease];
            break;
        default:
            break;
    }
}

-(void)cancelOrdersWithOrdesNO:(NSString*)orderNO{ // 取消订单
    
    
    
    CancelTipPopUpView *popupView = [[CancelTipPopUpView alloc]init];
    
    [popupView showInApplicationKeyWindow];
    [popupView richElementsInViewWithModel:Nil];
    kWeakSelf(self);
    [popupView actionBlock:^(id data) {
        kStrongSelf(self);
        NSDictionary *params = @{@"orderNo": orderNO};
        [SVProgressHUD showWithStatus:@"加载中..." ];
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionCancelPay]
                                                         andType:All
                                                         andWith:params
                                                         success:^(NSDictionary *dic) {
                                                             [SVProgressHUD dismiss];
                                                             [self  getNewData];
                                                         } error:^(NSError *error) {
                                                             [SVProgressHUD dismiss];
                                                             [YKToastView showToastText:error.description];
                                                         }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayStopTimeRefresh
                                                            object:nil];
    }];

}

-(void)toWeiXingOrZFBApp:(NSInteger)type{  //   1 微信  2 支付宝
    if (type == 1) {
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        //先判断是否能打开该url
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:^(BOOL success) {}];
        }else {
            [YKToastView showToastText:@"没安装微信，怎么打开啊！"];
        }
    }else if (type == 2){
        NSString *zfbcode = self.myData.payQrUrls;
        NSURL *url = [NSURL URLWithString:@"alipay://"];
        NSURL *openurl = [NSURL URLWithString:[NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&&qrcode=%@",zfbcode]];
        //先判断是否能打开该url
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:openurl
                                               options:@{}
                                     completionHandler:^(BOOL success) { }];
        }else {
            [YKToastView showToastText:@"没安装支付宝，怎么打开啊！"];
        }
    }
}
-(void)pushContactEvent{ // 聊天界面
    NSString *sessionId;
    NSString *title;
    if (self.myData.userTpye == UserTypeSeller) { // 自己是卖家
        sessionId = self.myData.buyUserId;
        title = self.myData.buyerName;
    }else{ // 自己是买家
        sessionId = self.myData.sellUserId;
        title = self.myData.sellerName;
    }
    [RongCloudManager updateNickName:title userId:sessionId];
    [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
}

-(void)pushAppealVC{
    
    [PostAppealVC pushViewController:self
                       requestParams:self.myData.orderNo
                           orderType:[self.orderDetailModel getTransactionOrderType]
                        isAntiAppeal:NO
                              reason:nil
                             success:^(id data) {}];
}
-(void)toSeeMyAssets{
    [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {}];
}
-(void)closeAppeal{ // 取消胜诉
    kWeakSelf(self);
    if (!HandleStringIsNull(self.myData.appealID)) {
        [YKToastView showToastText:@"获取数据有误"];
        return;
    }
    [self.vm network_cancelAppealWithRequestParams:self.myData.appealID success:^(id data) {
        [weakself getNewData];
    } failed:^(id data) {} error:^(id data) {}];
}

-(void)getNewData{
    if (!HandleStringIsNull(self.requestParamsID)) {
        [YKToastView showToastText:@"获取数据有误"];
        return;
    }
    kWeakSelf(self);
     [SVProgressHUD showWithStatus:@"发送中..."];
    [self.vm network_getOrderDetailWithRequestParams:self.requestParamsID  appealScheduleType:self.myData?self.myData.scheduleType:0 success:^(id data, id data2) {
        kStrongSelf(self);
        self.myData = data;
        self.orderDetailModel = data2;
        [self reloadViewWithData];
    } failed:^(id data) {} error:^(id data) {}];
}

-(void)sellSuerOrderPay{ // 卖家确认收款，放行订单
    InputPWPopUpView *inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero
                                                 WithIsForceShowGoogleCodeField:YES];
    [inputPWPopUpView showInApplicationKeyWindow];
    kWeakSelf(self);
    [inputPWPopUpView actionBlock:^(id data) {
        kStrongSelf(self);
        [self.vm network_transactionOrderSureDistributeWithCodeDic:data
                                                 WithRequestParams:self.myData.orderNo 
                                                           success:^(id data) {
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsStopTimeRefresh
                                                                                                                   object:nil];
                                                               [self getNewData];
                                                           } failed:^(id data) {} error:^(id data) {}];
    }];
}

-(void)buyRelease{
     InputPWPopUpView *inputPWPopUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero WithIsForceNoShowGoogleCodeField:YES];
    
    [inputPWPopUpView showInApplicationKeyWindow];
    kWeakSelf(self);
    [inputPWPopUpView actionBlock:^(id data) {
        kStrongSelf(self);
        NSDictionary *dics = data;
        [[PayVM new] network_confirmPayListWithRequestParams:self.orderDetailModel.orderNo//订单号
                                             WithPaymentWay:dics.allKeys[0]//支付密码
                                                    success:^(id data) {
                                                        [self getNewData];
                                                    }failed:^(id data) {}error:^(id data) {}];
        
    }];
}

@end
