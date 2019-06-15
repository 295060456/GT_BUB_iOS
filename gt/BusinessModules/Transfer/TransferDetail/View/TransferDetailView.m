//
//  PostAdsView.m
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransferDetailView.h"
#import "TransferDetailCell.h"
#import "BaseCell.h"
#import "TransferDetailSectionHeaderView.h"

#import "TransferDetailVM.h"

@interface TransferDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation TransferDetailView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.contactBtn];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array {
    if (self.currentPage == 1) {
        [self.sections removeAllObjects];
        [self.tableView reloadData];
    }
    if (array.count > 0) {
        [self.sections addObjectsFromArray:array];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;//dont set 1, even if one section, multi rows[@"k"]
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(_sections[0])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TransferDetailSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    TransferDetailSectionHeaderView * sectionHeaderView = (TransferDetailSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:TransferDetailSectionHeaderReuseIdentifier];
    [sectionHeaderView richElementsInViewWithModel:itemData];
    return sectionHeaderView;
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    TransferDetailType type = [itemData[kType] integerValue];
    return [TransferDetailSectionFooterView viewHeightWithType:type];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary* itemData = _sections[0];
    TransferDetailSectionFooterView * sectionHeaderView = (TransferDetailSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:TransferDetailSectionFooterReuseIdentifier];
    [sectionHeaderView richElementsInViewWithModel:itemData];
    [sectionHeaderView actionBlock:^(id data,id data2) {
        if (self.block) {
            self.block(data,data2);
        }
    }];
    return sectionHeaderView;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TransferDetailCell *cell = [TransferDetailCell cellWith:tableView];
    
    NSDictionary* dic = (_sections[0][kIndexRow])[indexPath.row];
    //    WData* wData = (WData*)itemData;
    [cell richElementsInCellWithModel:dic];
    
    return cell;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [TransferDetailCell cellHeightWithModel:(_sections[0][kIndexRow])[indexPath.row]];
}


- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

-(void)clickContactBtn:(UIButton*)btn{
    NSDictionary* itemData = _sections[0];
    if (self.block) {
        self.block(@(btn.tag),itemData);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [TransferDetailSectionHeaderView sectionHeaderViewWith:_tableView];
        [TransferDetailSectionFooterView sectionFooterViewWith:_tableView];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate transferDetailView:self requestListWithPage:self.currentPage];
        }
//                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
//        }
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

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

@end
