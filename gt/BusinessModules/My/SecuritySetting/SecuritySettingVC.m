//
//  SecuritySettingVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//  安全设置

#import "SecuritySettingVC.h"
#import "ModifyFundPWVC.h"
#import "ModifyLoginPWVC.h"
#import "GoogleVerificationViewController.h"
#import "NoGoogleViewController.h"

#import "LoginModel.h"
#import "LoginVM.h"
@interface SecuritySettingVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UIButton* bottomSingleBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel* lab;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong) LoginModel* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSArray * titleArr;
@property (nonatomic, copy)NSArray * titleValues;

@property (nonatomic, strong) NSMutableArray *leftLabs;
@property (nonatomic, strong) NSMutableArray *rightLabs;

@property(nonatomic,copy)NSString* nickString;
@property(nonatomic,copy)NSString* fundPWString;
@property(nonatomic,copy)NSString* sureFundPWString;
@end

@implementation SecuritySettingVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    SecuritySettingVC *vc = [[SecuritySettingVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    //    self.view.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
    self.title = @"安全设置";
    [self initView];
    self.tableView.hidden = YES;
    [self initNoSetFundPWView];
}

- (void)richElesSetFundPWView{
    self.tableView.hidden = NO;
    //    self.titleArr = @[@"昵称",@"支付密码",@"登录密码",@"谷歌验证"];
    self.titleArr = @[@"支付密码",@"登录密码",@"谷歌验证"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = UIView.new;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }];
    _scrollView.hidden = YES;
    _lab.hidden = YES;
    self.bottomSingleBtn.hidden = YES;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    lineView.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
    self.tableView.tableHeaderView = lineView;
    
    [self.tableView reloadData];
}

- (void)richElesNoSetFundPWView{
    self.tableView.hidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kTableViewBackgroundColor;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:-48.5);
    }];
    _scrollView.hidden = NO;
    _lab.hidden = NO;
    
    WS(weakSelf);
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"确认设置" leftButtonEvent:^(id data) {
        weakSelf.bottomSingleBtn = data;
        [weakSelf postSettingFundPW];
    }];
    _bottomSingleBtn.hidden = NO;
    
    self.tableView.tableHeaderView = [UIView new];
    [self.tableView reloadData];
}

- (void)initNoSetFundPWView{
    UILabel* lab = [UILabel new];
    _lab = lab;
    lab.textColor = HEXCOLOR(0x394368);
    lab.font = kFontSize(20);
    [self.tableView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@28);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    _scrollView = scrollView;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = kTableViewBackgroundColor;
    [self.tableView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(78, 20, 20, 20));
    }];
    //scrollView计算contentSize的时候，要先用一个containView填满整个scrollView，这样约束才能够准确计算
    // 这个containView是用来先填充整个scrollView的,到时候这个containView的size就是scrollView的contentSize
    UIView *containView = [UIView new];
    containView.userInteractionEnabled = YES;
    containView.backgroundColor = kTableViewBackgroundColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    _leftLabs = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        
        UIView *sub_view = [UIView new];
        sub_view.userInteractionEnabled = YES;
        //        sub_view.backgroundColor = RANDOMRGBCOLOR;
        
        UITextField* leftLab = [[UITextField alloc]init];
        leftLab.delegate = self;
        leftLab.text = @"";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x94368);
        leftLab.font = kFontSize(15);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(20);
            make.top.equalTo(sub_view).offset(.5);
            make.width.equalTo(sub_view.mas_width);//缩进
            make.bottom.equalTo(sub_view).offset(.5);
        }];
        [containView addSubview:sub_view];
        
        sub_view.layer.cornerRadius = 4;
        sub_view.layer.borderWidth = 1;
        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(40));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                //上2个
                lastView.backgroundColor = kWhiteColor;//HEXCOLOR(0xf2f1f6);
                lastView.layer.borderColor = kWhiteColor.CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);
                
                
            }
            
        }];
        //最后一个HEXCOLOR(0xf2f1f6)
        sub_view.backgroundColor = kWhiteColor;
        sub_view.layer.borderColor = kWhiteColor.CGColor;
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(15);
    }];
    
    [self initNoSetFundPWViewWithData];
}

- (void)initNoSetFundPWViewWithData{
    
    _lab.text = @"为了您的资金安全，请设置";
    
    UITextField* lab1 = _leftLabs[0];
    
    lab1.secureTextEntry = YES;
    lab1.placeholder = @"支付密码";
    
    
    UITextField* lab2 = _leftLabs[1];
    
    lab2.secureTextEntry = YES;
    lab2.placeholder = @"确认密码";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self postCheckInfo];
    
    
    
    //    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//}
//#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件
//-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
//    [self locateTabBar:3];
//    [self.navigationController popViewControllerAnimated:YES];
//
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITextField* lab1 = _leftLabs[0];
    UITextField* lab2 = _leftLabs[1];
    if ([textField isEqual: lab1]){
        self.fundPWString = ![NSString isEmpty:lab1.text]?lab1.text:@"";
    }
    else if ([textField isEqual: lab2]){
        self.sureFundPWString = ![NSString isEmpty:lab2.text]?lab2.text:@"";
    }
}
- (void)postSettingFundPW{
    NSArray* arr = @[
                     
                     ![NSString isEmpty:self.fundPWString]?self.fundPWString:@"",
                      ![NSString isEmpty:self.sureFundPWString]?self.sureFundPWString:@""
                      ];
    kWeakSelf(self);
    [self.vm network_settingFundPWWithRequestParams:arr success:^(id data) {
        
        [weakself postCheckInfo];
        
    } failed:^(id data) {
        //        kStrongSelf(self);
        
    } error:^(id data) {
        //        kStrongSelf(self);
        
    }];
}

//- (void)postCheckInfo{
//    kWeakSelf(self);
//    [self.vm network_inSecuritySettingCheckUserInfoWithRequestParams:@1
//                                                             success:^(id data,id data2) {
//                                                                 kStrongSelf(self);
//                                                                 LoginModel * model = data2;
//                                                                 self.requestParams = model;
//                                                                 if ([model.userinfo.istrpwd boolValue]==YES ) {
//                                                                     if ([model.userinfo.valigooglesecret boolValue]==NO){
//                                                                         self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"未验证"];
//                                                                     }
//                                                                     else{
//                                                                         if ([model.userinfo.safeverifyswitch boolValue]==YES) {
//                                                                             self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"已开启"];
//                                                                         }else{
//                                                                             self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"未开启"];
//                                                                         }
//                                                                     }
//                                                                     [self richElesSetFundPWView];
//                                                                 }else{
//                                                                     [self richElesNoSetFundPWView];
//                                                                 }
//
//                                                             } failed:^(id data) {
//                                                                 //        kStrongSelf(self);
//
//                                                             } error:^(id data) {
//                                                                 //        kStrongSelf(self);
//
//                                                             }];
//}

- (void)postCheckInfo{
    kWeakSelf(self);
    [self.vm network_inSecuritySettingCheckUserInfoWithRequestParams:@1
                                                             success:^(id data,id data2) {
                                                                 kStrongSelf(self);
                                                                 LoginModel * model = data2;
                                                                 self.requestParams = model;
                                                                 
                                                                 if ([model.userinfo.valigooglesecret boolValue]==NO){
                                                                     self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"未验证"];
                                                                 }
                                                                 else{
                                                                     if ([model.userinfo.safeverifyswitch boolValue]==YES) {
                                                                         self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"已开启"];
                                                                     }else{
                                                                         self.titleValues = @[model.userinfo.nickname,@"修改",@"修改",@"未开启"];
                                                                     }
                                                                 }
                                                                 [self richElesSetFundPWView];
                                                                 
                                                             } failed:^(id data) {
                                                                 //        kStrongSelf(self);
                                                                 
                                                             } error:^(id data) {
                                                                 //        kStrongSelf(self);
                                                                 
                                                             }];
}

-(void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mineCell";
    UITableViewCell *cell = (UITableViewCell*)[_tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = self.titleValues[indexPath.row + 1];
    
    //    if (indexPath.row !=0) {
    //   cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    if (indexPath.row == 1) {
    //            ModifyFundPWVC * fundPasswordVC = [[ModifyFundPWVC alloc] init];
    //            [self.navigationController pushViewController:fundPasswordVC animated:YES];
    //    }else if (indexPath.row == 2) {
    //        if (safeverify == 1) {
    //            ModifyLoginPWVC * loginPasswordVC = [[ModifyLoginPWVC alloc] init];
    //            [self.navigationController pushViewController:loginPasswordVC animated:YES];
    //        }else{
    //            [YKToastView showToastText:@"谷歌验证码关闭，无法修改登录密码"];
    //        }
    //    }else
    if (indexPath.row == 2) {
        //已经绑定谷歌验证器
        if ([_requestParams.userinfo.valigooglesecret boolValue]==YES) {
            GoogleVerificationViewController * GoogleVerC = [[GoogleVerificationViewController alloc] init];
            [self.navigationController pushViewController:GoogleVerC animated:YES];
        }else{
            NoGoogleViewController * NoGoogleVerC = [[NoGoogleViewController alloc] initWithStyle:@"push"];
            [self.navigationController pushViewController:NoGoogleVerC animated:YES];
        }
    }else{
        [self pushFundPWVCOrLoginPWVC:indexPath.row];
    }
}

-(void)pushFundPWVCOrLoginPWVC:(NSInteger)row{
    //    NSInteger safeverify = [self.requestParams.userinfo.safeverifyswitch integerValue];
    //    if (safeverify == 1) {
    //        if (row == 1) {
    //            ModifyFundPWVC * fundPasswordVC = [[ModifyFundPWVC alloc] init];
    //            [self.navigationController pushViewController:fundPasswordVC animated:YES];
    //        }else if (row == 2){
    //            ModifyLoginPWVC * loginPasswordVC = [[ModifyLoginPWVC alloc] init];
    //            [self.navigationController pushViewController:loginPasswordVC animated:YES];
    //        }
    //    }else{
    //        [YKToastView showToastText:@"请打开谷歌验证码后才能修改密码 !"];
    //    }
    
    if (row == 0) {
        
        ModifyFundPWVC * fundPasswordVC = [[ModifyFundPWVC alloc] init];
        
        [self.navigationController pushViewController:fundPasswordVC
                                             animated:YES];
        
    }else if (row == 1){
        
        ModifyLoginPWVC * loginPasswordVC = [[ModifyLoginPWVC alloc] init];
        
        [self.navigationController pushViewController:loginPasswordVC
                                             animated:YES];
    }
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end
