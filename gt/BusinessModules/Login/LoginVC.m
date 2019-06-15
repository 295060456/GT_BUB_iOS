//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVM.h"
#import "RegisterVC.h"
#import "LoginView.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "AboutUsModel.h"

@interface LoginVC ()<NTESVerifyCodeManagerDelegate>
@property (nonatomic, copy)   ActionBlock block;
@property (nonatomic, strong) NTESVerifyCodeManager* manager;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy)   DataBlock successBlock;
@property (nonatomic ,strong) LoginView *mainView;
//@property (nonatomic ,assign) NSInteger tagger;
@property (nonatomic ,strong) NSArray *phoneAndPwd;
@property (nonatomic, strong) AboutUsModel* customerServiceModel;
@end

@implementation LoginVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:( nullable id )requestParams
                   success:(DataBlock)block{
    LoginVC *vc = [[LoginVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    [rootVC presentViewController:vc animated:YES completion:^{}];
    return vc;
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)toHomeRootVC{
    [self goBack]; //特殊的，从其他页返回首页 Xiran 要走两次才能回到首页
    [self goBack]; //特殊的，从其他页返回首页 Xiran 要走两次才能回到首页
}

-(void)getSericeDAta{
    LoginVM *vm = [[LoginVM alloc] init];
    kWeakSelf(self);
    [vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        kStrongSelf(self);
        self.customerServiceModel = data;
        SetUserDefaultKeyWithObject(SeverData, [self.customerServiceModel mj_keyValues]);
        UserDefaultSynchronize;
    } failed:^(id data) {} error:^(id data) { }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    kWeakSelf(self);
    self.mainView = [[LoginView alloc] initViewSuccess:^(NSInteger types, id data) {
        [weakself mianViewTapAction:types andData:data];
    }];
    [self.view addSubview:self.mainView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toHomeRootVC) name:kNotify_HomeRootVC object:nil];
    
    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        [weakself goBack];
    }];
    [self getSericeDAta];
}


-(void)mianViewTapAction:(NSInteger)typ andData:(id)data{
    self.phoneAndPwd = nil;
    switch (typ) {
        case loginRegister:{
            [self registerEvent];
        }break;
        case loginforgetPwd:{
            [self findPwdEvent];
        }break;
        case loginToService:{
            [self toServerVC];
        }break;
        case loginToLogin:{
            self.phoneAndPwd = [NSArray arrayWithArray:data];
            [self openWYVertifyCodeView];
        }break;
        default:
            break;
    }
}

-(void)toServerVC{
    kWeakSelf(self);
    [LoginVM.new network_rongCloudTokenWithRequestParams:[UIDevice currentDevice].identifierForVendor.UUIDString success:^(id data) {
        kStrongSelf(self);
        LoginModel *model = data;
            NSArray *ar= @[SERVICE_ID,@"客服"];
            if (self.customerServiceModel) {
                ar = @[self.customerServiceModel.rongCloudId,self.customerServiceModel.rongCloudName];
            }
            [RCDCustomerServiceViewController presentFromVC:self  requestParams:model.rongyunToken andServiceData:ar
                                                    success:^(id data) {}];
       
    }failed:^(id data) {}error:^(id data) {}];
}

- (void)findPwdEvent{ // 忘记密码
    [RegisterVC pushFromVC:self
             requestParams:@(1)
         andRegisterVCType:longForgetPW
                   success:^(id data) {//0 绑定 1 跳过
                   }];
}

- (void)registerEvent{
    [RegisterVC pushFromVC:self
             requestParams:@(1)
         andRegisterVCType:longRegister
                   success:^(id data) {//0 绑定 1 跳过
                       //                       LoginModel* loginModel = data;
                       //                       [RegisterSuccessVC pushFromVC:self
                       //                                       requestParams:loginModel
                       //                                             success:^(id data) {
                       //                                                 [self goBack];}];
                   }];
}

// 网易
- (void)openWYVertifyCodeView{
    self.manager =  [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        // 无感知验证码
        NSString *captchaid = WYVertifyID_Key;
        self.manager.mode = NTESVerifyCodeBind;
        //self.manager.mode = NTESVerifyCodeNormal;
        [self.manager configureVerifyCode:captchaid
                                  timeout:10.0];
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        // 设置透明度
        self.manager.alpha = 0.3;
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        // 设置frame
        self.manager.frame = CGRectNull;
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message{
    
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    if (result == YES) {
        
        [self postLoginValidateValidates:validate];
    }else{
        [YKToastView showToastText:message];
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    
    NSLog(@"收到关闭验证码视图的回调");
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

-(void)postLoginValidateValidates:(NSString *)validate{
    if (self.phoneAndPwd == nil || self.phoneAndPwd.count != 2) {
        [YKToastView showToastText:@"输入手机号码或者密码不能为空"];
        return ;
    }
    NSString *phoneS = self.phoneAndPwd[0];
    NSString *pwdS   = self.phoneAndPwd[1];
    pwdS = [NSString MD5WithString:pwdS isLowercase:YES];
    kWeakSelf(self);
    [LoginVM.new network_getLoginWithRequestParams:@[phoneS,pwdS,validate]
                                           success:^(id model) {
                                               LoginModel* loginModel = model;
                                               [weakself goBack];
                                               SetUserBoolKeyWithObject(kIsLogin, YES);
                                               SetUserDefaultKeyWithObject(kUserInfo, [loginModel mj_keyValues]);
                                               UserDefaultSynchronize;
                                               weakself.successBlock(model);
                                           }failed:^(id model){}error:^(id model){}];
}

- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


