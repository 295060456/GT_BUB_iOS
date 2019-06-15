//
//  RecoverPwCarVC.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OtherFindPwdVC.h"
#import "RecoverPwCarCell.h"
#import "UpLoadImageHV.h"
#import "AliyunQuery.h"
#import "LoginVM.h"
#import "longForgetSuccessView.h"

@interface OtherFindPwdVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataAr;
@property (nonatomic, assign) RecoverPwCarVCType mytype;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, strong) NSMutableArray *dataStringAr;
@property (nonatomic, strong) NSString *imageUrlS;
@property (nonatomic, strong) UIImageView *foodCarIm;
@end

@implementation OtherFindPwdVC
+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(nullable id )requestParams  withType:(RecoverPwCarVCType)type success:(DataBlock)block{
    OtherFindPwdVC *vc = [[OtherFindPwdVC alloc] init];
    vc.block = block;
    vc.mytype = type;
    vc.requestParams = requestParams;
    [rootVC presentViewController:vc animated:YES completion:nil];
    return vc;
}

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    kWeakSelf(self);
    self.dataStringAr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@""]];
    if (self.mytype == recoverPwCar) {
        self.dataAr = @[@{@"手机号":@"请输入手机号"},
                        @{@"姓名":@"请输入姓名"},
                        @{@"身份证":@"请输入身份证号"},
                        @{@"邮箱":@"请输入邮箱"}];
    }else if (self.mytype == recoverPwBUBP){
        self.dataAr = @[@{@"AA":@"输入手机号"},
                        @{@"AA":@"输入BUB支付密码"},
                        @{@"AA":@"请输入邮箱"}];
    }else if (self.mytype == recoverPwGoogleCode){
        self.dataAr = @[@{@"AA":@"请输入手机号"},
                        @{@"AA":@"请输入Google Authenticator验证码"},
                        @{@"AA":@"请输入邮箱"}];
    }else{
        self.dataAr = @[];
    }
    [self initTableViewAdd];
    
}

-(void)initTableViewAdd{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:tableView];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, -100, MAINSCREEN_WIDTH, 186*SCALING_RATIO)];
    //    headerV.backgroundColor = kRedColor;
    tableView.tableHeaderView = headerV;
    
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, 96*SCALING_RATIO, 150*SCALING_RATIO, 29*SCALING_RATIO)];
    titleLa.text = @"密码找回";
    titleLa.font = kFontSize(28*SCALING_RATIO);
    titleLa.textColor = HEXCOLOR(0x333333);
    [headerV addSubview:titleLa];
    
    UILabel *titleContentLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(titleLa.frame) + 11 *SCALING_RATIO, 300*SCALING_RATIO, 29*SCALING_RATIO)];
    titleContentLa.text = @"币友将会在7个工作日内审核完成";
    titleContentLa.font = kFontSize(16*SCALING_RATIO);
    titleContentLa.textColor = HEXCOLOR(0x8c96a5);
    [headerV addSubview:titleContentLa];
    [self initHeaderView:tableView];
    kWeakSelf(self);
    [self.view regiestBackButtonInTableViewSuperView:tableView leftButtonEvent:^(id data) {
        [weakself goBack];
    }];
    //    [tableView reloadData];
}

- (void)initHeaderView:(UITableView*) tableView{
    float hi = 100*SCALING_RATIO;
    if (self.mytype == recoverPwCar) {
        hi = 330*SCALING_RATIO;
    }
    UIView *foodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, hi)];
    foodView.backgroundColor = kWhiteColor;
    tableView.tableFooterView = foodView;
    if (self.mytype == recoverPwCar) {
        UILabel *foodLa = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, 30 *SCALING_RATIO, 200*SCALING_RATIO, 17*SCALING_RATIO)];
        foodLa.text = @"请上传手持身份证照片";
        foodLa.font = kFontSize(16*SCALING_RATIO);
        foodLa.textColor = HEXCOLOR(0x333333);
        [foodView addSubview:foodLa];
        
        self.foodCarIm = [[UIImageView alloc] initWithFrame:CGRectMake(39*SCALING_RATIO, 67*SCALING_RATIO, 297*SCALING_RATIO, 164*SCALING_RATIO)];
        self.foodCarIm.image = kIMG(@"idCarXiran");
        self.foodCarIm.userInteractionEnabled = YES;
        [foodView addSubview:self.foodCarIm];
        UITapGestureRecognizer *foodTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foodCarImTap)];
        [self.foodCarIm addGestureRecognizer:foodTap];
    }
    float hit = 30*SCALING_RATIO;
    if (self.mytype == recoverPwCar) {
        hit = 263*SCALING_RATIO;
    }
    
    UIButton *getCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH - 148*SCALING_RATIO, hit, 118*SCALING_RATIO, 48*SCALING_RATIO);
    [getCodeBu setTitle:@"提交"
               forState:UIControlStateNormal];
    [self.view addSubview:getCodeBu];
    [getCodeBu setTintColor:HEXCOLOR(0xf7f9fa)];
    getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
    getCodeBu.layer.masksToBounds = YES;
    getCodeBu.layer.cornerRadius = 25*SCALING_RATIO;
    [getCodeBu addTarget:self
                  action:@selector(getCodeBtnClick)
        forControlEvents:UIControlEventTouchUpInside];
    [foodView addSubview:getCodeBu];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mytype == recoverPwCar) {
          return 76*SCALING_RATIO;
    }else{
          return 64*SCALING_RATIO;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecoverPwCarCell *cell = [RecoverPwCarCell cellWith:tableView];
    NSDictionary* model = self.dataAr[indexPath.row];
    [cell richElementsInAddAccountCellWithModel:model WithIndexRow:indexPath.row];
    //    WS(weakSelf);
    kWeakSelf(self);
    [cell actionBlock:^(id data,id data2) {
        UITextField * textField = data;
        EnumActionTag tag = textField.tag;
        [weakself.dataStringAr replaceObjectAtIndex:tag withObject:data2];
        
    }];
    return cell;
}

-(void)foodCarImTap{
    
    [self pickImageFromAlbumWithCompletionHandler:^(NSData *imageData, UIImage *image) {
        self.foodCarIm.image = image;
        [SVProgressHUD showWithStatus:@"上传中..."];
        kWeakSelf(self);
        [AliyunQuery uploadImageToAlyun:image title:@"IDcard" completion:^(NSString *imgUrl) {
            __strong typeof(weakself) strongSelf = self;
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (strongSelf && ![NSString isEmpty:imgUrl]) {
                    strongSelf.imageUrlS = imgUrl;
                }else{
                    [SVProgressHUD showErrorWithStatus:@"身份证照片上传失败，请重提交"];
                }
            });
        }];
    }];
    
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getCodeBtnClick{  //.提交数据
    [self.view endEditing:YES];
    NSString *phoneSt = self.dataStringAr[0];
    NSString *nameS = self.dataStringAr[1];
    NSString *carIDS = self.dataStringAr[2];
    NSString *youxXS = self.dataStringAr[3];
    if (self.mytype == recoverPwCar) {
        if (phoneSt == nil || phoneSt.length < 1) {
            [YKToastView showToastText:@"请填写手机号码"];
            return;
        }
        if (phoneSt.length<5) {
            [YKToastView showToastText:@"您输入的手机号过短，至少5位数哦"];
            return;
        }
        if (phoneSt.length>20||phoneSt.length==20) {
            [YKToastView showToastText:@"您输入的手机号过长，最长不超过20位哦"];
            return;
        }
        if (![NSString judgeiphoneNumberInt:phoneSt]) {
            [YKToastView showToastText:@"输入手机号必须是整数哦"];
            return;
        }
        if (nameS == nil || nameS.length < 0.5) {
            [YKToastView showToastText:@"请填写姓名"];
            return;
        }
        if (carIDS == nil
            || carIDS.length < 0.5) {
            [YKToastView showToastText:@"请填写身份证号"];
            return;
        }
        if (carIDS.length<10) {
            [YKToastView showToastText:@"您输入的身份证号过短，至少10位数哦"];
            return;
        }
        if (carIDS.length>20||carIDS.length==20) {
            [YKToastView showToastText:@"您输入的身份证号过长，最长不超过20位哦"];
            return;
        }
        if (youxXS == nil || youxXS.length<0.5) {
            [YKToastView showToastText:@"请填写邮箱"];
            return;
        }
        if (youxXS.length<4) {
            [YKToastView showToastText:@"您输入的邮箱过短，至少4位数哦"];
            return;
        }
        if (youxXS.length>35) {
            [YKToastView showToastText:@"您输入的邮箱不能超过35位数哦"];
            return;
        }
        if (self.imageUrlS == nil || self.imageUrlS.length<2) {
            [YKToastView showToastText:@"请再次上传手持身份证照片"];
            return;
        }
        // t提交s数据
        NSArray *findPwdArr = @[
                                phoneSt,//用户名
                                @"1",//申诉类型:1、已实名找回 2、BUB支付密码找回 3、Google Anthenticator找回 4、申诉找回
                                nameS,//姓名
                                carIDS,//身份证号码
                                youxXS,//邮箱
                                self.imageUrlS,//手持身份证照片
                                @""//支付密码 或 谷歌验证码
                                ];
        [self networkFindPasswordSubmit:findPwdArr];
        
    }else if (self.mytype == recoverPwBUBP){
        if (phoneSt == nil || phoneSt.length < 1) {
            [YKToastView showToastText:@"请填写手机号码"];
            return;
        }
        if (phoneSt.length<5) {
            [YKToastView showToastText:@"输入的手机号过短，至少5位数哦"];
            return;
        }
        if (phoneSt.length>20||phoneSt.length==20) {
            [YKToastView showToastText:@"输入的手机号过长，最长不超过20位哦"];
            return;
        }
        if (![NSString judgeiphoneNumberInt:phoneSt]) {
            [YKToastView showToastText:@"输入手机号必须是整数哦"];
            return;
        }
        if (nameS == nil || nameS.length < 0.5) {
            [YKToastView showToastText:@"请填写BUB支付密码"];
            return;
        }
        if (nameS.length<6) {
            [YKToastView showToastText:@"请填写正确的BUB支付密码"];
            return;
        }
        if (carIDS == nil
            || carIDS.length < 0.5) {
            [YKToastView showToastText:@"请填写邮箱"];
            return;
        }
        if (carIDS.length<4) {
            [YKToastView showToastText:@"输入的邮箱过短，至少4位数哦"];
            return;
        }
        if (carIDS.length>35) {
            [YKToastView showToastText:@"输入的邮箱不能超过35位数哦"];
            return;
        }
        // 提交数据 BUB 支付密码找密码
        nameS = [NSString MD5WithString:nameS isLowercase:YES];
        NSArray *bubAr = @[
                           phoneSt,//用户名
                           @"2",//申诉类型:1、已实名找回 2、BUB支付密码找回 3、Google Anthenticator找回 4、申诉找回
                           @"",//姓名
                           @"",//身份证号码
                           carIDS,//邮箱
                           @"",//手持身份证照片
                           nameS,//支付密码
                           ];
        [self networkFindPasswordSubmit:bubAr];
        
    }else if (self.mytype == recoverPwGoogleCode){
        if (phoneSt == nil || phoneSt.length < 1) {
            [YKToastView showToastText:@"请填写手机号码"];
            return;
        }
        if (phoneSt.length<5) {
            [YKToastView showToastText:@"输入的手机号过短，至少5位数哦"];
            return;
        }
        if (phoneSt.length>20||phoneSt.length==20) {
            [YKToastView showToastText:@"输入的手机号过长，最长不超过20位哦"];
            return;
        }
        if (![NSString judgeiphoneNumberInt:phoneSt]) {
            [YKToastView showToastText:@"输入手机号必须是整数哦"];
            return;
        }
        if (nameS == nil || nameS.length < 0.5) {
            [YKToastView showToastText:@"请输入Google Authenticator验证码"];
            return;
        }
        if (nameS.length<2) {
            [YKToastView showToastText:@"请填写正确的Google Authenticator支付密码"];
            return;
        }
        if (carIDS == nil
            || carIDS.length < 0.5) {
            [YKToastView showToastText:@"请填写邮箱"];
            return;
        }
        if (carIDS.length<4) {
            [YKToastView showToastText:@"您输入的邮箱过短，至少4位数哦"];
            return;
        }
        if (carIDS.length>35) {
            [YKToastView showToastText:@"您输入的邮箱不能超过35位数哦"];
            return;
        }
        // 提交数据google密码找密码
        NSArray *googleAr = @[
                              phoneSt,//用户名
                              @"3",//申诉类型:1、已实名找回 2、BUB支付密码找回 3、Google Anthenticator找回 4、申诉找回
                              @"",//姓名
                              @"",//身份证号码
                              carIDS,//邮箱
                              @"",//手持身份证照片
                              nameS,// 谷歌验证码
                              ];
        [self networkFindPasswordSubmit:googleAr];
    }
}

-(void)networkFindPasswordSubmit:(NSArray *)dataArr{
    kWeakSelf(self);
    [LoginVM networkidentityVertifyWithRequestParams:dataArr
                                             success:^(id data) {
                                                 NSLog(@"success = %@",data);
                                                 longForgetSuccessView *vi = [[longForgetSuccessView alloc] initFogetGetPwViewWith:successApplication  Bolck:^(NSInteger types, id data) {
                                                     [weakself gotHomeVC];
                                                 }];
                                                 [weakself.view addSubview:vi];
                                             }failed:^(id data) {
                                             } error:^(id data) {}];
}

-(void)gotHomeVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_HomeRootVC object:nil];
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
