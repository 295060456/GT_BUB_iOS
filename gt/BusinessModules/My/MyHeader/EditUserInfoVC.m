//
//  EditUserInfoVC.m
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "SettingNicknameVC.h"
#import "EditUserInfoTBVCell.h"
//#import "ChangeNicknameVC.h"
#import "XcChangeTelephonePwVC.h"

#import "LoginModel.h"
#import "LoginVM.h"

#define cellHeight  76

@interface EditUserInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIButton *editNameBtn;
@property(nonatomic,strong)UITableView *editUserInfoTableView;

@property(nonatomic,strong)LoginVM *loginVM;
@property(nonatomic,strong)NSMutableArray *titleDataMutArr;
@property(nonatomic,strong)NSMutableArray *detailTitleDataMutArr;
@property(nonatomic,strong)LoginModel *requestParams;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,assign)CGSize sizeOfTitleLab;

@end

@implementation EditUserInfoVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block{
    
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] init];
    
    vc.block = block;
    
    vc.requestParams = requestParams;
    
    vc.titleStr = @"个人中心";
    
    [vc.titleDataMutArr addObject:@"ID"];
    
    [vc.titleDataMutArr addObject:@"昵称"];
    
    [vc.titleDataMutArr addObject:@"手机号"];
    
    [vc.detailTitleDataMutArr addObject:vc.requestParams.userinfo.userid];

    [vc.detailTitleDataMutArr addObject:vc.requestParams.userinfo.nickname];

    [vc.detailTitleDataMutArr addObject:[NSString numberSuitScanf:vc.requestParams.userinfo.username]];
    
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    return vc;
}



#pragma mark —— life cycle
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    
    [self.loginVM network_checkUserInfoWithRequestParams:@1
                                                 success:^(id data,id data2) {
        kStrongSelf(self);
                                                     
        LoginModel * model = data2;
                                                     
        self.nickName = model.userinfo.nickname;
                                                     
        [self.editNameBtn setTitle:self.nickName
                          forState:UIControlStateNormal];
                                                     
         [self.detailTitleDataMutArr removeAllObjects];
         [self.detailTitleDataMutArr addObject:model.userinfo.userid];
         [self.detailTitleDataMutArr addObject:model.userinfo.nickname];
         [self.detailTitleDataMutArr addObject:[NSString numberSuitScanf:model.userinfo.username]];
        [self.editUserInfoTableView reloadData];
        
    } failed:^(id data) {
        //        kStrongSelf(self);
        
    } error:^(id data) {
        //        kStrongSelf(self);
        
    }];
}

-(void)dealloc{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    [self initView];
}

-(void)initView{
    
    [self.view addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(41 * SCALING_RATIO);
        
        make.left.equalTo(self.view).offset(30 * SCALING_RATIO);
        
        make.size.mas_equalTo(self.sizeOfTitleLab);
    }];

    [self.view addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(65 * SCALING_RATIO, 65 * SCALING_RATIO));
        
        make.centerY.equalTo(self.titleLab);
        
        make.right.equalTo(self.view).offset(-25 * SCALING_RATIO);
    }];
    
    [self.view addSubview:self.editUserInfoTableView];
    
    [self.editUserInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_bottom).offset(22 * SCALING_RATIO);

        make.left.equalTo(self.titleLab);
        
        make.right.equalTo(self.headImageView);
        
        make.height.mas_equalTo(self.titleDataMutArr.count * cellHeight * SCALING_RATIO);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleDataMutArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return cellHeight * SCALING_RATIO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    switch (indexPath.row) {
        case 1:{
            
        [SettingNicknameVC pushFromVC:self
                       requestParams:self.nickName
                             success:^(id data) {}];
        }
            break;
        case 2:{
            [XcChangeTelephonePwVC pushFromVC:self requestParams:nil success:nil];
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditUserInfoTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    
    if (!cell) {
        
        cell = [[EditUserInfoTBVCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:ReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = HEXCOLOR(0x8c96a5);
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                              size:15];
        cell.detailTextLabel.textColor = HEXCOLOR(0x333333);
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                    size:18];
        
        if (indexPath.row != 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.detailTextLabel.text = self.detailTitleDataMutArr[indexPath.row];
    
    cell.textLabel.text = self.titleDataMutArr[indexPath.row];
    
    return cell;
}

-(void)logOutBtnClick{
    
    kWeakSelf(self);
    [self.loginVM network_getLoginOutWithRequestParams:@1
                                       success:^(id model) {
                                           kStrongSelf(self);
                                           if (self.block) {
                                               [weakself locateTabBar:0];
                                               //befor block set userStatus
                                               self.block(model);
                                           }
                                       }
                                        failed:^(id model){
                                            
                                        }
                                         error:^(id model){
                                             
                                         }];
}

-(UITableView *)editUserInfoTableView{
    
    if (!_editUserInfoTableView) {
        
        _editUserInfoTableView = UITableView.new;
        
        _editUserInfoTableView.scrollEnabled = NO;
        
        _editUserInfoTableView.tableFooterView = UIView.new;
        
        _editUserInfoTableView.delegate = self;
        
        _editUserInfoTableView.dataSource = self;
        
        _editUserInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _editUserInfoTableView;
}

-(UIImageView *)headImageView{
    
    if (!_headImageView) {
        
        _headImageView = UIImageView.new;
        
        [_headImageView setImageWithURL:[NSURL URLWithString:_requestParams.userinfo.useravator]
                                              placeholderImage:kIMG(@"default_circle_avator")];
        
        
        [NSObject cornerCutToCircleWithView:_headImageView
                            AndCornerRadius:65 * SCALING_RATIO / 2];
    }
    
    return _headImageView;
}

- (LoginVM *)loginVM {
    
    if (!_loginVM) {
        
        _loginVM = LoginVM.new;
    }
    
    return _loginVM;
}

-(NSMutableArray *)titleDataMutArr{
    
    if (!_titleDataMutArr) {
        
        _titleDataMutArr = NSMutableArray.array;
    }
    
    return _titleDataMutArr;
}

-(NSMutableArray *)detailTitleDataMutArr{
    
    if (!_detailTitleDataMutArr) {
        
        _detailTitleDataMutArr = NSMutableArray.array;
    }
    
    return _detailTitleDataMutArr;
}

-(UILabel *)titleLab{
    
    if (!_titleLab) {
        
        _titleLab = UILabel.new;
        
        _titleLab.text = self.titleStr;
        
        self.sizeOfTitleLab = [NSString sizeWithString:self.titleStr
                                               andFont:[UIFont fontWithName:@"PingFangSC-Medium"
                                                                       size:28]
                                            andMaxSize:CGSizeMake(112 * SCALING_RATIO, 28 *SCALING_RATIO)];
 
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                         size:28];
        
        _titleLab.textColor = HEXCOLOR(0x333333);
    }
    
    return _titleLab;
}



@end
