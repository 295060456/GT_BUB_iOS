//
//  NOGoogleThreeViewController.m
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import "NOGoogleThreeViewController.h"
#import "NoGoogleFourViewController.h"

@interface NOGoogleThreeViewController (){
    
    UIView * oneView;
}
@property (nonatomic, strong) NSString* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, assign) BOOL ispresent;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIImageView *decorIv;


@end

@implementation NOGoogleThreeViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                     style:(NSString *)style
                   success:(DataBlock)block
{
    NOGoogleThreeViewController *vc = [[NOGoogleThreeViewController alloc] initWithStyle:style];
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
    
    NSString * textStr = @"您需要在谷歌验证器APP中添加一个BUB Pay账号,并手动输入16位密钥";
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, 50 * SCALING_RATIO, MAINSCREEN_WIDTH - 60 * SCALING_RATIO, 55 * SCALING_RATIO)];
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
    
    UIImageView * googleImg = [[UIImageView alloc] initWithFrame:CGRectMake(20 * SCALING_RATIO, CGRectGetMaxY(lab.frame) + 25, 312 * SCALING_RATIO, 357 * SCALING_RATIO)];
    googleImg.image = [UIImage imageNamed:@"safe_GA_img"];
    [self.view addSubview:googleImg];
    
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
    NSString * textStr = @"您需要在谷歌验证器APP中添加一个BUB Pay账号,并手动输入16位密钥";
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(30 * SCALING_RATIO, (150) * SCALING_RATIO, MAINSCREEN_WIDTH - 60 * SCALING_RATIO, 55 * SCALING_RATIO)];
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
    
    UIImageView * googleImg = [[UIImageView alloc] initWithFrame:CGRectMake(20 * SCALING_RATIO, CGRectGetMaxY(lab.frame) + 25, 312 * SCALING_RATIO, 357 * SCALING_RATIO)];
    googleImg.image = [UIImage imageNamed:@"safe_GA_img"];
    [self.view addSubview:googleImg];
    
    [self initView];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"设置验证码";
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
    
    if (self.ispresent) {
        
        [NoGoogleFourViewController pushFromVC:self
                                 requestParams:_requestParams
                                         style:@"present"
                                       success:^(id data) {
                                           
                                       }];
    }else{
        
        [NoGoogleFourViewController pushFromVC:self
                                 requestParams:_requestParams
                                         style:@"push"
                                       success:^(id data) {
            
        }];
    }
}

@end
