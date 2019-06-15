//
//  MyVC.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "MyVC.h"

#import "EditUserInfoVC.h"

#import "AssetsVC.h"
#import "AccountVC.h"
#import "AdsVC.h"
#import "OrdersVC.h"

#import "IdentityAuthVC.h"

#import "IdentityInfoVC.h"
#import "SecuritySettingVC.h"
#import "AboutUsVC.h"

#import "LoginModel.h"
#import "UIButton+WebCache.h"
#import "LoginVM.h"
#import "MyTransferCodeVC.h"
#import "WebViewController.h"
#import "XcSecuritySettingsVC.h"

@interface MyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * imgArr;
@property (nonatomic, strong) LoginModel *userInfoModel;
@property (nonatomic, strong) UIButton * avatorBtn;
@property (nonatomic, strong) UILabel * userNameLab;
@property (nonatomic, strong) UILabel * userIdLab;


@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(richElesInHV) name:kNotify_IsLoginOutRefresh object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushAssetVC) name:kNotify_jumpAssetVC object:nil];
    [self YBGeneral_baseConfig];
    
    [self initView];
    //    [self richElesInHV];
    
}
-(void)pushAssetVC{
    [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self richElesInHV];
}
-(void)loginSuccessBlockMethod{
    [self richElesInHV];
}

-(void)netwoekingErrorDataRefush{
    [self richElesInHV];
}

- (void)richElesInHV{
    _userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    [self.avatorBtn setBackgroundImageWithURL:[NSURL URLWithString:_userInfoModel.userinfo.useravator] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_square_avator"]];
    
    self.userNameLab.text = [NSString stringWithFormat:@"%@，你好",_userInfoModel.userinfo.nickname];
    
    self.userIdLab.text = [NSString stringWithFormat:@"ID: %@",_userInfoModel.userinfo.userid];
    
    //    if ([_userInfoModel.userinfo.userType intValue]==UserTypeBuyer) {
    //        _dataSource = @[
    //                        @[@{@"我的资产":@"icon_user_property"}
    //                          ,@{@"收款账号":@"icon_user_id"}
    //                          ,@{@"我的订单":@"icon_user_order"}
    //                          ],
    //                        @[@{@"认证信息":@"icon_user_iden"}
    //                          ,@{@"安全设置":@"icon_user_safe"}
    //                          ,@{@"关于我们":@"icon_user_about"}]
    //                        ];
    //    }else{ // 需求修改
    _dataSource = @[
                    @[@{@"我的资产":@"icon_user_property"}
                      ,@{@"收款账号":@"icon_user_id"}
                      ,@{@"我的订单":@"icon_user_order"}
                      ,@{@"我的广告":@"icon_user_AD"}],
                    @[@{@"认证信息":@"icon_user_iden"}
                      ,@{@"安全设置":@"icon_user_safe"}
                      ,@{@"帮助中心":@"icon_user_bzzx"}
                      ,@{@"关于我们":@"icon_user_about"}]
                    ];
    //    }
    [self.tableView reloadData];
}

- (UIView*) headerView{
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    
    self.avatorBtn = [[UIButton alloc] initWithFrame:CGRectMake(32, 24, 65, 65)];
    self.avatorBtn.layer.masksToBounds = YES;
    self.avatorBtn.layer.cornerRadius = self.avatorBtn.size.height/2;
    [_baseView addSubview:self.avatorBtn];
    [self.avatorBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 24, self.view.frame.size.width - 118 - 32, 33)];
    self.userNameLab.font = [UIFont systemFontOfSize:20];
    [_baseView addSubview:self.userNameLab];
    
    self.userIdLab = [[UILabel alloc] initWithFrame:CGRectMake(118, 60, self.view.frame.size.width - 118 - 32, 33)];
    self.userIdLab.textColor = [UIColor lightGrayColor];
    self.userIdLab.font = [UIFont systemFontOfSize:13];
    [_baseView addSubview:self.userIdLab];
    
    UIImageView * editImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatorBtn.frame) - 19, CGRectGetMaxY(self.avatorBtn.frame) - 19, 19, 19)];
    editImgView.layer.cornerRadius = editImgView.size.height/2;
    editImgView.layer.masksToBounds = YES;
    editImgView.image = [UIImage imageNamed:@"icon_user_alter"];
    [_baseView addSubview:editImgView];//124
    
    
    UIButton* transferBtn = [[UIButton alloc] init];
    [_baseView addSubview:transferBtn];
    [transferBtn addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView.mas_right).offset(0);
        make.top.equalTo(self.baseView.mas_top).offset(48);
        make.bottom.equalTo(self.userIdLab).offset(0);
        make.width.equalTo(@124);
    }];
    transferBtn.titleLabel.font = kFontSize(10);
    [transferBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [transferBtn setTitle:@"我的收款码" forState:UIControlStateNormal];
    [transferBtn setImage:kIMG(@"myaccountQrcode") forState:UIControlStateNormal];
    [transferBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    
    UIImageView * arrowImgView = [[UIImageView alloc]init];
    arrowImgView.image = kIMG(@"btnRight");
    [transferBtn addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(transferBtn.mas_right).offset(-14);
        make.bottom.equalTo(transferBtn.mas_bottom).offset(0);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.width.equalTo(@24);
    }];
    
    
    return _baseView;
}

- (void)transferBtnClick{
    [MyTransferCodeVC pushFromVC:self requestParams:_userInfoModel success:^(id data) {
        
    }];
}

- (void)editBtnClick{
    [EditUserInfoVC pushFromVC:self requestParams:_userInfoModel success:^(id data) {
        
    }];
}

-(void) initView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.backgroundColor = kTableViewBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(_dataSource[section]) count];
}
#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2*kHeightForListHeaderInSections;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* dic = (_dataSource[indexPath.section])[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = dic.allKeys[0];
    cell.imageView.image = [UIImage imageNamed:dic.allValues[0]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    [AssetsVC pushFromVC:self
                           requestParams:@1
                                 success:^(id data) {
                                     
                                 }];
                }
                    break;
                case 1:
                {
                    [AccountVC pushFromVC:self
                            requestParams:@1
                                  success:^(id data) {
                                      
                                  }];
                }
                    break;
                case 2:
                {
                    [OrdersVC pushFromVC:self];
                }
                    break;
                case 3:
                {
                    [AdsVC pushFromVC:self];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    [IdentityAuthVC pushFromVC:self
                                 requestParams:@1
                                       success:^(id data) {
                                           
                                       }];
                    
                }
                    break;
                case 1:
                {
                    LoginModel *model = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                    LoginData *loginData = model.userinfo;
                    if (loginData.istrpwd && [loginData.istrpwd isEqualToString:@"1"]) { //
                        [SecuritySettingVC pushFromVC:self
                                        requestParams:_userInfoModel
                                              success:^(id data) { }];
                        
                    }else{ // 去设置交易密码
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲，您还未设置交易密码哦"
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"稍后设置"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"现在去设置"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [XcSecuritySettingsVC pushFromVC:self
                                                                                       requestParams:@1
                                                                                             success:^(id data) {
                                                                                             }];
                                                                }]];
                    }
                    
                }
                    break;
                case 2:
                {
                    [WebViewController pushFromVC:self requestUrl:@"http://help.bubchain.com" withProgressStyle:DKProgressStyle_Noraml success:^(id data) {
                        
                    }];
                }
                    break;
                case 3:
                {
                    AboutUsVC * aboutUsVC = [[AboutUsVC alloc] init];
                    
                    [self.navigationController pushViewController:aboutUsVC
                                                         animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:kNotify_IsLoginOutRefresh
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:kNotify_jumpAssetVC
                                                 object:nil];
}
@end
