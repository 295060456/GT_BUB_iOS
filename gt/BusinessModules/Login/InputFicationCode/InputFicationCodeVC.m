//
//  InputFicationCodeVC.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "InputFicationCodeVC.h"
#import "StepField.h"
#import "LoginVM.h"
#import "SettingPasswordVC.h"
#import "CodeInputView.h"

@interface InputFicationCodeVC ()
@property (nonatomic ,assign) LongPwdTypes myType;
@property (nonatomic, copy) DataBlock successBlock;
@property (nonatomic ,strong) NSString *phoneString;
@property (nonatomic ,strong) NSString *countryCode;
@property (nonatomic ,strong) UIButton *getCodeBu;
@property (nonatomic ,assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)UILabel *telePhoneNumLab;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic, strong) CodeInputView *codeView;
@end

@implementation InputFicationCodeVC

+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(NSString *)phone andInputCodeVCType:(NSString*)countryCode anVCType:(LongPwdTypes)type success:(DataBlock)block{
    InputFicationCodeVC *vc = [[InputFicationCodeVC alloc] init];
    vc.phoneString = phone;
    vc.countryCode = countryCode;
    vc.successBlock = block;
    vc.myType = type;
    [rootVC presentViewController:vc animated:YES completion:nil];
    return vc;
}
-(UILabel *)telePhoneNumLab{
    if (!_telePhoneNumLab) {
        _telePhoneNumLab = [[UILabel alloc] init];
        _telePhoneNumLab.textColor = HEXCOLOR(0x333333);
        _telePhoneNumLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                                size:16];
    }
    return _telePhoneNumLab;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTime];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self initViewAndAddView];
}

-(void)initViewAndAddView{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn setImage:kIMG(@"icon_back_black")
             forState:UIControlStateNormal];
    
    [backBtn addTarget:self
                action:@selector(backBtnClickEvent)
      forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 20, MAINSCREEN_WIDTH / 20));
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(rectOfStatusbar + 20);
    }];
    
    UILabel  *titleLab = [[UILabel alloc] init];
    [self.view addSubview:titleLab];
    titleLab.text = @"输入验证码";
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                    size:28];
    titleLab.textColor = HEXCOLOR(0x333333);
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(backBtn.mas_bottom).offset(41);
    }];
    
    UILabel *titleCountentLa = [[UILabel alloc] init];
    [self.view addSubview:titleCountentLa];
    titleCountentLa.text = @"验证码已通过短信发送至:";
    titleCountentLa.textColor = HEXCOLOR(0x8c96a5);
    titleCountentLa.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                           size:16];
    [titleCountentLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.top.equalTo(titleLab.mas_bottom);
    }];
    
    [self.view addSubview:self.telePhoneNumLab];
    NSString *s1 = [self.phoneString substringToIndex:3];
    NSString *s2 = [self.phoneString substringFromIndex:self.phoneString.length-3];
    self.telePhoneNumLab.text = [NSString stringWithFormat:@"%@ %@****%@",self.countryCode,s1,s2];
    [self.telePhoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleCountentLa.mas_bottom).offset(3);
        make.left.mas_equalTo(titleCountentLa.mas_left).offset(8);
    }];
    
    UIView *bluePointIMGV = [[UIView alloc] init];
    [self.view addSubview:bluePointIMGV];
    bluePointIMGV.backgroundColor = HEXCOLOR(0x4c7fff);
    bluePointIMGV.layer.cornerRadius = 3;
    [bluePointIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleCountentLa.mas_left);
        make.top.mas_equalTo(self.telePhoneNumLab.mas_top).offset(9);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    UILabel  *codeLab = [UILabel new];
    [self.view addSubview:codeLab];
    codeLab.tag = 123435;
    codeLab.text = @"请输入验证码";
    codeLab.textColor = HEXCOLOR(0x8c96a5);
    codeLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                   size:16];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.top.mas_equalTo(titleCountentLa.mas_bottom).offset(80);
    }];

    kWeakSelf(self);
    self.codeView = [[CodeInputView alloc]initWithFrame:CGRectMake(1, 295,MAINSCREEN_WIDTH, 44*SCALING_RATIO) inputType:6 selectCodeBlock:^(NSString * code) {
        if (code.length == 6) {
            [weakself codeInputComple:code];
        }
    }];
    [self.view addSubview:self.codeView];

    self.getCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCodeBu setTitle:@"获取验证码"
                    forState:UIControlStateNormal];
    [self.view addSubview:self.getCodeBu];
    self.getCodeBu.userInteractionEnabled = NO;
    self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    [self.getCodeBu setTintColor:HEXCOLOR(0xf7f9fa)];
    self.getCodeBu.titleLabel.font = kFontSize(16*SCALING_RATIO);
    self.getCodeBu.layer.masksToBounds = YES;
    self.getCodeBu.layer.cornerRadius = 25;
    [self.getCodeBu addTarget:self
                       action:@selector(getCodeButClick)
             forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH-148, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118, 48);
//    [self.getCodeBu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(codeLab.mas_bottom).offset(152);
//        make.right.mas_equalTo(-30);
//        make.width.mas_equalTo(118);
//        make.height.mas_equalTo(48);
//    }];
    [self startTime:YES];
    
}

-(void)startTime:(BOOL)first{
    if (!first) {
        [self stopTime];
    }
    self.getCodeBu.userInteractionEnabled = NO;
    self.count = 60;
    [self.getCodeBu setTitle:[NSString stringWithFormat:@"%ld s",self.count]
                    forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
}


-(void)getCodeButClick{ // 再次获得验证码
    [self startTime:NO];
    NSString *ph = [NSString stringWithFormat:@"%@|%@",self.countryCode,self.phoneString];
    ph = [ph stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSArray *ar = @[ph,self.myType == longRegister ? @"1":@"2"];
    [LoginVM getCodeWithPhoneParams:ar success:^(id data) {
        [self startTime:NO];
    } failed:^(id data) {
        [self stopTime];
    } error:^(id data) {}];
    
}
-(void)backBtnClickEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)timerAction{
    self.count --;
    if (self.count < 0) {
        [self stopTime];
    }else{
        self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
        [self.getCodeBu setTitle:[NSString stringWithFormat:@"%ld s",self.count]
                        forState:UIControlStateNormal];
        
    }
}

-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.getCodeBu.userInteractionEnabled = YES;
    [self.getCodeBu setTitle:@"重新发送"
                    forState:UIControlStateNormal];
    self.getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
}

-(void)codeInputComple:(NSString*)codeS{ // 验证码输入完成
    NSString *ph = [NSString stringWithFormat:@"%@|%@",self.countryCode,self.phoneString];
    NSString *str = [ph stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSArray *ar = @[str,codeS];
    kWeakSelf(self);
    [LoginVM networkCheckMessageAuthenticationCodeWithRequestParams:ar success:^(id data) {
        [SettingPasswordVC presentViewController:weakself requestParams:ph andType:self.myType success:^(id data) {
        }];
    } failed:^(id data) {
        [weakself.codeView removeTextString];
    } error:^(id data) {}];
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
          self.getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH-148, self.view.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118, 48);
    }];
}

@end
