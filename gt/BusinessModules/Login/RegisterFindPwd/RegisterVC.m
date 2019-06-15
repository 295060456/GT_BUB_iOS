//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "RegisterVC.h"
#import "LoginVM.h"
#import "XWCountryCodeController.h"
#import "InputFicationCodeVC.h"
#import "OtherFogetGetPwView.h"
#import "OtherFindPwdVC.h"
#import "SettingPasswordVC.h"
#import <VerifyCode/NTESVerifyCodeManager.h>


@interface RegisterVC ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>{
    UIButton *getCodeBu;
}
@property (nonatomic ,assign) LongPwdTypes myType;
@property (nonatomic ,strong) UITextField *phoneTf;
@property (nonatomic, strong) UIButton *phoneCodeBu;
@property (nonatomic, strong)NTESVerifyCodeManager* manager;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation RegisterVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams andRegisterVCType:(LongPwdTypes)type success:(DataBlock)block
{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.myType = type;
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}

-(void)goBack{ // 返回
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)dealloc{
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initViews];
}

-(void)initViews{
    
    kWeakSelf(self);
    [self.view regiestBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self goBack];
    }];
    
    UILabel *titleLa = [[UILabel alloc] init];
    titleLa.textAlignment = NSTextAlignmentLeft;
    titleLa.textColor = HEXCOLOR(0x333333);
    titleLa.font = kFontSize(28);
    [self.view addSubview:titleLa];
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(@96);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(@29);
        make.width.mas_equalTo(200);
    }];
    [self.view addSubview:titleLa];
    if (self.myType == longRegister) {
        titleLa.text = @"注册";
        
        UILabel *accLab = [[UILabel alloc]init];
        [self.view addSubview:accLab];
        accLab.text = @"欢迎加入币友";
        accLab.textAlignment = NSTextAlignmentCenter;
        accLab.textColor = HEXCOLOR(0x8c96a5);
        accLab.font = kFontSize(16);
        [accLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLa.mas_bottom).offset(10);
            make.left.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(102, 17));
        }];
    }else if (self.myType == longForgetPW ){
        titleLa.text = @"忘记密码";
    }
    self.phoneCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneCodeBu.titleLabel.font = kFontSize(18);
    [self.phoneCodeBu setTitle:@"+86" forState:UIControlStateNormal];
    [self.phoneCodeBu setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.view addSubview:self.phoneCodeBu];
    [self.phoneCodeBu addTarget:self action:@selector(choosePhoneCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.phoneCodeBu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLa.mas_bottom).offset(81);
        make.left.mas_equalTo(28);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIImageView *imV = [[UIImageView alloc] init];
    imV.image = kIMG(@"daosanjiaoXir");
    imV.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *ta = [UITapGestureRecognizer alloc] initWithTarget:self action:<#(nullable SEL)#>
    [self.view addSubview:imV];
    [imV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLa.mas_bottom).offset(85);
        make.left.mas_equalTo(88);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    
    UIView* line = [[UIView alloc]init];
    [self.view addSubview:line];
    line.backgroundColor = HEXCOLOR(0xdddddd);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLa.mas_bottom).offset(113);
        make.left.mas_equalTo(31);
        make.right.mas_equalTo(-31);
        make.height.mas_equalTo(1);
    }];
    
    
    self.phoneTf = [[UITextField alloc] init];
    self.phoneTf.delegate = self;
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    //    [self.phoneTf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTf.textAlignment = NSTextAlignmentLeft;
    self.phoneTf.backgroundColor = kClearColor;
    self.phoneTf.textColor =  HEXCOLOR(0x333333);
    self.phoneTf.font = kFontSize(18);
    self.phoneTf.placeholder = @"请输入手机号码";
    [self.view addSubview:self.phoneTf];
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLa.mas_bottom).offset(81);
        make.left.mas_equalTo(103);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(20);
    }];
    
    
    UIButton *buttomLeftBu = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:buttomLeftBu];
    buttomLeftBu.userInteractionEnabled = YES;
    [buttomLeftBu addTarget:self action:@selector(registerEvents) forControlEvents:UIControlEventTouchUpInside];
    [buttomLeftBu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(18);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(20);
    }];
    if (self.myType == longRegister) {
        [buttomLeftBu setAttributedTitle:[NSString attributedStringWithString:@"已有账号?  " stringColor:HEXCOLOR(0x8c96a5) stringFont:kFontSize(15) subString:@"登录" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
    }else if (self.myType == longForgetPW ){
        [buttomLeftBu setAttributedTitle:[NSString attributedStringWithString:@"" stringColor:HEXCOLOR(0x8c96a5) stringFont:kFontSize(15) subString:@"其他方式找回" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
    }
    
    getCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBu.userInteractionEnabled = NO;
    getCodeBu.tag = 10908;
    [getCodeBu setTitle:@"获取验证码"
               forState:UIControlStateNormal];
    getCodeBu.titleLabel.font = kFontSize(16*SCALING_RATIO);
    [self.view addSubview:getCodeBu];
    [getCodeBu setTintColor:HEXCOLOR(0xf7f9fa)];
    getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    getCodeBu.layer.masksToBounds = YES;
    getCodeBu.layer.cornerRadius = 25;
    [getCodeBu addTarget:self
                  action:@selector(getCodeBtnClick)
        forControlEvents:UIControlEventTouchUpInside];
    
    getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH-148, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118, 48);

}


-(void)choosePhoneCode:(UIButton*)bu{ // 选择区号
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    [self presentViewController:countryCodeVC
                       animated:YES
                     completion:Nil];
    countryCodeVC.countryCodeBlock = ^(NSString *countryName, NSString *code) {
        if (code) {
            NSString *s = [NSString stringWithFormat:@"+%@",code];
            [self->_phoneCodeBu setTitle:s forState:UIControlStateNormal];
        }
    };
}

-(void)registerEvents{
    [self.view endEditing:YES];
    if (self.myType == longRegister) {
        [self goBack];
    }else if (self.myType == longForgetPW ){ // 其他方式找回
        kWeakSelf(self);
        OtherFogetGetPwView *view = [[OtherFogetGetPwView alloc] initOtherFogetTitle:@"其他方式找回" andDataAr:@[@"已完成实名认证",@"BUB支付密码找回",@"Google Authenticator找回"] viewWithBolck:^(NSInteger types, id data) {
            [weakself pushOtherVC:types];
        }];
        [self.view addSubview:view];
    }
}

-(void)pushOtherVC:(NSInteger)item{
    if (item == 0) {
        [OtherFindPwdVC presentViewController:self requestParams:nil withType:recoverPwCar success:^(id data) {
        }];
    }else if (item == 1){
        [OtherFindPwdVC presentViewController:self requestParams:nil withType:recoverPwBUBP success:^(id data) {
        }];
    }else if (item == 2){
        [OtherFindPwdVC presentViewController:self requestParams:nil withType:recoverPwGoogleCode success:^(id data) {
        }];
    }
}

-(void)getCodeBtnClick{
    [self.view endEditing:YES];
    NSString *phoneSt = self.phoneTf.text;
    if ([NSString isEmpty:phoneSt]
        &&![NSString isEmpty:phoneSt]) {
        [YKToastView showToastText:@"请填写手机号码"];
        return;
    }
    if (phoneSt.length<5) {
        [YKToastView showToastText:@"您输入的字符过短，至少5位数哦"];
        return;
    }
    if (phoneSt.length>20||phoneSt.length==20) {
        [YKToastView showToastText:@"您输入的字符过长，最长不超过20位哦"];
        return;
    }
    if (![NSString judgeiphoneNumberInt:phoneSt]) {
        [YKToastView showToastText:@"输入手机号必须是整数哦"];
        return;
    }
    [self openWYVertifyCodeView];
}

-(void)getPhoneCode{ // 过了网易就走这
    NSString *ph = [NSString stringWithFormat:@"%@|%@",self.phoneCodeBu.titleLabel.text,self.phoneTf.text];
    NSString *str = [ph stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSArray *ar = @[str,@"1"];
    [LoginVM getCodeWithPhoneParams:ar success:^(id data) {
        [InputFicationCodeVC presentViewController:self requestParams:self.phoneTf.text andInputCodeVCType:self.phoneCodeBu.titleLabel.text anVCType:self.myType success:^(id data) {
        }];
    } failed:^(id data) {} error:^(id data) {}];
}


- (void)openWYVertifyCodeView{
    
    self.manager =  [NTESVerifyCodeManager sharedInstance];
    
    [self.view endEditing:YES];
    
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
        [self getPhoneCode];
        singLeton.yunDunCode = validate;
    }else{
        [YKToastView showToastText:message];
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    NSLog(@"收到关闭验证码视图的回调");
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}



- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}
#pragma mark ---- 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
   UIButton *getCodeBu = [self.view viewWithTag:10908];
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        getCodeBu.mj_y = MAINSCREEN_HEIGHT-getCodeBu.mj_h-kbHeight-15*SCALING_RATIO;
    }];
}

#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    UIButton *getCodeBu = [self.view viewWithTag:10908];
    [UIView animateWithDuration:0.2 animations:^{
        getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH-148, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118, 48);
    }];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *texteS = textField.text;
    if (texteS && texteS.length > 3) {
        getCodeBu.userInteractionEnabled = YES;
        [getCodeBu setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
    }else{
        getCodeBu.userInteractionEnabled = NO;
        [getCodeBu setTitleColor:HEXCOLOR(0xf7f9fa) forState:(UIControlStateNormal)];
        getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    }
    if (texteS.length > 19) {
        textField.text = [texteS substringToIndex:19];
    }
    return YES;
}

@end


