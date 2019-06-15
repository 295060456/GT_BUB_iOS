//
//  NoGoogleFourViewController.m
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import "NoGoogleFourViewController.h"
#import "NoGoogleFiveViewController.h"
#import "GoogleSecretVM.h"
@interface NoGoogleFourViewController ()<UITextFieldDelegate>{
    NSString * loginPWStr;
    NSString * googleCodeStr;
    UIView * oneView;
}
@property (nonatomic, strong) GoogleSecretVM* vm;
@property (nonatomic, strong) NSString* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, assign) BOOL ispresent;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIImageView *decorIv;
@end


@implementation NoGoogleFourViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                     style:(NSString *)style
                   success:(DataBlock)block
{
    NoGoogleFourViewController *vc = [[NoGoogleFourViewController alloc] initWithStyle:style];
    vc.block = block;
    vc.requestParams = requestParams;
    
    if ([style isEqualToString:@"push"]) {
        
        [rootVC.navigationController pushViewController:vc
                                               animated:true];
        
    }else if ([style isEqualToString:@"present"]){
        
        [rootVC presentViewController:vc
                             animated:YES
                           completion:nil];
    }
    
    return vc;
}

-(instancetype)initWithStyle:(NSString *)style{
    
    if (self = [super init]) {
        
        if ([style isEqualToString:@"push"]) {
            
            self.ispresent = NO;
            
            [self push];
            
        }else if ([style isEqualToString:@"present"]){
            
            self.ispresent = YES;
            
            [self present];
        }
    }
    
    return self;
}

-(void)push{
    
    UILabel * googleCodeLb = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, 51 , 315 * SCALING_RATIO, 29)];
    googleCodeLb.text = @"谷歌验证码";
    googleCodeLb.textColor = COLOR_RGB(57, 67, 104, 1);
    googleCodeLb.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:googleCodeLb];
    
    UIView * textBaseView1 = [[UIView alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO, CGRectGetMaxY(googleCodeLb.frame) + 12, 320 * SCALING_RATIO, 45)];
    textBaseView1.backgroundColor = [UIColor whiteColor];
    textBaseView1.layer.cornerRadius = 5;
    textBaseView1.layer.masksToBounds = YES;
    [self.view addSubview:textBaseView1];
    
    UITextField * googleCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO + 20, CGRectGetMaxY(googleCodeLb.frame) + 12, 320 * SCALING_RATIO - 40, 45)];
    googleCodeTF.placeholder = @"6位数字";
    googleCodeTF.font = [UIFont systemFontOfSize:15];
    googleCodeTF.tag = EnumActionTag1;
    googleCodeTF.secureTextEntry = YES;
    googleCodeTF.delegate = self;
    [self.view addSubview:googleCodeTF];
    
    [self initView];
}

-(void)present{
    
    UIImage* decorImage = kIMG(@"");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 64+19));//219
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    _decorIv.backgroundColor = kWhiteColor;
    
    _accLab = UILabel.new;
    _accLab.text = @"完成绑定";
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73-19);
    }];
    
    kWeakSelf(self);
    
    [self.view goBackEmptyContentButtonInSuperView:self.view
                                   leftButtonEvent:^(id data) {
                                       kStrongSelf(self);
                                       
                                       [self goBack];
                                   }];
    
    oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MAINSCREEN_WIDTH, 288* SCALING_RATIO)];
    oneView = UIView.new;
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    //
    
    UILabel * googleCodeLb = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, 150 , (315) * SCALING_RATIO, 29)];
    googleCodeLb.text = @"谷歌验证码";
    googleCodeLb.textColor = COLOR_RGB(57, 67, 104, 1);
    googleCodeLb.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:googleCodeLb];
    
    UIView * textBaseView1 = [[UIView alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO, CGRectGetMaxY(googleCodeLb.frame) + 12, 320 * SCALING_RATIO, 45)];
    textBaseView1.backgroundColor = [UIColor whiteColor];
    textBaseView1.layer.cornerRadius = 5;
    textBaseView1.layer.masksToBounds = YES;
    [self.view addSubview:textBaseView1];
    
    UITextField * googleCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO + 20, CGRectGetMaxY(googleCodeLb.frame) + 12, 320 * SCALING_RATIO - 40, 45)];
    googleCodeTF.placeholder = @"6位数字";
    googleCodeTF.font = [UIFont systemFontOfSize:15];
    googleCodeTF.tag = EnumActionTag1;
    googleCodeTF.secureTextEntry = YES;
    googleCodeTF.delegate = self;
    [self.view addSubview:googleCodeTF];
    
    [self initView];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:false completion:^{
        //        [super customerServiceLeftCurrentViewController];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"完成绑定";
    self.view.backgroundColor = COLOR_RGB(242, 241, 246, 1);
//    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    
    //底部按钮
    float y;
    if ([YBFrameTool statusBarHeight] > 21) {
        y = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49 - 20;
        
    }else{
        y = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49;
    }
    UIView * btnBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, y, MAINSCREEN_WIDTH, 100)];
    btnBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBaseView];
    
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(24,4, MAINSCREEN_WIDTH - 48, 40)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBaseView addSubview:nextBtn];
}

-(void)nextBtnClick{
    kWeakSelf(self);
    NSArray* arr = @[![NSString isEmpty:_requestParams]?_requestParams:@"",![NSString isEmpty:googleCodeStr]?googleCodeStr:@""] ;
    [self.vm network_bindingGoogleWithRequestParams:arr success:^(id data) {
        kStrongSelf(self);
        
        if (self.ispresent) {
            
            NoGoogleFiveViewController * fiveVC = [[NoGoogleFiveViewController alloc] initWithStyle:@"present"];
            [self presentViewController:fiveVC
                               animated:YES
                             completion:nil];
        }else{
            
            NoGoogleFiveViewController * fiveVC = [[NoGoogleFiveViewController alloc] initWithStyle:@"push"];
            [self.navigationController pushViewController:fiveVC
                                                 animated:YES];
        }
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == EnumActionTag1){
        googleCodeStr = ![NSString isEmpty:textField.text]?textField.text:@"";
    }
}

- (GoogleSecretVM *)vm {
    if (!_vm) {
        _vm = [GoogleSecretVM new];
    }
    return _vm;
}
@end
