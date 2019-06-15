//
//  AppealProgressVC.m
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealProgressVC.h"
#import "AppealProgressView.h"
#import "AppealProgressVM.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "PostAppealVC.h"

@interface AppealProgressVC ()
@property(nonatomic,strong)id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) AppealProgressView *mainView;
@property (nonatomic, strong) MWPhotoBrowser *potoBrowesr;

@end

@implementation AppealProgressVC
+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                           success:(DataBlock)block{
    AppealProgressVC *vc = [[AppealProgressVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc
                                           animated:YES];
    return vc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"交易申诉";

    kWeakSelf(self);
    self.mainView = [[AppealProgressView alloc] initWithBlockSuccess:^(NSInteger types, id data) {
        [weakself buttomTapAction:types andData:data];
    }];
    [self.view addSubview:self.mainView];
     [self getData];
}

-(void)getData{
    kWeakSelf(self);
    [AppealProgressVM getPostAppealCompleteDataWithRequestParams:self.requestParams success:^(id data) {
        [weakself.mainView layoutView: data];
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}




//    progressExamImageType = 0,   // 查看凭证  不t跳
//    progressContactSellers  , // 联系卖家
//    progressContactBuyer,  // 联系买家
//    progressGotoAppeal, //去申诉  反驳申诉  --
//    progressCancelAppeal,  // 取消申诉       不t跳
//    progressReleaseBUB,  // 放行BUB   ---》认同申诉原因     不t跳
//   progressContactOrder,  // 取消订单      不t跳
//   progressZZToAppeal, //我已转账,我要申诉 ---  反s申诉
//   progressNotReceived, // 未收到汇款   卖家原因超时--》去反申诉  2.买家忘记点击付款  --》去关闭订单
//    progressQXFAppeal //您已发起反申诉，点击取消  --- 取消反申诉

-(void)buttomTapAction:(NSInteger)types andData:(id)data{
    AppealProgressModel *mo = data;
    switch (types) {
        case progressExamImageType: //查看凭证  不t跳
        {
            [self progressExamImage:data];
        } break;
        case progressContactSellers: // 联系卖家
        {
            [self pushMsgVC:mo];
        } break;
        case progressContactBuyer: // 联系买家
        {
            [self pushMsgVC:mo];
        } break;
        case progressGotoSellerAppeal: //去申诉  反驳申诉  --
        {
            [self gotoAppealVC:mo anReason:@"被申诉未放行订单"];
            
        } break;
        case progressCancelAppeal: // 取消申诉       不t跳
        {
            [self cancelAppeal:mo.appealId];
            
        } break;
        case progressReleaseBUB: // 放行BUB   ---》认同申诉原因     不t跳
        {
            [self toAgreeAppeal:mo.appealId];
        } break;
        case progressContactOrder: // 取消订单      不t跳
        {
            [self relesOrder:mo.orderId? mo.orderId : mo.orderNo];
        } break;
        case progressZZToAppeal: //我已转账,我要申诉 ---  反s申诉
        {
            [self gotoAppealVC:mo anReason:@"被申诉未转帐，但点击确认付款"];
        } break;
        case progressNotReceived: // 未收到汇款   卖家原因超时--》去反申诉  2.买家忘记点击付款  --》去关闭订单
        {
            [self notReceived:mo];
        } break;
        case progressQXFAppeal:  //您已发起反申诉，点击取消  --- 取消反申诉
        {
            [self cancelAntiAppeal:mo.appealId];
        } break;
        default:
            break;
    }
}

#pragma 逻辑跳转

-(void)progressExamImage:(NSArray*)ar{
    if (ar && ar.count > 0) {
        NSDictionary *dic = ar[0];
        NSString *urlS = dic[@"voucherUrl"];
        if (urlS && urlS.length > 1) {
            MWPhoto *po = [MWPhoto photoWithURL:[NSURL URLWithString:urlS]];
            NSArray *ar = @[po];
            _potoBrowesr = [[MWPhotoBrowser alloc] initWithPhotos:ar];
            _potoBrowesr.displayActionButton = NO;
            [self.navigationController pushViewController:_potoBrowesr animated:YES];
            [self performSelector:@selector(toChengColer) withObject:nil afterDelay:0.3];
        }
    }
}

-(void)cancelAppeal:(NSString*)appealID{ // 取消申诉
    
    if (appealID == nil) {
        [YKToastView showToastText:@"申述ID缺失"];
        return;
    }
    NSDictionary *params = @{
                             @"appealId": appealID
                             };
    [SVProgressHUD showWithStatus:@"发送数据中..."];
    
//    WS(weakSelf);
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CancelAppeal]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         NSString *codeS = dic[@"errcode"];
                                                         [SVProgressHUD dismiss];
                                                         if ([codeS isEqualToString:@"1"]) {
                                                             [weakself getData];
                                                         }else{
                                                             [YKToastView showToastText:dic[@"msg"]];
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                        
                                                     }];
}

-(void)gotoAppealVC:(AppealProgressModel*)mo anReason:(NSString*)re{

    NSString *appealId = mo.appealId;
    kWeakSelf(self);
    [PostAppealVC pushViewController:self
                       requestParams:appealId
                           orderType:[mo getTransactionOrderType]
                      isAntiAppeal:YES
                               reason:re
                             success:^(id data) {
                                 [weakself getData];
                             }];
}

-(void)relesOrder:(NSString*)orderID{
  
    if (orderID == nil) {
        [YKToastView showToastText:@"参数有误，请重新加载页面"];
        return;
    }
    NSDictionary *params = @{
                             @"orderNo": orderID
                             
                             };

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionCancelPay]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         NSString *code = dic[@"errcode"];
                                                         if ([code isEqualToString:@"1"]) {
                                                             [weakself getData];
                                                         }else{
                                                             [YKToastView showToastText:dic[@"msg"]];
                                                         }
                                                         
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         
                                                     }];
}

-(void)toAgreeAppeal:(NSString*)appealID{
    
    if (appealID == nil) {
        [YKToastView showToastText:@"申述ID缺失"];
        return;
    }
    NSDictionary *params = @{
                             @"appealId": appealID
                             };
    [SVProgressHUD showWithStatus:@"发送数据中..." maskType:SVProgressHUDMaskTypeNone];
    
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealAgree]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         
                                                         [weakself getData];
                                                         
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         
                                                     }];
}

-(void)pushMsgVC:(AppealProgressModel*)mo{
    if (mo) {
        NSString *sessionId;
        
        NSString *title;
        
        LoginModel *userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        
        if ([mo.sellUserId isEqualToString:userInfoModel.userinfo.userid]){
            
            sessionId = mo.buyUserId;
            
            title = mo.buyerName;
        }else{
            
            sessionId = mo.sellUserId;
            
            title = mo.sellerName;
        }
        [RongCloudManager updateNickName:title
                                  userId:sessionId];
        
        [RongCloudManager jumpNewSessionWithSessionId:sessionId
                                                title:title
                                         navigationVC:self.navigationController];
    }
    
}

-(void)toChengColer{
    if (_potoBrowesr) {
        _potoBrowesr.navigationController.navigationBar.barTintColor = kWhiteColor;
         [YBSystemTool modifyNavigationBarWith:_potoBrowesr.navigationController];
        _potoBrowesr.title = @"交易申诉";
    }
}

-(void)notReceived:(AppealProgressModel*)mo{  // 未收到汇款   卖家原因超时--》去反申诉  2.买家忘记点击付款
    if ([mo.reason isEqualToString:@"1_B_1_2"] || [mo.reason isEqualToString:@"0_B_1_2"]) { //
        [self gotoAppealVC:mo anReason:@"被申诉未放行订单"];
    }else if ([mo.reason isEqualToString:@"2_B_1_5"]){ // --》去关闭订单
        
        NSString * appealID = mo.appealId;
        if (appealID == nil) {
            [YKToastView showToastText:@"参数有误，请重新加载页面"];
            return;
        }
        NSDictionary *params = @{
                                 @"appealId": appealID
                                 };
        
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
        
        kWeakSelf(self);
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealAnti]
                                                         andType:All
                                                         andWith:params
                                                         success:^(NSDictionary *dic) {
                                                             
                                                             [SVProgressHUD dismiss];
                                                             
                                                             [weakself getData];
                                                             
                                                         } error:^(NSError *error) {
                                                             [SVProgressHUD dismiss];
                                                             [YKToastView showToastText:error.description];
                                                             
                                                         }];
    }
    
    
}

-(void)cancelAntiAppeal:(NSString*)appealID{
    if (appealID == nil) {
        [YKToastView showToastText:@"参数有误，请重新加载页面"];
        return;
    }
    NSDictionary *params = @{
                             @"appealId": appealID
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealCancelAnti]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         
                                                         [weakself getData];
                                                         
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         
                                                     }];

}

@end
