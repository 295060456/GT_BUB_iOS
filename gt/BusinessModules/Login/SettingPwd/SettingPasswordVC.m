//
//  SettingPasswordVC.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "SettingPasswordVC.h"
#import "longForgetSuccessView.h"
#import "LoginVM.h"
#import "NoGoogleViewController.h"

@interface SettingPasswordVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *getCodeBu;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic ,assign) LongPwdTypes myType;
@property (nonatomic, strong) UITextField * inputPwdTF;
@property (nonatomic, strong) UILabel * inputTFLa;
@property (nonatomic, strong) UIImageView * inputTFIm;
@property (nonatomic, strong) UIButton * inputTFBu;
@property (nonatomic, strong) UITextField * inputAganPwdTF;
@property (nonatomic, strong) UILabel * inputAganPwdTFLa;
@property (nonatomic, strong) UIImageView * inputAganPwdTFIm;
@property (nonatomic, strong) UIButton * inputAganPwdTFBu;

@end

@implementation SettingPasswordVC

+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(nullable id )requestParams  andType:(LongPwdTypes)type success:(DataBlock)block{
    SettingPasswordVC *vc = [[SettingPasswordVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    vc.myType = type;
    [rootVC presentViewController:vc animated:YES completion:nil];
    return vc;
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
    self.view.backgroundColor = kWhiteColor;
    kWeakSelf(self);
    [self.view regiestBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        [weakself goBack];
    }];
    [self initView];
}


-(void)initView{
    
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, 96*SCALING_RATIO, 150*SCALING_RATIO, 29*SCALING_RATIO)];
    titleLa.text = @"设置密码";
    titleLa.font = kFontSize(28*SCALING_RATIO);
    titleLa.textColor = HEXCOLOR(0x333333);
    [self.view addSubview:titleLa];
    
    UILabel *titleContentLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(titleLa.frame) + 11 *SCALING_RATIO, 330*SCALING_RATIO, 29*SCALING_RATIO)];
    titleContentLa.text = @"格式包含数字 英文大小写的8-16位字符";
    titleContentLa.font = kFontSize(16*SCALING_RATIO);
    titleContentLa.textColor = HEXCOLOR(0x8c96a5);
    [self.view addSubview:titleContentLa];
    
    self.inputPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(titleContentLa.frame) + 54*SCALING_RATIO, MAINSCREEN_WIDTH - 90*SCALING_RATIO, 20*SCALING_RATIO)];
    [self.inputPwdTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingDidEnd];
    self.inputPwdTF.clearButtonMode = UITextFieldViewModeAlways;
    self.inputPwdTF.keyboardType =  UIKeyboardTypeDefault;
    self.inputPwdTF.placeholder = @"请输入密码";
    self.inputPwdTF.secureTextEntry = YES;
    self.inputPwdTF.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.inputPwdTF];
    UIView *lin1  = [[UIView alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.inputPwdTF.frame) + 12*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 1)];
    lin1.backgroundColor = HEXCOLOR(0xdddddd);
    [self.view addSubview:lin1];
    
    self.inputTFIm = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 16 *SCALING_RATIO - 67*SCALING_RATIO ,CGRectGetMaxY(titleContentLa.frame) + 55*SCALING_RATIO , 16*SCALING_RATIO, 16*SCALING_RATIO)];
    self.inputTFIm.image = kIMG(@"invalidNamexiRan");
    [self.view addSubview:self.inputTFIm];
    self.inputTFIm.hidden = YES;
    self.inputTFBu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inputTFBu.frame = CGRectMake(MAINSCREEN_WIDTH - 19 *SCALING_RATIO - 49*SCALING_RATIO ,CGRectGetMaxY(titleContentLa.frame) + 47*SCALING_RATIO, 39*SCALING_RATIO, 33*SCALING_RATIO);
    [self.view addSubview:self.inputTFBu];
    [self.inputTFBu addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.inputTFBu setImage:kIMG(@"icon_eyeopen") forState:(UIControlStateNormal)];
    self.inputTFBu.selected = YES;
    
    self.inputTFLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(lin1.frame) + 8*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 12*SCALING_RATIO)];
    self.inputTFLa.textColor = HEXCOLOR(0xff2525);
    self.inputTFLa.font = kFontSize(12);
    self.inputTFLa.text = @"*至少8位数且包含英文大小写及数字的密码";
    self.inputTFLa.hidden = YES;
    [self.view addSubview:self.inputTFLa];
    
    
    self.inputAganPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(lin1.frame) + 30*SCALING_RATIO, MAINSCREEN_WIDTH - 90*SCALING_RATIO, 20*SCALING_RATIO)];
    self.inputAganPwdTF.clearButtonMode = UITextFieldViewModeAlways;
    self.inputAganPwdTF.keyboardType =  UIKeyboardTypeDefault;
    self.inputAganPwdTF.placeholder = @"确认密码";
    self.inputAganPwdTF.secureTextEntry = YES;
    self.inputAganPwdTF.delegate = self;
    self.inputAganPwdTF.font = [UIFont systemFontOfSize:18];
    [self.inputAganPwdTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingDidEnd];
    //    self.inputTF1.delegate = self;
    [self.view addSubview:self.inputAganPwdTF];
    UIView *lin2  = [[UIView alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.inputAganPwdTF.frame) + 12*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 1)];
    lin2.backgroundColor = HEXCOLOR(0xdddddd);
    [self.view addSubview:lin2];
    
    
    
    self.inputAganPwdTFIm = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 16 *SCALING_RATIO - 67*SCALING_RATIO ,CGRectGetMaxY(lin1.frame) + 33*SCALING_RATIO , 16*SCALING_RATIO, 16*SCALING_RATIO)];
    self.inputAganPwdTFIm.image = kIMG(@"invalidNamexiRan");
    self.inputAganPwdTFIm.hidden = YES;
    [self.view addSubview:self.inputAganPwdTFIm];
    
    self.inputAganPwdTFBu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inputAganPwdTFBu.frame = CGRectMake(MAINSCREEN_WIDTH - 19 *SCALING_RATIO - 49*SCALING_RATIO ,CGRectGetMaxY(lin1.frame) + 24*SCALING_RATIO, 39*SCALING_RATIO, 33*SCALING_RATIO);
    [self.view addSubview:self.inputAganPwdTFBu];
    [self.inputAganPwdTFBu addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.inputAganPwdTFBu setImage:kIMG(@"icon_eyeopen") forState:(UIControlStateNormal)];
    self.inputAganPwdTFBu.selected = YES;
    
    self.inputAganPwdTFLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(lin2.frame) + 8*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 12*SCALING_RATIO)];
    self.inputAganPwdTFLa.textColor = HEXCOLOR(0xff2525);
    self.inputAganPwdTFLa.font = kFontSize(12);
    self.inputAganPwdTFLa.text = @"*密码不一致";
    self.inputAganPwdTFLa.hidden = YES;
    [self.view addSubview:self.inputAganPwdTFLa];
    
    
   self.getCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH - 148*SCALING_RATIO, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118*SCALING_RATIO, 48*SCALING_RATIO);
    [self.getCodeBu setTitle:@"注册完成"
               forState:UIControlStateNormal];
    [self.view addSubview:self.getCodeBu];
    [self.getCodeBu setTintColor:HEXCOLOR(0xf7f9fa)];
    self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    self.getCodeBu.layer.masksToBounds = YES;
    self.getCodeBu.userInteractionEnabled = NO;
    self.getCodeBu.layer.cornerRadius = 25*SCALING_RATIO;
    [self.getCodeBu addTarget:self action:@selector(longBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCodeBu];
}

-(void)textFieldTextChange:(UITextField *)textField{
    if (textField.text.length > 19) {
        textField.text = [textField.text substringToIndex:19];
    }
    if ([textField isEqual:self.inputPwdTF]) {
        NSString *s = textField.text;
        if (s.length<8 || s.length>16 || ![NSString isContainAllCharType:s] ) {
            self.inputTFIm.hidden = NO;
            self.inputTFLa.hidden = NO;
        }else{
            self.inputTFIm.hidden = YES;
            self.inputTFLa.hidden = YES;
        }
    }else if ([textField isEqual:self.inputAganPwdTF]){
        if ([self.inputPwdTF.text isEqualToString:self.inputAganPwdTF.text]) {
            self.inputAganPwdTFIm.hidden = YES;
            self.inputAganPwdTFLa.hidden = YES;
        }else{
            self.inputAganPwdTFIm.hidden = NO;
            self.inputAganPwdTFLa.hidden = NO;
        }
    }
}


-(void)buttonAction:(UIButton*)bu{
    bu.selected = !bu.selected;
    if ([bu isEqual:self.inputTFBu]){
        if (!bu.selected) {
            [self.inputTFBu setImage:kIMG(@"icon_eyeclose") forState:(UIControlStateNormal)];
            self.inputPwdTF.secureTextEntry = YES;
        }else{
            [self.inputTFBu setImage:kIMG(@"icon_eyeopen") forState:(UIControlStateNormal)];
            self.inputPwdTF.secureTextEntry = NO;
        }
    }else if ([bu isEqual:self.inputAganPwdTFBu]){
        if (!bu.selected) {
            [self.inputAganPwdTFBu setImage:kIMG(@"icon_eyeclose") forState:(UIControlStateNormal)];
            self.inputAganPwdTF.secureTextEntry = YES;
        }else{
            [self.inputAganPwdTFBu setImage:kIMG(@"icon_eyeopen") forState:(UIControlStateNormal)];
            self.inputAganPwdTF.secureTextEntry = NO;
        }
    }
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)longBtnClick{
    [self.view endEditing:YES];
    
    if (self.inputTFIm.hidden == NO || self.inputAganPwdTFIm.hidden == NO) {
        [YKToastView showToastText:@"输入的密码不合法"];
        return;
    }
    if (![NSString isContainAllCharType:self.inputAganPwdTF.text]) {
//        line1.backgroundColor = [UIColor redColor];
//        tipLab1.text = @"*请重新输入密码：必须要包含大写及小写字母与数字";
        [YKToastView showToastText:@"密码必须要包含大写及小写字母与数字"];
        return;
    }
    
    NSString *phS = self.requestParams;
    NSString *str = [phS stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *pwd = [NSString MD5WithString:self.inputAganPwdTF.text isLowercase:YES];
    
    SuccessViewType ty  = successApplication;
    if (self.myType == longRegister) {
        ty = successRegistered;
        
        NSArray *array = [str componentsSeparatedByString:@"|"];
        NSArray *ar = @[array[0],array[1],pwd]; // 区号，手机号，密码
        [LoginVM network_getRegisterWithRequestParams:ar success:^(id data) {
            SetUserBoolKeyWithObject(kIsLogin, YES);
            SetUserDefaultKeyWithObject(kUserInfo, data);
            UserDefaultSynchronize;
            longForgetSuccessView *vi = [[longForgetSuccessView alloc] initFogetGetPwViewWith:ty  Bolck:^(NSInteger types, id data) {
                [self successShowView:types];
            }];
            [self.view addSubview:vi];
        } failed:^(id data) {} error:^(id data) {}];
    }else{
        NSArray *ar = @[str,pwd];
        [LoginVM networkResetPasswordWithRequestParams:ar success:^(id data) {
            longForgetSuccessView *vi = [[longForgetSuccessView alloc] initFogetGetPwViewWith:ty  Bolck:^(NSInteger types, id data) {
                [self successShowView:types];
            }];
            [self.view addSubview:vi];
        } failed:^(id data) {
        } error:^(id data) { }];
    }
}

-(void)successShowView:(NSInteger)item{
    if (self.myType == longForgetPW) { // 密码重设成功
        //          NSLog(@"返回首页");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_HomeRootVC object:nil];
    }else if (self.myType == longRegister) {  ///注册成功
        if (item == 2) { // 不绑定
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_HomeRootVC object:nil];
        }else if (item == 3){ // 去绑定
            NoGoogleViewController * NoGoogleVerC = [[NoGoogleViewController alloc] initWithStyle:@"present"];
            [self presentViewController:NoGoogleVerC animated:YES completion:nil];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *texteS = textField.text;
    if (texteS && texteS.length > 3) {
        self.getCodeBu.userInteractionEnabled = YES;
        [self.getCodeBu setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        self.getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
    }else{
        self.getCodeBu.userInteractionEnabled = NO;
        [self.getCodeBu setTitleColor:HEXCOLOR(0xf7f9fa) forState:(UIControlStateNormal)];
        self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    }
    if (texteS.length > 19) {
        textField.text = [texteS substringToIndex:19];
    }
    return YES;
}


#pragma mark ---- 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.getCodeBu.mj_y = MAINSCREEN_HEIGHT-self.getCodeBu.mj_h-kbHeight-15*SCALING_RATIO;
    }];
}

#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    [UIView animateWithDuration:0.2 animations:^{
        self.getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH - 148*SCALING_RATIO, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118*SCALING_RATIO, 48*SCALING_RATIO);
    }];
}
@end
