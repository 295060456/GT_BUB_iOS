//
//  HomeView.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PageListView.h"
#import "PageListCell.h"
#import "BaseCell.h"

#import "PageVM.h"
#import "ModifyAdsModel.h"

@interface PageListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) TableViewDataBlock block;
@property (nonatomic, strong) UIView * dataEmptyView;
@end

@implementation PageListView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.dataEmptyView = [self setDataEmptyViewInSuperView:self withTopMargin:0];
        self.dataEmptyView.hidden = YES;
    }
    return self;
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
                                        [self.delegate pageListView:self requestListWithPage:self.currentPage];
                                    }
     ];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page{
    
    self.currentPage = page;
     self.dataEmptyView.hidden = YES;
    if (self.currentPage == 1) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        if (array.count <0.5) {
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
    PageListCell *cell = [PageListCell cellWith:tableView];
    ModifyAdsModel* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    [cell richElementsInCellWithModel:itemData];
    [cell actionBlock:^(id data,id data2) {
        if (self.block) {
     self.block(data,data2,self,tableView,self.dataSource,indexPath);
        }
    }];
    return cell;
}
- (void)actionBlock:(TableViewDataBlock)block
{
    self.block = block;
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PageListCell cellHeightWithModel];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyAdsModel* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    if (self.block) {
        self.block(@(EnumActionTag3), itemData, self,tableView,self.dataSource,indexPath);
    }
}
//#pragma mark - DeleteSection
////设Cell可编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  UITableViewCellEditingStyleDelete;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //出现alterView隐藏删除按钮
//    [tableView setEditing:NO animated:YES];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//       [tableView beginUpdates];
////        [_dataSource removeObjectAtIndex:indexPath.row];
////        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [_dataSource removeObjectAtIndex:indexPath.section];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView reloadData];
//        [tableView endUpdates];
//    }
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"下架";
//}
//
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
//#pragma mark - DeleteSection iOS11.0
//- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
//    //删除
//    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        [self.dataSource removeObjectAtIndex:indexPath.row];
//        completionHandler (YES);
//        [self.tableView reloadData];
//    }];
//    deleteRowAction.image = [UIImage imageNamed:@"删除"];
//    deleteRowAction.backgroundColor = [UIColor redColor];
//
//
//    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
//    return config;
//
//}


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
            [self.delegate pageListView:self requestListWithPage:self.currentPage];
        }
        footer:^{
        kStrongSelf(self);
        ++self.currentPage;
        [self.delegate pageListView:self requestListWithPage:self.currentPage];
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
