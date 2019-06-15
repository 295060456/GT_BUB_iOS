//
//  InputVerificationCodeVC.m
//  gt
//
//  Created by Administrator on 03/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "InputVerificationCodeVC.h"
#import "LoginVM.h"
#import "LoginVC.h"
#import "CodeInputView.h"
#import "EditUserInfoVC.h"
#import "AccountPhoneTipsView.h"


@interface InputVerificationCodeVC ()
@property (nonatomic, assign)NSInteger timeCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *phoneNumber;// 手机号
@property (nonatomic, strong) NSString *phoneCode;// 国家区号
@property (nonatomic, copy)   DataBlock block;
@property (nonatomic, strong) CodeInputView *codeView;
@property (nonatomic, strong) LoginVM *loginVM;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation InputVerificationCodeVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
                   success:(DataBlock)block{
    InputVerificationCodeVC *vc = [[InputVerificationCodeVC alloc] init];
    vc.block = block;
    vc.phoneCode = requestParams[0];
    vc.phoneNumber = requestParams[1];
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    [self stopTime];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.timeCount = 60;
    [self initView];
    [self startTime];
    
}

-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)startTime{
    [self stopTime];
    self.btn.userInteractionEnabled = NO;
     self.btn.backgroundColor = HEXCOLOR(0xcccccc);
    self.timeCount = 60;
    [self.btn setTitle:[NSString stringWithFormat:@"%ld s",self.timeCount]
              forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)timerAction{
    self.timeCount --;
    if (self.timeCount == 0) {
        [self stopTime];
        self.btn.backgroundColor = HEXCOLOR(0x4c7fff);
        [self.btn setTitle:@"获取验证码"
                  forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
    }else{
        self.btn.userInteractionEnabled = NO;
        self.btn.backgroundColor = HEXCOLOR(0xcccccc);
        [self.btn setTitle:[NSString stringWithFormat:@"%lds",self.timeCount]
                  forState:UIControlStateNormal];
    }
}

-(void)initView{
    
    UILabel *titleLa = [UILabel new];
    titleLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:28*SCALING_RATIO];
    titleLa.textColor = HEXCOLOR(0x333333);
    titleLa.text = @"输入验证码";
    [self.view addSubview:titleLa];
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(41*SCALING_RATIO);
        make.left.equalTo(self.view).offset(20*SCALING_RATIO);
        make.height.mas_equalTo(29*SCALING_RATIO);
    }];
    
    UILabel *detailLab = [UILabel new];
    detailLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*SCALING_RATIO];
    detailLab.textColor = HEXCOLOR(0x8c96a5);
    detailLab.text = @"验证码已通过短信发送至：";
    [self.view addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLa.mas_bottom).offset(8*SCALING_RATIO);
        make.left.mas_equalTo(titleLa);
        make.height.mas_equalTo(17*SCALING_RATIO);
    }];
    
    UIView *colorV = [UIView new];
    colorV.backgroundColor = HEXCOLOR(0x4c7fff);
    [self.view addSubview:colorV];
    colorV.layer.cornerRadius = 3*SCALING_RATIO;
    [colorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLab.mas_bottom).offset(14*SCALING_RATIO);
        make.left.mas_equalTo(titleLa);
        make.height.width.mas_equalTo(6*SCALING_RATIO);
    }];
    
    UILabel *telePhoneNumLab = [UILabel new];
    [self.view addSubview:telePhoneNumLab];
    telePhoneNumLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*SCALING_RATIO];
    telePhoneNumLab.textColor = HEXCOLOR(0x333333);
    NSString *s1 = [self.phoneNumber substringToIndex:3];
    NSString *s2 = [self.phoneNumber substringFromIndex:self.phoneNumber.length-3];
    telePhoneNumLab.text = [NSString stringWithFormat:@"+%@ %@****%@",self.phoneCode,s1,s2];
    [telePhoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailLab.mas_bottom).offset(9*SCALING_RATIO);
        make.left.mas_equalTo(titleLa.mas_left).offset(12*SCALING_RATIO);
        make.height.mas_equalTo(17*SCALING_RATIO);
    }];
    
    UILabel *deLab = [UILabel new];
    deLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*SCALING_RATIO];
    deLab.textColor = HEXCOLOR(0x8c96a5);
    deLab.text = @"请输入验证码";
    [self.view addSubview:deLab];
    [deLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(telePhoneNumLab.mas_bottom).offset(54*SCALING_RATIO);
        make.left.mas_equalTo(titleLa);
        make.height.mas_equalTo(17*SCALING_RATIO);
    }];
    
    kWeakSelf(self);
    self.codeView = [[CodeInputView alloc]initWithFrame:CGRectZero inputType:6 selectCodeBlock:^(NSString * code) {
//        NSLog(@"code === %@",code);
        if (code.length == 6) {
            [weakself codeInputComple:code];
        }
    }];
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLa.mas_left).offset(-20*SCALING_RATIO);
        make.top.mas_equalTo(deLab.mas_bottom).offset(15*SCALING_RATIO);
        make.height.mas_equalTo(44*SCALING_RATIO);
    }];
    
    self.btn = [[UIButton alloc] init];
    [self.view addSubview:self.btn];
    self.btn.userInteractionEnabled = NO;
    self.btn.titleLabel.font = kFontSize(16*SCALING_RATIO);
    [self.btn setTitle:@"60s" forState:UIControlStateNormal];
    self.btn.backgroundColor = HEXCOLOR(0xcccccc);
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 25*SCALING_RATIO;
    [self.btn addTarget:self action:@selector(gettingCodeBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-30*SCALING_RATIO);
        make.top.mas_equalTo(deLab.mas_bottom).offset(152*SCALING_RATIO);
        make.height.mas_equalTo(48*SCALING_RATIO);
        make.width.mas_equalTo(118*SCALING_RATIO);
    }];
}

#pragma mark ———— 重新发送验证码 按钮点击事件
-(void)gettingCodeBtnClickEvent{
    kWeakSelf(self);
    [self.loginVM network_gettingMessageAuthenticationCodeWithRequestParams:@[@"1",[NSString stringWithFormat:@"%@|%@",self.phoneCode,self.phoneNumber]]
                                                                    success:^(id data) {
                                                                        [weakself startTime];
                                                                    }failed:^(id data) {}error:^(id data) { }];
}


-(LoginVM *)loginVM{
    if (!_loginVM) {
        _loginVM = LoginVM.new;
    }
    return _loginVM;
}

-(void)codeInputComple:(NSString*)code{
    NSArray *arr = @[code,[NSString stringWithFormat:@"%@|%@",self.phoneCode,self.phoneNumber]];
    kWeakSelf(self);
    [self.loginVM network_CheckMessageAuthenticationCodeWithRequestParams:arr
                                                                  success:^(id data) {
                                                                      kStrongSelf(self);
                                                                      // 修改成功弹框
                                                                      [AccountPhoneTipsViewObj showSucceed:^{
                                                                          [self btnClickEvent];
                                                                      }];
                                                                  } failed:^(id data) {
                                                                      [self.codeView removeTextString];
                                                                  } error:^(id data) { }];
}

//#pragma mark ———— 我知道了 按钮点击事件
-(void)btnClickEvent{
    //熙然已和产品确认返回到首页并显示登录页面
    SetUserBoolKeyWithObject(kIsLogin, NO);
    
    DeleUserDefaultWithKey(kUserInfo);
    
    UserDefaultSynchronize;
    
    UINavigationController *nv = self.tabBarController.viewControllers.firstObject;
    UIViewController *vc = nv.viewControllers.firstObject;
    [LoginVC pushFromVC:vc requestParams:nil success:^(id data) {
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginOutRefresh object:nil];
    self.navigationController.tabBarController.selectedIndex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
