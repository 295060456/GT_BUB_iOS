//
//  SettingNicknameVC.m
//  gt
//
//  Created by Administrator on 02/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "SettingNicknameVC.h"
#import "LoginModel.h"
#import "LoginVM.h"

@interface SettingNicknameVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nicknameTF;
@property(nonatomic,strong)UIButton *settingBtn;

@property(nonatomic,copy)NSString* requestParams;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,strong)LoginVM *loginVM;

@end

@implementation SettingNicknameVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block{
    
    SettingNicknameVC *vc = [[SettingNicknameVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    
    return vc;
}
-(void)dealloc{
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(0xF7F8F9);
    
    self.title = @"设置昵称";
    
    self.settingBtn.frame = CGRectMake(0, 0, 44, 54);
    
    UIView *view = UIView.new;
    
    view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(10);
        
        make.left.right.equalTo(self.view);
        
        make.height.mas_equalTo(SCALING_RATIO * 60);
    }];
    
    [self.view addSubview:self.nicknameTF];
    
    [self.nicknameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.height.equalTo(view);
        
        make.left.equalTo(view).offset(20 * SCALING_RATIO);
        
        make.right.equalTo(view).offset(-20 * SCALING_RATIO);
    }];
}

-(void)confirmNickNAME{
    
    kWeakSelf(self);
    
    [self.loginVM network_getChangeNicknameWithRequestParams:self.nicknameTF.text
                                                success:^(id model) {
                                                    
                                                    kStrongSelf(self);
                                                    
                                                    if (self.block) {
                                                        
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                        
                                                        self.block(self.nicknameTF.text);
                                                    }
                                                }
                                                 failed:^(id model){
                                                     
                                                 }
                                                  error:^(id model){
                                                      
                                                  }];
}

-(UITextField *)nicknameTF{
    
    if (!_nicknameTF) {
        
        _nicknameTF = UITextField.new;
        
        _nicknameTF.delegate = self;
        
        _nicknameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _nicknameTF.placeholder = @"请设置您的昵称";
    }
    
    return _nicknameTF;
}

-(UIButton *)settingBtn{
    
    if (!_settingBtn) {
        
        _settingBtn = UIButton.new;
        
        _settingBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [_settingBtn setTitle:@"完成"
                     forState:UIControlStateNormal];
        
        _settingBtn.titleLabel.font  = kFontSize(18);
        
        [_settingBtn setTitleColor:[YBGeneralColor themeColor]
                          forState:UIControlStateNormal];
        
        [_settingBtn addTarget:self
                        action:@selector(confirmNickNAME)
              forControlEvents:UIControlEventTouchUpInside];
        
        [_settingBtn sizeToFit];
        
        UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_settingBtn];
        
        self.navigationItem.rightBarButtonItem = settingBtnItem;
    }
    
    return _settingBtn;
}

-(LoginVM *)loginVM{
    
    if (!_loginVM) {
        
        _loginVM = LoginVM.new;
    }
    
    return _loginVM;
}

@end
