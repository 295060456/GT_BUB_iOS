//
//  EventOneTypeViewController.m
//  OTC
//
//  Created by David on 2018/11/29.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "EventOneTypeViewController.h"
#import "EventListTableViewCell.h"
#import "EventListModel.h"
#import "MsgVM.h"
//#import "OrderDetailVC.h"
#import "PostAppealCompleteVC.h"
#import "BuyBubDetailVC.h"
//#import "OrderDetailModel.h"

@interface EventOneTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) MsgVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, assign) MsgType type;

@end

@implementation EventOneTypeViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    EventOneTypeViewController *vc = [[EventOneTypeViewController alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)requestHomeListWithPage:(NSInteger)page{
    kWeakSelf(self);
    NSDictionary* dic = self.requestParams;
    NSString *typ =dic.allValues[0];
    if (_type == MsgTypeSystem) {
        typ = @"5";
    }
    [self.vm network_eventMsgListWithPageno:[NSString stringWithFormat:@"%lu",page] pagesize:@"10" eventListType:typ success:^(id data) {
        kStrongSelf(self);
        [self requestHomeListSuccessWithArray:data WithPage:page];
    } failed:^(id data) {
        [self requestHomeListFailed];
    } error:^(id data) {
        [self requestHomeListFailed];
    }];
}
#pragma mark - public
- (void)requestHomeListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page{
    
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.dataSources removeAllObjects];
        [self.tableView reloadData];
    }
    if (page == 1&&array.count==0) {
        self.dataEmptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (array.count > 0) {
        self.dataEmptyView.hidden =YES;
        [self.dataSources addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        //        _emptyLab.hidden = NO;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
    [self.dataSources removeAllObjects];
    [self.tableView reloadData];
    self.dataEmptyView.hidden = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    kWeakSelf(self);
    [_tableView YBGeneral_addRefreshHeader:^{
        kStrongSelf(self);
        self.currentPage = 1;
        [self requestHomeListWithPage:self.currentPage];
    }
                                    footer:^{
                                        kStrongSelf(self);
                                        ++self.currentPage;
                                        [self requestHomeListWithPage:self.currentPage];
                                    }
     ];
    [self.tableView.mj_header beginRefreshing];
    
    NSDictionary* dic = self.requestParams;
    self.title = dic.allKeys[0];
    
    _type = [dic.allValues[0] intValue];
    
    
    NSString* emptyTitle = @"";
    if (_type == MsgTypeOrder) {
        emptyTitle = @"暂无订单通知";
    }else if (_type == MsgTypeSystem) {
        emptyTitle = @"暂无系统通知";
    }else if (_type == MsgTypeService){
        emptyTitle = @"请去首页帮助中心联系客服";
    }
    self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:36 withCustomTitle:emptyTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventListTableViewCell *cell = [EventListTableViewCell cellWith:tableView];
    EventListAllMessage * messageModel = _dataSources[indexPath.section];
    [cell richElementsInCellWithModel:messageModel];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventListAllMessage* itemData = _dataSources[indexPath.section];
    if (itemData!=nil) {
        if (_type==MsgTypeOrder&&
            ![NSString isEmpty:itemData.param.otcOrderId]) {
             [BuyBubDetailVC pushFromVC:self.navigationController requestParams:itemData.param.orderId success:^(id data) {}];
//            [OrderDetailVC pushViewController:self
//                                requestParams:itemData.param.orderId
//                                      success:^(id data) {}]; // 之前逻辑
        }else if (_type == MsgTypeSystem){
            if ([itemData.type isEqualToString:@"4"]) { //申诉消息
                NSString *appealId = itemData.param.appealId;
                if (appealId && appealId.length > 1) {
                    [PostAppealCompleteVC pushViewController:self requestParams:itemData success:^(id data) {}];
                }else{
                    [BuyBubDetailVC pushFromVC:self.navigationController requestParams:itemData.param.orderId success:^(id data) {}];
//                    [OrderDetailVC pushViewController:self requestParams:itemData.param.orderId success:^(id data) {}]; // 之前逻辑
                }
            }else if ([itemData.type isEqualToString:@"2"]){ // 系统消息是
                
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EventListTableViewCell cellHeightWithModel:_dataSources[indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, .5)];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 0.01)];
    return vi;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
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


-(void)dealloc{
    
}
@end

