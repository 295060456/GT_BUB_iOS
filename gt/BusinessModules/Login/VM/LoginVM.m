//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "LoginVM.h"
#import "AboutUsModel.h"
#import "RongCloudManager.h"
#import <UserNotifications/UserNotifications.h>
@interface LoginVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) LoginModel* model;
@property (nonatomic,strong) AboutUsModel* aboutUsModel;
@property (nonatomic, strong) NSDictionary* requestParams;
@end

@implementation LoginVM

//- (void)network_rongCloudTemporaryTokenWithRequestParams:(id)requestParams
//                                                 success:(DataBlock)success
//                                                  failed:(DataBlock)failed
//                                                   error:(DataBlock)err{
//    
//    //    if (requestParams == nil) {
//    //
//    //        [YKToastView showToastText:@"缺失userID"];
//    //        return;
//    //    }
//    
//    NSDictionary* proDic = @{
//                             @"captchaValidate":requestParams
//                             };
//    
//    [SVProgressHUD showWithStatus:@"加载中..."
//                         maskType:SVProgressHUDMaskTypeNone];
//    
//    WS(weakSelf);
//    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_RongCloudTemporaryToken]
//                                                      andType:All
//                                                      andWith:proDic
//                                                      success:^(NSDictionary *dic) {
//                                                          
//                                                          [SVProgressHUD dismiss];
//                                                          
//                                                          if ([NSString getDataSuccessed:dic]) {
//                                                              
//                                                              self.model = [LoginModel mj_objectWithKeyValues:dic];
//                                                              
//                                                              success(weakSelf.model);
//                                                          }
//                                                          else{
//                                                              [YKToastView showToastText:self.model.msg];
//                                                              failed(weakSelf.model);
//                                                          }
//                                                      } error:^(NSError *error) {
//                                                          
//                                                          [SVProgressHUD dismiss];
//                                                          err(error);
//                                                          [YKToastView showToastText:error.description];
//                                                      }];
//}

- (void)network_rongCloudTokenWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err {
    NSDictionary* proDic =@{@"id":requestParams};
    [SVProgressHUD showWithStatus:@"加载中..." ];
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_RongCloudToken]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.model);
                                                         }else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}

- (void)network_getLoginWithRequestParams:(id)requestParams
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err {
    NSArray* model = requestParams;
    
    NSString* n =  model[0];
    NSString* p =  model[1];
    NSString* v =  model[2];
    
    NSDictionary* proDic =@{@"loginname":n,
                            @"pwd":p,
                            @"captchaValidate":v};
    
    proDic = [proDic vic_appendKey:@"registrationId" value:[JPUSHService registrationID]];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Login]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             [self network_rongCloudTokenWithRequestParams:self.model.userinfo.userid success:^(id data) {
                                                                 
                                                                 LoginModel* rcdata = [LoginModel mj_objectWithKeyValues:data];
                                                                 NSString* rcT = rcdata.rongyunToken!=nil?rcdata.rongyunToken:@"";
                                                                 [RongCloudManager loginWith:rcT success:^(NSString *userId) {
                                                                     //                    [UserManager defaultCenter].userInfo.rongyunToken = response.rongyunToken;
                                                                 } error:^(RCConnectErrorCode status) {
                                                                     
                                                                 } tokenIncorrect:^{
                                                                     
                                                                 }];
                                                             } failed:^(id data) {
                                                                 
                                                             } error:^(id data) {
                                                                 
                                                             }];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
                                                             if(![NSString isEmpty:self.model.msg]){
                                                                 [YKToastView showToastText:self.model.msg];
                                                             }
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                         
                                                         
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}


//获取验证码
-(void)network_gettingMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                         success:(DataBlock)success
                                                          failed:(DataBlock)failed
                                                           error:(DataBlock)err{
    
    NSArray *arr = requestParams != nil ? requestParams:@[@"",@""];
    
    NSString *n =  arr[0];
    NSString *p =  arr[1];
    
    NSDictionary *proDic =@{@"msgType":n,//* 枚举值:   1、用户注册验证码;  2、通用验证码发送 （短信内容没有个性化）
                            @"cellPhone":p};//区号 + 手机号
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SendMessageAuthenticationCode]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          
                                                          NSLog(@"dic = %@",dic);
                                                          
                                                          kStrongSelf(self);
                                                          self.model = [LoginModel mj_objectWithKeyValues:dic];

                                                          [SVProgressHUD dismiss];


                                                          if ([NSString getDataSuccessed:dic]) {

                                                              success(self.model);
                                                          }else{
                                                              [YKToastView showToastText:self.model.msg];
                                                              failed(self.model);
                                                          }
                                                      } error:^(NSError *error) {
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          [YKToastView showToastText:error.description];
                                                          
                                                          err(error);
                                                      }];
}


//校验短信验证码是否正确
-(void)network_CheckMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                       success:(DataBlock)success
                                                        failed:(DataBlock)failed
                                                         error:(DataBlock)err{
    
    NSArray *arr = requestParams != nil ? requestParams:@[@"",@""];
    
    NSString *n =  arr[0];
    NSString *p =  arr[1];
    
    NSDictionary *proDic =@{@"smsCode":n,// 短信验证码
                            @"phone":p};//区号 + 手机号
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChengeIphoneNumber]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
//                                                          NSString *str = [ApiConfig getAppApi:ApiType_CheckMessageAuthenticationCode];
//                                                          NSLog(@"%@",str);
                                                          NSLog(@"dic = %@",dic);
                                                          
                                                          kStrongSelf(self);
                                                          
                                                          self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          [YKToastView showToastText:self.model.msg];
                                                          
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              
                                                              success(self.model);
                                                          }else{
                                                              
                                                              failed(self.model);
                                                          }
                                                      } error:^(NSError *error) {
                                                          
                                                          //                                                         kStrongSelf(self);
                                                          
                                                          NSLog(@"error = %@",error);
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          [YKToastView showToastText:error.description];
                                                          
                                                          err(error);
                                                      }];
}


- (void)network_getLoginOutWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err {
    //    NSDictionary* model = requestParams;
    
    
    //    NSString* n =  model.allKeys[0];
    //    NSString* p =  model.allValues[0];
    //    @"loginname":n,@"pwd":p
    
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_LoginOut]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             SetUserBoolKeyWithObject(kIsLogin, NO);
                                                             
                                                             DeleUserDefaultWithKey(kUserInfo);
                                                             
                                                             UserDefaultSynchronize;
                                                             
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginOutRefresh object:nil];
                                                             
                                                             [JPUSHService setBadge:0];
                                                             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                                                             
                                                             if (@available(iOS 10.0, *)) {
                                                                 [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
                                                                 // To remove all pending notifications which are not delivered yet but scheduled.
                                                                 [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications]; // To remove all delivered notifications
                                                             } else {
                                                                 [[UIApplication sharedApplication] cancelAllLocalNotifications];
                                                             }
                                                             
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             failed(weakSelf.model);
                                                         }
                                                         [YKToastView showToastText:self.model.msg];
                                                         
                                                     } error:^(NSError *error) {
                                                         err(error);
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                     }];
    
}
- (void)network_changeLoginPWWithRequestParams:(id)requestParams
                               andIsGoogleCode:(BOOL)isGoogle
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {

    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@"",@"",@""];
    NSDictionary* proDic;
    if (isGoogle) {
        proDic =@{
                  @"oldpwd": req[0],
                  @"newpwd": req[1],
                  @"confirmpwd": req[2],
                  @"googlecode": req[3],
                  @"type": @"loginpwd"
                  };
    }else{
        proDic =@{
                  @"oldpwd": req[0],
                  @"newpwd": req[1],
                  @"confirmpwd": req[2],
                  @"smsCode": req[3],
                  @"type": @"loginpwd"
                  };
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeLoginPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:self.model.msg];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}
- (void)network_changeFundPWWithRequestParams:(id)requestParams
                              andIsGoogleCode:(BOOL)isGoogle
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err {
    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@"",@""];
    NSDictionary* proDic;
    if (isGoogle) {
        proDic =@{
                  @"newpwd": req[0],
                  @"confirmpwd": req[1],
                  @"googlecode": req[2],
                  @"type": @"tradepwd"
                  };
    }else{
        proDic =@{
                  @"newpwd": req[0],
                  @"confirmpwd": req[1],
                  @"smsCode": req[2],
                  @"type": @"tradepwd"
                  };
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeFundPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:self.model.msg];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}

- (void)network_settingFundPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {
    
    NSArray* req = requestParams !=nil?requestParams:@[@"",@""];
    NSDictionary* proDic =@{
                            //                            @"nickName": req[0],
                            @"pwd": req[0],
                            @"confirmpwd": req[1],
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SettingFundPW]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:self.model.msg];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}
- (void)network_inSecuritySettingCheckUserInfoWithRequestParams:(id)requestParams
                                                        success:(TwoDataBlock)success
                                                         failed:(DataBlock)failed
                                                          error:(DataBlock)err {
    _listData = [NSMutableArray array];
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckUserInfo]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             SetUserDefaultKeyWithObject(kUserInfo, [self.model mj_keyValues]);
                                                             UserDefaultSynchronize;
                                                             
                                                             [RongCloudManager updateNickName:self.model.userinfo.nickname
                                                                                       userId:self.model.userinfo.userid];
                                                             
                                                             [self assembleApiData:weakSelf.model.userinfo];
                                                             success(weakSelf.listData,weakSelf.model);
                                                             //            success(weakSelf.model);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                         
                                                     }];
}

- (void)network_checkUserInfoWithRequestParams:(id)requestParams
                                       success:(TwoDataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err {
    _listData = [NSMutableArray array];
    NSDictionary* proDic =@{};
    
    //    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckUserInfo]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             SetUserDefaultKeyWithObject(kUserInfo, [self.model mj_keyValues]);
                                                             UserDefaultSynchronize;
                                                             
                                                             [RongCloudManager updateNickName:self.model.userinfo.nickname
                                                                                       userId:self.model.userinfo.userid];
                                                             
                                                             [self assembleApiData:weakSelf.model.userinfo];
                                                             success(weakSelf.listData,weakSelf.model);
                                                             //            success(weakSelf.model);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                         
                                                     }];
}
- (void)assembleApiData:(LoginData*)data{
    
    [self removeContentWithType:IndexSectionZero];
    
    NSDictionary* dic0 = @{
                           kTip:@"实名认证",
                           kSubTip:@"姓名 | 身份证号",
                           kData:[NSString stringWithFormat:@"交易额度：每日%@元",data.idNumberAmount],
                           
                           kIndexSection:@(IndexSectionZero),
                           
                           kType:@([data getIdentityAuthType:data.valiidnumber]),
                           kIndexInfo:[data getIdentityAuthTypeName:[data getIdentityAuthType:data.valiidnumber]]
                           //                           kType:@(IdentityAuthTypeHandling),
                           //                           kIndexInfo:@{ @"审核中":@"user_auth_handling"}
                           };
    [self.listData addObject:@[dic0]];
    
    [self removeContentWithType:IndexSectionOne];
    NSDictionary* dic1 = @{
                           kTip:@"高级认证",
                           kSubTip:[data getIdentityAuthType:data.isSeniorCertification] ==SeniorAuthTypeUndone? @"创建人脸视频，保障资金安全":@"已通过人脸视频认证",
                           kData:[NSString stringWithFormat:@"交易额度：每日%@元",data.seniorCertificationAmount],
                           
                           kIndexSection:@(IndexSectionOne),
                           
                           kType:@([data getSeniorAuthType:data.isSeniorCertification]),
                           kIndexInfo:[data getSeniorAuthTypeName:[data getSeniorAuthType:data.isSeniorCertification]]
                           //                           kType:@(IdentityAuthTypeFinished),
                           //                           kIndexInfo:@{@"认证成功":@"user_auth_finished"}
                           };
    
    [self.listData addObject:@[dic1]];
    [self sortData];
}

- (void)network_getChangeNicknameWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed
                                             error:(DataBlock)err {
    
    NSString* n =  requestParams;
    
    NSDictionary* proDic =@{@"nickname":n};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ChangeNickname]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         self.model = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                         
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}

- (void)network_myTransferCodeWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err {
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_MyTransferCode]
                                                     andType:All
                                                     andWith:proDic success:^(NSDictionary *dic) {
                                                         
                                                         self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.aboutUsModel);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.aboutUsModel.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                         
                                                     }];
    
}

- (void)network_aboutUsWithRequestParams:(id)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err {
    
    NSDictionary* proDic =@{@"versionname":[YBSystemTool appVersion],
                            @"clientcfg":[YBSystemTool appSource]};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AboutUs]
                                                     andType:All
                                                     andWith:proDic success:^(NSDictionary *dic) {
                                                         self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.aboutUsModel);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.aboutUsModel.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                         
                                                     }];
}

- (void)network_helpCentreWithRequestParams:(id)requestParams
                                    success:(DataBlock)success
                                     failed:(DataBlock)failed
                                      error:(DataBlock)err {
    NSDictionary* proDic =@{};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_HelpCentre]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         self.aboutUsModel = [AboutUsModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.aboutUsModel);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:self.model.msg];
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                         
                                                     }];
    
}
//sections data not rows data
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* arr1 = obj1;
        NSArray* arr2 = obj2;
        NSNumber *number1 = [NSNumber numberWithInteger:[[arr1.firstObject objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[arr2.firstObject objectForKey:kIndexSection] integerValue]];
        NSComparisonResult result = [number1 compare:number2];
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray* arr = obj;
        IndexSectionType contentType = [[(NSDictionary *)arr.firstObject objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}

// 获取验证码
+ (void)getCodeWithPhoneParams:(id)requestParams
                       success:(DataBlock)success
                        failed:(DataBlock)failed
                         error:(DataBlock)err{
    
    NSArray *ar = requestParams;
    NSDictionary* proDic = @{
                             @"msgType":ar[1],
                             @"cellPhone":ar[0],
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SendMessageAuthenticationCode]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          [SVProgressHUD dismiss];
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              success(dic);
                                                          }
                                                          else{
                                                              failed(dic);
                                                              [YKToastView showToastText:dic[@"msg"]];
                                                          }
                                                      } error:^(NSError *error) {
                                                          [SVProgressHUD dismiss];
                                                          err(error);
                                                          [YKToastView showToastText:error.description];
                                                      }];
}



//校验短信验证码是否正确
+(void)networkCheckMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                      success:(DataBlock)success
                                                       failed:(DataBlock)failed
                                                        error:(DataBlock)err{
    
    NSArray *arr = requestParams != nil ? requestParams:@[@"",@""];
    
    NSString *n =  arr[1];
    NSString *p =  arr[0];
    
    NSDictionary *proDic =@{@"smsCode":n,// 短信验证码
                            @"cellPhone":p};//区号 + 手机号
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckMessageAuthenticationCode]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          [SVProgressHUD dismiss];
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              success(dic);
                                                          }else{
                                                              failed(dic);
                                                              [YKToastView showToastText:dic[@"msg"]];
                                                          }
                                                      } error:^(NSError *error) {
                                                          [SVProgressHUD dismiss];
                                                          [YKToastView showToastText:error.description];
                                                          err(error);
                                                      }];
}


//据手机号重置密码
+(void)networkResetPasswordWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err{
    
    NSArray *arr = requestParams != nil ? requestParams:@[@"",@""];
    
    NSString *n =  arr[0];
    NSString *p =  arr[1];
    
    NSDictionary *proDic =@{@"cellPhone":n,//手机号码
                            @"newPsd":p};//重置后的密码
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    //    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_ResetPassword]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             //                                                             LoginModel* mo = [LoginModel mj_objectWithKeyValues:dic];
                                                             success(dic);
                                                         }else{
                                                             failed(dic);
                                                             [YKToastView showToastText:dic[@"msg"]];
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                     }];
}


+ (void)networkidentityVertifyWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err{
    
    NSArray *arr = requestParams;
    
    NSString *n =  arr[0];
    NSString *p =  arr[1];
    NSString *v =  arr[2];
    NSString *m =  arr[3];
    NSString *i =  arr[4];
    NSString *w =  arr[5];
    NSString *k =  arr[6];
    
    NSDictionary* proDic =@{
                            @"otcUserName": n,//用户名
                            @"retrieveType": p,//申诉类型
                            @"name": v,//姓名
                            @"idNumber":m,//身份证号
                            @"email":i,//邮箱
                            @"idPhoto":w,//手持身份证照片
                            @"vailidKey":k//支付密码 或 谷歌验证码
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_IdentityVertify]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         //                                                         self.loginModel = [LoginModel mj_objectWithKeyValues:dic];
                                                         [SVProgressHUD dismiss];
                                                         //        [YKToastView showToastText:self.loginModel.msg];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(dic);
                                                         }
                                                         else{
                                                             failed(dic);
                                                             [YKToastView showToastText:dic[@"msg"]];
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
}

// 注册
+ (void)network_getRegisterWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err {
    
    NSArray* model = requestParams != nil ? requestParams:@[@"",@"",@"",@""];
    
    
//    NSArray *ar = @[array[0],array[1],pwd]; // 区号，手机号，密码
    NSString* c =  model[0];
    NSString* n =  model[1];
    NSString* p =  model[2];
//    NSString* p2 = model[2];
//    NSString* v =  model[3];
    NSDictionary* proDic =@{@"areaCode":c,
                            @"userName":n,
                            @"password":p,
                            @"captchaValidate":singLeton.yunDunCode?singLeton.yunDunCode:@"",
                            };
    proDic = [proDic vic_appendKey:@"registrationId" value:[JPUSHService registrationID]];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
//    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Register]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         [SVProgressHUD dismiss];
                                                         LoginModel *modelS = [LoginModel mj_objectWithKeyValues:dic];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             [[LoginVM new] network_rongCloudTokenWithRequestParams:modelS.userinfo.userid success:^(id data) {
                                                                 
                                                                 LoginModel* rcdata = [LoginModel mj_objectWithKeyValues:data];
                                                                 NSString* rcT = rcdata.rongyunToken!=nil?rcdata.rongyunToken:@"";
                                                                 [RongCloudManager loginWith:rcT success:^(NSString *userId) {
                                                                     //                    [UserManager defaultCenter].userInfo.rongyunToken = response.rongyunToken;
                                                                 } error:^(RCConnectErrorCode status) {
                                                                     
                                                                 } tokenIncorrect:^{
                                                                     
                                                                 }];
                                                             } failed:^(id data) {
                                                                 
                                                             } error:^(id data) {
                                                                 
                                                             }];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
                                                             if(![NSString isEmpty:modelS.msg]){
                                                                 [YKToastView showToastText:modelS.msg];
                                                             }
                                                             success(dic);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:modelS.msg];
                                                             failed(model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         err(error);
                                                         [YKToastView showToastText:error.description];
                                                     }];
    
}


// 验证登录密码
+ (void)network_postLongPWDWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err{

    NSDictionary *proDic =@{@"password":requestParams,// 短信验证码
                           };
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_YanZlongPW]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          [SVProgressHUD dismiss];
//                                                          if ([NSString getDataSuccessed:dic]) {
                                                              success(dic);
//                                                          }else{
//                                                               [YKToastView showToastText:dic[@"msg"]];
//                                                          }
                                                      } error:^(NSError *error) {
                                                          NSLog(@"error = %@",error);
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          [YKToastView showToastText:error.description];
                                                          
                                                          err(error);
                                                      }];
    
}
@end
