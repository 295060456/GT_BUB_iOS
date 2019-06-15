//
//  MsgVC.m
//  OTC
//
//  Created by mac30389 on 2018/11/15.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import "MsgVC.h"
#import "EventListTableViewCell.h"
#import "EventOneTypeViewController.h"
//#import "ConnectSalerViewController.h"
#import "OTCConversationListVC.h"
#import "RongCloudManager.h"
#import "MsgModel.h"
#import "MsgVM.h"
#import "LoginVM.h"
#import "AboutUsModel.h"

@interface MsgVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, copy) NSArray * titleArr;
@property (nonatomic, strong) MsgVM *vm;
@property (nonatomic, strong) AboutUsModel* customerServiceModel;

@end
static NSString *cellId = @"Cell";

@implementation MsgVC

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (GetUserDefaultBoolWithKey(kIsLogin)) {
        
        [self getUnReadInfoConnectSaler];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUnReadInfoConnectSaler)
                                                 name:kNotify_IsLoginRefresh
                                               object:nil];
    
    self.title = @"消息";
    
    [self crateUI];
    kWeakSelf(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getUnReadInfoConnectSaler];
    }];
    
    OTCConversationListVC *recommendVC = [OTCConversationListVC new];
    float buttom =  [YBFrameTool tabBarHeight];
    float top = YBSystemTool.isIphoneX ? 88 : 64;
    recommendVC.view.frame = CGRectMake(0.f, 88.f, MAINSCREEN_WIDTH, self.view.bounds.size.height  - 88.f - buttom - top);
    [self.view addSubview:recommendVC.view];
    [self addChildViewController:recommendVC];
    
    [recommendVC didMoveToParentViewController:self];
    
    [self getcustomerServiceModelData];
}

- (void)getUnReadInfoConnectSaler{
    
    //  融云顶替了 XX
    //    kWeakSelf(self);
    //    [self.vm network_notReadMessageWithPageno:@"1"
    //                                     pagesize:@""
    //                                      success:^(id data) {
    //
    //        kStrongSelf(self);
    //        [self.tableView.mj_header endRefreshing];
    //        [self.dataSources addObjectsFromArray:data];
    //        [self.tableView reloadData];
    //    } failed:^(id data) {
    //
    //        NSLog(@"%@",data);
    //
    //    } error:^(id data) {
    //
    //        NSLog(@"%@",data);
    //    }];
}


- (void)crateUI{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(88);
    }];
    
    self.btns = [NSMutableArray array];
    
    self.titleArr = @[@{@"订单通知":@"1"},@{@"联系客服":@"3"},@{@"系统通知":@"2"}];
    
    NSArray * imagArr = @[@"icon_mess_order",@"icon_mess_service",@"icon_mess_system"];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        NSDictionary* dic = self.titleArr[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag =  [dic.allValues[0] integerValue];//i;
        
        //        button.selected = NO;
        button.adjustsImageWhenHighlighted = NO;
        
        button.titleLabel.font = kFontSize(13);
        
        [button setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [button setImage:[UIImage imageNamed:imagArr[i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(clickTopBtn:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        [_btns addObject:button];
    }
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedSpacing:1
                            leadSpacing:21 tailSpacing:21];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view);
        make.height.mas_equalTo(view);
    }];
    for (UIButton* button in _btns) {
        
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                imageTitleSpace:7];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EventListTableViewCell" bundle:nil]
     forCellReuseIdentifier:cellId];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.top.mas_equalTo(view.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-50);
    }];
}

- (void)clickTopBtn:(UIButton *)sender{
    //1.订单消息  3.客服消息  2.系统消息
    //    NSString * typeStr = [NSString stringWithFormat:@"%lu",sender.tag];
    for (NSDictionary* dic in self.titleArr) {
        if ([dic.allValues[0] intValue]== sender.tag) {
            if (sender.tag == MsgTypeService) {
                NSString *serverID = self.customerServiceModel.rongCloudId?self.customerServiceModel.rongCloudId:SERVICE_ID;
                NSString *titleS = self.customerServiceModel.rongCloudName?self.customerServiceModel.rongCloudName:@"客服";
                    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
                    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
                    chatService.targetId = serverID;
                    chatService.title = titleS;
                    [self.navigationController pushViewController :chatService animated:YES];

            }else{
                [EventOneTypeViewController pushFromVC:self requestParams:dic success:^(id data) {
                }];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId]; //如果没有取到,就初始化
    if (!cell) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    MsgData * messageModel = _dataSources[indexPath.section];
    cell.EventName.text = messageModel.orderId;
    cell.EventIndo.text = messageModel.content;
    cell.EventTime.text = messageModel.createdTime;
    cell.EventNumber.hidden = YES;
    //1.订单消息 2.系统消息 3.客服消息
    //    if ([messageModel.type isEqualToString:@"1"]) {
    [cell.EventPic setImage:kIMG(@"icon-in-app")];
    //    }else if ([messageModel.type isEqualToString:@"2"]) {
    //        [cell.EventPic setImage:imageNamed(@"img_logo")];
    //    }else{
    //        [cell.EventPic setImage:imageNamed(@"img_service")];
    //    }
    
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgData * messageModel = _dataSources[indexPath.section];
    [RongCloudManager jumpNewSessionWithSessionId:messageModel.sendUserId
                                            title:messageModel.sendUserId
                                     navigationVC:self.navigationController];
    
}

- (NSString *)getStateStr:(NSString *)type
{
    NSString * str = @"已完成";
    switch ([type intValue]) {
        case 1:
            str = @"未付款";
            break;
        case 2:
            str = @"已付款";
            break;
        case 3:
            str = @"已完成";
            break;
        case 4:
            str = @"已取消";
            break;
        case 5:
            str = @"已关闭(自动)";
            break;
        case 6:
            str = @"申诉中";
            break;
        default:
            break;
    }
    return str;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 0.01)];
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        
        _currentPage = 0;
    }
    return _currentPage;
}


-(void)getcustomerServiceModelData{
    
    LoginVM *vm = [[LoginVM alloc] init];
    kWeakSelf(self);
    [vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        kStrongSelf(self);
        self.customerServiceModel = data;
        SetUserDefaultKeyWithObject(SeverData, [self.customerServiceModel mj_keyValues]);
        UserDefaultSynchronize;
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    [SVProgressHUD dismiss];
    
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (MsgVM *)vm {
    if (!_vm) {
        
        _vm = [MsgVM new];
    }
    return _vm;
}

@end

