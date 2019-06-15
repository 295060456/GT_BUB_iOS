//
//  GoogleVerificationViewController.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/20.
//  Copyright © 2018年 GT. All rights reserved.
//

#import "GoogleVerificationViewController.h"
#import "ReleaseGoogleOneViewController.h"
#import "GoogleSecretVM.h"
#import "LoginVM.h"

#import "InputPWPopUpView.h"
#import "ReleaseSuccessViewController.h"
@interface GoogleVerificationViewController ()
@property (nonatomic, strong) UISwitch *switchFunc;
@property (nonatomic, strong) GoogleSecretVM* vm;
@property (nonatomic, strong) LoginVM* loginVM;
@end

@implementation GoogleVerificationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"谷歌验证";
    [self initView];
}
-(void)dealloc{
    
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self postSwitchFuncStatus];
//}
-(void)initView{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    line.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    [self.view addSubview:line];
    
    UILabel * isVerificationLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 110, 24)];
    isVerificationLb.text = @"是否开启验证";
    isVerificationLb.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:isVerificationLb];
    
    self.switchFunc = [[UISwitch alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 20 - 51, 28, 1, 1)];
    self.switchFunc.onTintColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    self.switchFunc.transform = CGAffineTransformMakeScale(0.80, 0.80);
    
    [self.switchFunc addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchFunc];
    
    UIButton * releaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(self.switchFunc.frame) + 70, MAINSCREEN_WIDTH - 24 * 2, 42)];
    [releaseBtn setTitle:@"解除当前绑定" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    releaseBtn.layer.cornerRadius = 5;
    releaseBtn.layer.masksToBounds = YES;
    [releaseBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseBtn];
    
    [self postSwitchFuncStatus];
}

- (void)postSwitchFuncStatus{
    WS(weakSelf);
    [self.loginVM network_checkUserInfoWithRequestParams:@1 success:^(id data, id data2) {
        LoginModel* model = data2;
        [weakSelf.switchFunc setOn:  [model.userinfo.safeverifyswitch boolValue]];
        
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

- (void)switchAction:(UISwitch*)switchFun{
    
    if (!switchFun.isOn) {//关
        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero WithIsForceShowGoogleCodeField:YES];
        [popupView showInApplicationKeyWindow];
        if (popupView==nil) {
            [self postSwitchFuncStatus];
        }
        [popupView actionBlock:^(id data) {
            kWeakSelf(self);
            [self.vm network_switchGoogleWithRequestParams:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:switchFun.isOn]] withInputCodeDic:data success:^(id data) {
                kStrongSelf(self);
                [self postSwitchFuncStatus];
                
            } failed:^(id data) {
                kStrongSelf(self);
                [self postSwitchFuncStatus];
            } error:^(id data) {
                kStrongSelf(self);
                [self postSwitchFuncStatus];
            }];
        }];
        
        [popupView disMissActionBlock:^(id data) {
            [self postSwitchFuncStatus];
        }];
    }else{
        kWeakSelf(self);
        [self.vm network_switchGoogleWithRequestParams:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:switchFun.isOn]] withInputCodeDic:@{} success:^(id data) {
            kStrongSelf(self);
            [self postSwitchFuncStatus];
            
        } failed:^(id data) {
            kStrongSelf(self);
            [self postSwitchFuncStatus];
        } error:^(id data) {
            kStrongSelf(self);
            [self postSwitchFuncStatus];
        }];
    }
    
}
-(void)releaseBtnClick{
    InputPWPopUpView* popupView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero WithIsForceShowGoogleCodeField:YES];
    [popupView showInApplicationKeyWindow];
    [popupView actionBlock:^(id data) {
        kWeakSelf(self);
        [self.vm network_dismissGoogleWithRequestParams:data success:^(id data) {
            kStrongSelf(self);
            ReleaseSuccessViewController * releaseVC = [[ReleaseSuccessViewController alloc] init];
            [self.navigationController pushViewController:releaseVC animated:YES];
        } failed:^(id data) {
            
        } error:^(id data) {
            
        }];
        
        
    }];
    [popupView disMissActionBlock:^(id data) {
        [self postSwitchFuncStatus];
    }];
//    ReleaseGoogleOneViewController * releaseVC = [[ReleaseGoogleOneViewController alloc] init];
//    [self.navigationController pushViewController:releaseVC animated:YES];
}

-(UISwitch *)switchFunc{
    if(_switchFunc == nil){
        _switchFunc = [[UISwitch alloc]init];
        [_switchFunc setBackgroundColor:HEXCOLOR(0xf2f2f2)];
        [_switchFunc setOnTintColor:HEXCOLOR(0x4c7fff)];
        [_switchFunc setThumbTintColor:[UIColor whiteColor]];
        _switchFunc.layer.cornerRadius = 15.5f;
        _switchFunc.layer.borderWidth = 1.0f;
        _switchFunc.layer.borderColor = HEXCOLOR(0xd0d0d0).CGColor;
        _switchFunc.layer.masksToBounds = YES;
        //        默认大小 51.0f 31.0f
    }
    return _switchFunc;
}

- (GoogleSecretVM *)vm {
    if (!_vm) {
        _vm = [GoogleSecretVM new];
    }
    return _vm;
}

- (LoginVM *)loginVM {
    if (!_loginVM) {
        _loginVM = [LoginVM new];
    }
    return _loginVM;
}
@end
