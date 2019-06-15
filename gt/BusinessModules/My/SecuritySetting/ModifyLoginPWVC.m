//
//  ModifyLoginPWVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/20.
//  Copyright © 2018年 GT. All rights reserved.
//

#import "ModifyLoginPWVC.h"
#import "MyInputCell.h"
#import "LoginVM.h"
@interface ModifyLoginPWVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    NSArray * placeholderArr;//默认显示文字数组
    UIView * lineView;
    UIButton * nextBtn;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *dataSource;
@property(nonatomic,strong)LoginVM *loginVM;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)NSString *pw;
@property(nonatomic,copy)NSString *newpw;
@property(nonatomic,copy)NSString *sureNewPW;
@property(nonatomic,copy)NSString *googleCode;
@property(nonatomic,strong)NSString *resultCode;
@property(nonatomic,strong)NSString *sms;
@property(nonatomic,assign)Boolean isBoundGoogleSecret;//是否绑定
@end

@implementation ModifyLoginPWVC

-(instancetype)init{
    
    if (self = [super init]) {
        
        LoginModel *userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        
        self.isBoundGoogleSecret = [userInfoModel.userinfo.valigooglesecret boolValue];
        
        switch (self.isBoundGoogleSecret) {
            case 0:{//未绑定
                
                self.dataSource = @[@{@"原登录密码":@"请输入原登录密码"},
                                    @{@"新登录密码":@"请输入新登录密码"},
                                    @{@"确认新登录密码":@"请重复新登录密码"},
                                    @{@"手机短信验证码":@"请输入手机短信验证码"}];
            }
                break;
            case 1:{//已绑定
                
                self.dataSource = @[@{@"原登录密码":@"请输入原登录密码"},
                                    @{@"新登录密码":@"请输入新登录密码"},
                                    @{@"确认新登录密码":@"请重复新登录密码"},
                                    @{@"谷歌验证码":@"请输入谷歌验证码"}];
            }
                break;
            default:
                break;
        }
    }
    
    return self;
}

-(void)dealloc{
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    self.title = @"修改登录密码";
    
    [self initView];
}

-(void)initView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - 60 , MAINSCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
    if ([YBFrameTool statusBarHeight] > 21) {
        lineView.frame = CGRectMake(0, MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49 - 20, MAINSCREEN_WIDTH, 1);
        
    }else{
        lineView.frame = CGRectMake(0, MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 49, MAINSCREEN_WIDTH, 1);
    }
    [self.view addSubview:lineView];
    
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(lineView.frame) + 4, MAINSCREEN_WIDTH - 48, 40)];
    [nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

-(void)nextBtnClick{
    if (![NSString isEmpty:self.pw]&&
        ![NSString isEmpty:self.newpw]&&
        ![NSString isEmpty:self.sureNewPW]&&
        ![NSString isEmpty:self.resultCode]) {
        if (![self.newpw isEqualToString:self.sureNewPW]) {
            [YKToastView showToastText:@"创建失败：两次输入的密码不一致，请重新输入"];
            return;
        }else{
            kWeakSelf(self);
            [self.loginVM network_changeLoginPWWithRequestParams:self.requestParams
                                                 andIsGoogleCode:self.isBoundGoogleSecret== 1? YES:NO
                                                         success:^(id data) {
                                                             [weakself.navigationController popViewControllerAnimated:YES];
                                                         } failed:^(id data) {} error:^(id data) {}];
        }
    }else{
        [YKToastView showToastText:@"请完善资料"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MyInputCell cellHeightWithModel];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInputCell *cell = [MyInputCell cellWith:tableView];
    
    NSDictionary* model = self.dataSource[indexPath.row];
    
    [cell richElementsInCellWithModel:model WithIndexRow:indexPath.row];
    
   
    kWeakSelf(self);
    [cell actionBlock:^(id data,id data2) {
        
        UITextField * textField = data;
        
        EnumActionTag tag = textField.tag;
        kStrongSelf(self);
        switch (tag) {
            case EnumActionTag0:
                
                self.pw = data2;
                
                break;
            case EnumActionTag1:
                
                self.newpw = data2;
                
                break;
            case EnumActionTag2:
                
                self.sureNewPW = data2;
                
                break;
            case EnumActionTag3:
                //                self.googleCode = data2;
                
                switch (self.isBoundGoogleSecret) {
                    case 0:{//未绑定
                        
                        self.sms = data2;
                        
                        self.resultCode = self.sms;
                    }
                        break;
                    case 1:{//已绑定
                        
                        self.googleCode = data2;
                        
                        self.resultCode = self.googleCode;
                    }
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        
        NSArray* arr  = @[![NSString isEmpty:self.pw]?[NSString MD5WithString:self.pw isLowercase:YES]:@"",
                           ![NSString isEmpty:self.newpw]?[NSString MD5WithString:self.newpw isLowercase:YES]:@"",
                           ![NSString isEmpty:self.sureNewPW]?[NSString MD5WithString:self.sureNewPW isLowercase:YES]:@"",
                           ![NSString isEmpty:self.resultCode]?self.resultCode:@"",];
        
        self.requestParams = arr;
    }];
    
    return cell;
}

- (LoginVM *)loginVM {
    
    if (!_loginVM) {
        
        _loginVM = [LoginVM new];
    }
    
    return _loginVM;
}

@end
