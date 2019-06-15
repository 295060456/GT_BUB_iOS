//
//  HomeView.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "IdentityAuthView.h"
#import "IdentityAuthCell.h"
#import "BaseCell.h"
#import "IdentityAuthVM.h"
@interface IdentityAuthView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)NSArray* fliterArr;
@property (nonatomic, strong) LoginModel* model;
@end

@implementation IdentityAuthView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array  andDataModel:(LoginModel*)model WithPage:(NSInteger)page{
    self.currentPage = page;//pagesum
    self.model = model;
    if (self.currentPage == 1) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        
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
//    return 1;
    if (section >= _dataSource.count) {
        section = _dataSource.count - 1;
    }
    //    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    return [(_dataSource[section]) count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         return 70;//kHeightForListHeaderInSections;
    }else{
        return 0.1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 20)];
        titleLab.text = @"身份认证";
        [titleLab setTextColor:HEXCOLOR(0x333333)];
        [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium"
                                          size:20]];
        [view addSubview:titleLab];
        UILabel *detalLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, self.bounds.size.width-30, 13)];
        detalLab.text = @"为保障您的资金安全，需要认证身份信息";
        [detalLab setTextColor:HEXCOLOR(0x8c96a5)];
        detalLab.font = kFontSize(13);
        [view addSubview:detalLab];
        return view;
    }else{
        return nil;
    }
    
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
    IdentityAuthCell *cell = [IdentityAuthCell cellWith:tableView];
//    IdentityAuthData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    NSDictionary* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    [cell richElementsInCellWithModel:itemData andModel:self.model];
    [cell actionBlock:^(id data) {
//        if (self.block) {
//             self.block(@(EnumActionTag0),data);
//        }
    }];
    return cell;
}
- (void)actionBlock:(DataBlock)block
{
    self.block = block;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    IdentityAuthData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    NSDictionary* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
//    IdentityAuthType type = [itemData[kType] intValue];
//    if (type !=IdentityAuthTypeFinished) {
        if (self.block) {
            self.block(itemData);
        }
//    }
    
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [IdentityAuthCell cellHeightWithModel];
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate identityAuthView:self requestListWithPage:self.currentPage];
        }
//        footer:^{
//        kStrongSelf(self);
//        ++self.currentPage;
//        [self.delegate identityAuthView:self requestListWithPage:self.currentPage];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
