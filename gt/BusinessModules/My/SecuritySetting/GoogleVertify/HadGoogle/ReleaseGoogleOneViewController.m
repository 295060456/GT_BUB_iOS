//
//  ReleaseGoogleOneViewController.m
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ReleaseGoogleOneViewController.h"
#import "MQVerCodeInputView.h"
#import "ReleaseSuccessViewController.h"
#import "GoogleSecretVM.h"

@interface ReleaseGoogleOneViewController ()
@property (nonatomic, copy)NSString * googleCodeStr;
@property (nonatomic, strong) GoogleSecretVM* vm;
@end

@implementation ReleaseGoogleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"解除谷歌验证";
    self.view.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView{
    UILabel * titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, MAINSCREEN_WIDTH, 28)];
    titleLb.text = @"输入谷歌验证码";
    titleLb.textColor = COLOR_RGB(57, 67, 104, 1);
    titleLb.font = [UIFont systemFontOfSize:20];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLb];
    
    //谷歌验证码输入框
    MQVerCodeInputView *verView = [[MQVerCodeInputView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH-50, 50)];
    verView.maxLenght = 6;//最大长度
    verView.keyBoardType = UIKeyboardTypeNumberPad;
    [verView mq_verCodeViewWithMaxLenght];
    verView.block = ^(NSString *text){
        self.googleCodeStr = text;
    };
    verView.center = self.view.center;
    verView.y = CGRectGetMaxY(titleLb.frame) + 46;
    [self.view addSubview:verView];

    UIButton * ReleaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(verView.frame) + 92, MAINSCREEN_WIDTH - 24 * 2, 42)];
    [ReleaseBtn setTitle:@"解除当前绑定" forState:UIControlStateNormal];
    [ReleaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ReleaseBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    ReleaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    ReleaseBtn.layer.cornerRadius = 5;
    ReleaseBtn.layer.masksToBounds = YES;
    [ReleaseBtn addTarget:self action:@selector(releaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ReleaseBtn];
    
}
-(void)releaseBtnClick{
    if ([NSString isEmpty:self.googleCodeStr]||self.googleCodeStr.length!=6) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的谷歌验证码"];
        return;
    }
    
    kWeakSelf(self);
    [self.vm network_dismissGoogleWithRequestParams:self.googleCodeStr success:^(id data) {
        kStrongSelf(self);
        ReleaseSuccessViewController * releaseVC = [[ReleaseSuccessViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}
- (GoogleSecretVM *)vm {
    if (!_vm) {
        _vm = [GoogleSecretVM new];
    }
    return _vm;
}
@end
