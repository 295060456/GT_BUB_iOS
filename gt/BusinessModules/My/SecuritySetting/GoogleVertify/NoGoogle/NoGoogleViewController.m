//
//  NoGoogleViewController.m
//  gt
//
//  Created by cookie on 2018/12/24.
//  Copyright © 2018 GT. All rights reserved.
//

#import "NoGoogleViewController.h"
#import "NoGoogleOneViewController.h"
#import <StoreKit/StoreKit.h>

@interface NoGoogleViewController ()<SKStoreProductViewControllerDelegate>{
    UIView * oneView;
    UIImageView * GAImgView;
    
}

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, assign) BOOL ispresent;

@end

@implementation NoGoogleViewController

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
    
    GAImgView = [[UIImageView alloc] initWithFrame:CGRectMake(140 * SCALING_RATIO, 90 * SCALING_RATIO, 95 * SCALING_RATIO, 95 * SCALING_RATIO)];//80
    
    [self initView];
}

-(void)push{
    
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
    _accLab.text = @"";
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

    oneView = UIView.new;
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accLab.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    GAImgView = [[UIImageView alloc] initWithFrame:CGRectMake(140 * SCALING_RATIO, 56 * SCALING_RATIO, 95 * SCALING_RATIO, 95 * SCALING_RATIO)];//80
    
    [self initView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"下载并安装";
    self.view.backgroundColor = COLOR_RGB(242, 241, 246, 1);
//    [self initView];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:false completion:^{
//        [super customerServiceLeftCurrentViewController];
    }];
}

-(void)initView{
    
    GAImgView.image = [UIImage imageNamed:@"logo_GA"];
    [oneView addSubview:GAImgView];
    
    NSString *str = @"验证器 (Google Authenticator)";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(str.length - 21, 20)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(255, 146, 56, 1) range:NSMakeRange(str.length - 21, 20)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(57, 67, 104, 1) range:NSMakeRange(0, 5)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(57, 67, 104, 1) range:NSMakeRange(str.length - 1, 1)];
    UILabel * textOneLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(GAImgView.frame) + 28 * SCALING_RATIO, MAINSCREEN_WIDTH, 22)];
    textOneLb.text = @"首先,您需要在您的手机上安装一个谷歌";
    textOneLb.textColor = RGBCOLOR(57, 67, 104);
    textOneLb.font = [UIFont systemFontOfSize:17];
    textOneLb.textAlignment = NSTextAlignmentCenter;
    [oneView addSubview:textOneLb];
    
    UILabel * textTwoLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textOneLb.frame) + 4, MAINSCREEN_WIDTH, 22)];
    textTwoLb.attributedText = attrStr;
    textTwoLb.font = [UIFont systemFontOfSize:17];
    textTwoLb.textAlignment = NSTextAlignmentCenter;
    [oneView addSubview:textTwoLb];
    
    UIButton* downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [oneView addSubview:downloadBtn];
    downloadBtn.frame = CGRectMake(0, CGRectGetMaxY(textTwoLb.frame), MAINSCREEN_WIDTH, 42);
    downloadBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    NSDictionary *attriDic = @{NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                               NSForegroundColorAttributeName : [YBGeneralColor themeColor],
                               NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    NSAttributedString *leftStr = [[NSAttributedString alloc] initWithString:@"点此去下载" attributes:attriDic];
    [downloadBtn setAttributedTitle:leftStr forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadEvent) forControlEvents:UIControlEventTouchUpInside];
    //底部按钮
    float y;
    if ([YBSystemTool isIphoneX]) {
        y = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49 - 20;
        
    }else{
        y = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49;
    }
    UIView * btnBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, y, MAINSCREEN_WIDTH, 100)];
    btnBaseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBaseView];
    
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(24,4, MAINSCREEN_WIDTH - 48, 40)];
    [nextBtn setTitle:@"我已下载，下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBaseView addSubview:nextBtn];
}

- (void)downloadEvent{
    
    kWeakSelf(self);
    
    [Judgement_Environment isSimulator];
    
    if (![Judgement_Environment isSimulator]) {
        
        NSString* appID = @"388497605";
        
        [SVProgressHUD show];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        SKStoreProductViewController * vc = [[SKStoreProductViewController alloc] init];
        
        vc.delegate = self;
        
        NSDictionary * dic = @{SKStoreProductParameterITunesItemIdentifier:appID};
        
        [vc loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
            
            [SVProgressHUD dismiss];
            
            kStrongSelf(self);
            
            if (error) {
                
                NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
                
                // 提示用户发生了错误
                // 或者通过 URL 打开 AppStore App.
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/id%@",appID]];
                //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID]];
                
                if (@available(iOS 10.0, *)) {
                    
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                
                [self presentViewController:vc animated:YES completion:NULL];
            }
        }];
    }else{
        
        [YKToastView showToastText:@"Xcode模拟器不支持此操作"];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)nextBtnClick{
    
    [Judgement_Environment isSimulator];
    
    if (![Judgement_Environment isSimulator]) {
        
        if (self.ispresent) {
            
            NoGoogleOneViewController * oneVc = [[NoGoogleOneViewController alloc] initWithStyle:@"present"];
            
            [self presentViewController:oneVc
                               animated:YES
                             completion:nil];
        }else{
            
            NoGoogleOneViewController * oneVc = [[NoGoogleOneViewController alloc] initWithStyle:@"push"];
            
            [self.navigationController pushViewController:oneVc
                                                 animated:YES];
        }
    }else{
        
        [YKToastView showToastText:@"Xcode模拟器不支持此操作"];
    }
}


@end
