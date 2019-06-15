//
//  NoGoogleOneViewController.m
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import "NoGoogleOneViewController.h"
#import "NoGoogleTwoViewController.h"

#import "GoogleSecretVM.h"
#import "GoogleSecretModel.h"
#import "LoginModel.h"
@interface NoGoogleOneViewController (){
    
    UIView * oneView;
    
}
@property(nonatomic,strong)UILabel * keyLb;
@property (nonatomic, strong) GoogleSecretVM* vm;
@property (nonatomic, strong) GoogleSecretModel* requestParams;
@property (nonatomic, assign) BOOL ispresent;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIImageView *decorIv;
@end

@implementation NoGoogleOneViewController

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
    
    //提示文字
    NSString * textStr = @"最好将16位密钥记录在纸上，并保存在安全的地方。如遇手机丢失，你可以通过该密钥恢复你的谷歌验证";
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, 50 * SCALING_RATIO, MAINSCREEN_WIDTH - 60 * SCALING_RATIO, 79 * SCALING_RATIO)];
    lab.font = [UIFont systemFontOfSize:17 * SCALING_RATIO];
    lab.text = textStr;
    lab.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17 * SCALING_RATIO],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    lab.attributedText = [[NSAttributedString alloc] initWithString:lab.text attributes:attributes];
    lab.textColor = COLOR_RGB(57, 67, 104, 1);
    lab.textAlignment = NSTextAlignmentCenter;
    
    UIView * textBaseView = [[UIView alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO, CGRectGetMaxY(lab.frame) + 25, MAINSCREEN_WIDTH - 52 * SCALING_RATIO, 45)];
    textBaseView.backgroundColor = [UIColor whiteColor];
    textBaseView.layer.cornerRadius = 5;
    textBaseView.layer.masksToBounds = YES;
    [self.view addSubview:textBaseView];
    
    self.keyLb = [[UILabel alloc] initWithFrame:CGRectMake(17 * SCALING_RATIO, 14, 150, 18)];
    
    self.keyLb.font = [UIFont systemFontOfSize:13];
    [textBaseView addSubview:self.keyLb];
    
    UILabel * copyLb = [[UILabel alloc] initWithFrame:CGRectMake(textBaseView.frame.size.width - 30 - 17*SCALING_RATIO, 14, 30, 18)];
    copyLb.text = @"复制";
    copyLb.font = [UIFont systemFontOfSize:14];
    [textBaseView addSubview:copyLb];
    
    UIImageView * copyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(copyLb.frame) - 18 - 7, 13, 18, 20)];
    copyImgView.image = [UIImage imageNamed:@"icopy_blue_rightup"];
    [textBaseView addSubview:copyImgView];
    
    UIButton * copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(copyImgView.frame), 0, 70, 45)];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [textBaseView addSubview:copyBtn];
    

    
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
    _accLab.text = @"下载并安装";
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73-19);
    }];
    
    kWeakSelf(self);
    [self.view goBackBlackButtonInSuperView:self.view
                            leftButtonEvent:^(id data) {
                                kStrongSelf(self);
                                
                                [self goBack];
                            }];
    
    oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MAINSCREEN_WIDTH, 288* SCALING_RATIO)];
    oneView = UIView.new;
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    //
    //提示文字
    NSString * textStr = @"最好将16位密钥记录在纸上，并保存在安全的地方。如遇手机丢失，你可以通过该密钥恢复你的谷歌验证";
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, (150) * SCALING_RATIO, MAINSCREEN_WIDTH - 60 * SCALING_RATIO, 79 * SCALING_RATIO)];
    lab.font = [UIFont systemFontOfSize:17 * SCALING_RATIO];
    lab.text = textStr;
    lab.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17 * SCALING_RATIO],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    lab.attributedText = [[NSAttributedString alloc] initWithString:lab.text attributes:attributes];
    lab.textColor = COLOR_RGB(57, 67, 104, 1);
    lab.textAlignment = NSTextAlignmentCenter;
    
    UIView * textBaseView = [[UIView alloc] initWithFrame:CGRectMake(26 * SCALING_RATIO, CGRectGetMaxY(lab.frame) + 25, MAINSCREEN_WIDTH - 52 * SCALING_RATIO, 45)];
    textBaseView.backgroundColor = [UIColor whiteColor];
    textBaseView.layer.cornerRadius = 5;
    textBaseView.layer.masksToBounds = YES;
    [self.view addSubview:textBaseView];
    
    self.keyLb = [[UILabel alloc] initWithFrame:CGRectMake(17 * SCALING_RATIO, 14, 150, 18)];
    
    self.keyLb.font = [UIFont systemFontOfSize:13];
    [textBaseView addSubview:self.keyLb];
    
    UILabel * copyLb = [[UILabel alloc] initWithFrame:CGRectMake(textBaseView.frame.size.width - 30 - 17*SCALING_RATIO, 14, 30, 18)];
    copyLb.text = @"复制";
    copyLb.font = [UIFont systemFontOfSize:14];
    [textBaseView addSubview:copyLb];
    
    UIImageView * copyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(copyLb.frame) - 18 - 7, 13, 18, 20)];
    copyImgView.image = [UIImage imageNamed:@"icopy_blue_rightup"];
    [textBaseView addSubview:copyImgView];
    
    UIButton * copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(copyImgView.frame), 0, 70, 45)];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [textBaseView addSubview:copyBtn];

    [self initView];
}

-(void)goBack{
    
    [self dismissViewControllerAnimated:false completion:^{
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"下载并安装";
    self.view.backgroundColor = COLOR_RGB(242, 241, 246, 1);
//    [self initView];
    
    kWeakSelf(self);
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    NSString *username = userInfoModel.userinfo.username;
    username = username ? username :@"17748334";
    [self.vm network_getGoogleSecretWithRequestParams:username success:^(id data) {
        kStrongSelf(self);
        self.requestParams = data;
        self.keyLb.text = self.requestParams.resultinfo.secret;
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}
-(void) initView{
    
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
    
    if (self.ispresent) {
        NoGoogleTwoViewController * twoVc = [[NoGoogleTwoViewController alloc] initWithStyle:@"present"];
        [self presentViewController:twoVc
                           animated:YES
                         completion:nil];
    }else{
        NoGoogleTwoViewController * twoVc = [[NoGoogleTwoViewController alloc] initWithStyle:@"push"];
        [self.navigationController pushViewController:twoVc
                                             animated:YES];
    }
}

-(void)copyBtnClick{
    //复制到剪贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.keyLb.text;
    if (pasteboard.string.length > 0) {
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

- (GoogleSecretVM *)vm {
    if (!_vm) {
        _vm = [GoogleSecretVM new];
    }
    return _vm;
}
@end
