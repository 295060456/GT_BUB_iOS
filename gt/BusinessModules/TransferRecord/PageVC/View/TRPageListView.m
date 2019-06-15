//
//  HomeView.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TRPageListView.h"
#import "TRPageListCell.h"
#import "BaseCell.h"

#import "TRPageVM.h"

#define kHeightForListHeaderInSections 5
#define kTableViewBackgroundColor RGBCOLOR(228, 229,232)
@interface TRPageListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation TRPageListView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.dataEmptyView = [self setDataEmptyViewInSuperView:self withTopMargin:0 withCustomTitle:@"暂无转账记录"];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page{
    self.currentPage = page;//pagesum
    if (self.currentPage == 1) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
    //    [self crateChooseSubView];
    
    if (page == 1&&array.count==0) {
        self.dataEmptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (array.count > 0) {
        self.dataEmptyView.hidden = YES;
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

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
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
    TRPageListCell *cell = [TRPageListCell cellWith:tableView];
    TRPageData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    [cell richElementsInCellWithModel:itemData];
    [cell actionBlock:^(id data,id data2) {
//        if (self.block) {
//             self.block(data);
//        }
    }];
    return cell;
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TRPageListCell cellHeightWithModel];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TRPageData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    if (self.block) {
        self.block(itemData);
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
            [self.delegate trpageListView:self requestListWithPage:self.currentPage];
        }
        footer:^{
        kStrongSelf(self);
        ++self.currentPage;
        [self.delegate trpageListView:self requestListWithPage:self.currentPage];
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
