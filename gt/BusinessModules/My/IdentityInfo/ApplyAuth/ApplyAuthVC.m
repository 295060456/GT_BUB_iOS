//
//  ApplyAuthVC.m
//  gt
//
//  Created by GT on 2019/1/26.
//  Copyright © 2019 GT. All rights reserved.
//

#import "ApplyAuthVC.h"
#import "ApplyAuthView.h"
#import "IdentityInfoVC.h"
@interface ApplyAuthVC ()
@property (nonatomic, strong) ApplyAuthView *applyAuthView;
@property (nonatomic, strong) UIScrollView *scrollview;
@end

@implementation ApplyAuthVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    ApplyAuthVC *vc = [[ApplyAuthVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"身份认证";
    [self createscrollview];
}
-(void)createscrollview{
    self.applyAuthView = [[ApplyAuthView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
//    self.applyAuthView.nickNameLab.text = _requestParams.userinfo.username;
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    self.scrollview.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
    self.scrollview.bounces = NO;//到边了就不能再拖地
    self.scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    
    [self.scrollview addSubview:self.applyAuthView];
    self.scrollview.contentSize = CGSizeMake(MAINSCREEN_WIDTH, (MAINSCREEN_HEIGHT+[YBFrameTool tabBarHeight]));
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"我要申请实名认证" leftButtonEvent:^(id data) {
        [self onClickConfirmBtn];
    }];
}
-(void)onClickConfirmBtn {
    [IdentityInfoVC pushFromVC:self requestParams:@1 success:^(id data) {
        
    }];
}
@end
