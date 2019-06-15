//
//  ReleaseSuccessViewController.m
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ReleaseSuccessViewController.h"
#import "SecuritySettingVC.h"

@interface ReleaseSuccessViewController ()
@property (nonatomic, strong) UIImageView *decorIv;
@end

@implementation ReleaseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"解除谷歌验证";
    [self initView];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
    self.navigationController.navigationItem.hidesBackButton = YES;


    // Do any additional setup after loading the view.
}
-(void)initView{
    UIImage* decorImage = kIMG(@"login_top");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX); make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 353));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    
    UIImageView * imgView = [[UIImageView alloc] init];
    UIImage* succImage = [UIImage imageNamed:@"releaseGoogleSucc"];
    imgView.image = succImage;
    [_decorIv addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73);
        make.size.mas_equalTo(CGSizeMake(succImage.size.width, succImage.size.height));
    }];
    
    
    UIButton * backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    backBtn.layer.cornerRadius = 5;
    backBtn.layer.masksToBounds = YES;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    backBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.decorIv.mas_bottom).offset(0);
        //        make.top.equalTo(self.view).offset(359);//别用scrollView
        make.centerX.equalTo(self.decorIv);
        make.left.equalTo(self.decorIv).offset(76);
        make.height.mas_equalTo(@42);
        //        make.width.mas_equalTo(@225);
    }];
}

- (void)backBtnClick{
    //返回到安全设置控制器
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[SecuritySettingVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self backBtnClick];
    }
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
