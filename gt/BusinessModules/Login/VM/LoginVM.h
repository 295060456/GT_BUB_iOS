//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginVM : NSObject


//- (void)network_rongCloudTemporaryTokenWithRequestParams:(id)requestParams
//                                                 success:(DataBlock)success
//                                                  failed:(DataBlock)failed
//                                                   error:(DataBlock)err;

- (void)network_rongCloudTokenWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;


- (void)network_getLoginWithRequestParams:(id)requestParams
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err;

- (void)network_getLoginOutWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;

- (void)network_getChangeNicknameWithRequestParams:(id)requestParams
                                           success:(DataBlock)success
                                            failed:(DataBlock)failed
                                             error:(DataBlock)err;

- (void)network_changeLoginPWWithRequestParams:(id)requestParams
                               andIsGoogleCode:(BOOL)isGoogle
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_changeFundPWWithRequestParams:(id)requestParams
                              andIsGoogleCode:(BOOL)isGoogle
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err;

- (void)network_settingFundPWWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_inSecuritySettingCheckUserInfoWithRequestParams:(id)requestParams
                                                        success:(TwoDataBlock)success
                                                         failed:(DataBlock)failed
                                                          error:(DataBlock)err;

- (void)network_checkUserInfoWithRequestParams:(id)requestParams
                                       success:(TwoDataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;

- (void)network_myTransferCodeWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;

- (void)network_aboutUsWithRequestParams:(id)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err;

- (void)network_helpCentreWithRequestParams:(id)requestParams
                                    success:(DataBlock)success
                                     failed:(DataBlock)failed
                                      error:(DataBlock)err;

// 获取验证码
+ (void)getCodeWithPhoneParams:(id)requestParams
                       success:(DataBlock)success
                        failed:(DataBlock)failed
                         error:(DataBlock)err;
//校验短信验证码是否正确
+(void)networkCheckMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                      success:(DataBlock)success
                                                       failed:(DataBlock)failed
                                                        error:(DataBlock)err;

//据手机号重置密码
+(void)networkResetPasswordWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;
//找回密码
+ (void)networkidentityVertifyWithRequestParams:(id)requestParams
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;
-(void)network_gettingMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                         success:(DataBlock)success
                                                          failed:(DataBlock)failed
                                                           error:(DataBlock)err;
//校验短信验证码是否正确
-(void)network_CheckMessageAuthenticationCodeWithRequestParams:(id)requestParams
                                                       success:(DataBlock)success
                                                        failed:(DataBlock)failed
                                                         error:(DataBlock)err;

// 注册
+ (void)network_getRegisterWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;

// 验证登录密码
+ (void)network_postLongPWDWithRequestParams:(id)requestParams
                                     success:(DataBlock)success
                                      failed:(DataBlock)failed
                                       error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
