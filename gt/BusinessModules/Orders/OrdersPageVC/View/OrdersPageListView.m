//
//  HomeView.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "OrdersPageListView.h"
#import "OrdersPageListCell.h"
#import "BuyerOrdersPageListCell.h"

#import "BaseCell.h"

#import "OrdersPageVM.h"

@interface OrdersPageListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)TwoDataBlock block;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic,assign)UserType utype;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation OrdersPageListView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)scrollToTop{
     [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; 
}

- (void)initViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //    [self.tableView.mj_header beginRefreshing];//viewWill
    //    [self.tableView.mj_footer beginRefreshing];
    kWeakSelf(self);
    [_tableView YBGeneral_addRefreshFooter:^{
        kStrongSelf(self);
        ++self.currentPage;
        [self.delegate ordersPageListView:self requestListWithPage:self.currentPage];
    }
     ];
    self.dataEmptyView = [self setDataEmptyViewInSuperView:self withTopMargin:0];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page
                       WithUserType:(UserType)utype{
    self.utype = utype;
    self.currentPage = page;//pagesum
    self.dataEmptyView.hidden = YES;
    if (page == 1) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        if (array.count==0) {
            self.dataEmptyView.hidden = NO;
        }
    }
    if (array.count > 0) {
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    self.dataEmptyView.hidden = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeightForListHeaderInSections;
      
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
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel * itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    switch (_utype) {
        case UserTypeSeller:
        {
            OrdersPageListCell *cell = [OrdersPageListCell cellWith:tableView];
            
            [cell richElementsInCellWithModel:itemData];
            [cell actionBlock:^(id data) {
                if (self.block) {
                    self.block(@(YES),data);
                }
            }];
            return cell;
        }
            break;
        case UserTypeBuyer:
        {
            BuyerOrdersPageListCell *cell = [BuyerOrdersPageListCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
//            [cell actionBlock:^(id data) {
//                if (self.block) {
//                    self.block(@(YES),data);
//                }
//            }];
            return cell;
        }
            break;
        default:{
            BaseCell *cell = [BaseCell cellWith:tableView];
            cell.hideSeparatorLine = YES;
            cell.frame = CGRectZero;
            return cell;
        }
            break;
    }
    
}

-(void)actionBlock:(TwoDataBlock)block{
    self.block = block;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailModel * itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    switch (_utype) {
        case UserTypeSeller:
        {
            return [OrdersPageListCell cellHeightWithModel:itemData];
        }
            break;
        case UserTypeBuyer:
        {
            return [BuyerOrdersPageListCell cellHeightWithModel:itemData];
        }
            break;
        default:
        {
            return 110;
        }
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailModel * itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    if (self.block) {
        self.block(@(NO),itemData);
    }
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = kTableViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate ordersPageListView:self requestListWithPage:self.currentPage];
        }
        footer:^{
        kStrongSelf(self);
        ++self.currentPage;
        [self.delegate ordersPageListView:self requestListWithPage:self.currentPage];
        }
    ];
    }
    return _tableView;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
