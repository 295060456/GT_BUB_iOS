//
//  PostAdsView.m
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ExchangeDetailView.h"
#import "ExchangeDetailCell.h"

#import "BaseCell.h"


#import "ExchangeDetailSectionHeaderView.h"

#import "ExchangeDetailVM.h"

@interface ExchangeDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, copy) TwoDataBlock block;
@end

@implementation ExchangeDetailView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    _tableView.backgroundColor = kWhiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.left.right.mas_equalTo(self).offset(0); make.bottom.mas_equalTo(self.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:-48.5);
    }];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array {
    if (array.count > 0) {
        if (self.currentPage == 0) {
            [self.sections removeAllObjects];
        }
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
        [self layoutBottomButton];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}
-(void)layoutBottomButton{
    NSDictionary* infoData = ((_sections[0])[kIndexInfo]);
    ExchangeType etype = [infoData[kType] integerValue];
    WS(weakSelf);
    switch (etype) {
        case ExchangeTypePayed:
        {
            [self bottomSingleButtonInSuperView:self WithButtionTitles:@"查看Txid" leftButtonEvent:^(id data) {
                weakSelf.bottomBtn = data;
                if (self.block) {
                    self.block(@(EnumActionTag0),data);
                }
            }];
            
        }
            break;
        case ExchangeTypeHandling:
        {
            [self bottomSingleButtonInSuperView:self WithButtionTitles:@"撤销兑换" leftButtonEvent:^(id data) {
                weakSelf.bottomBtn = data;
                if (self.block) {
                    self.block(@(EnumActionTag1),data);
                }
            }];
        }
            break;
            
        default:
        {
            if (weakSelf.bottomBtn) {
                [weakSelf.bottomBtn removeFromSuperview];
            }
        }
            break;
    }
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
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
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    return [(_sections[section])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionZero:
            return 15;
            break;
        case IndexSectionOne:
            return [ExchangeDetailSectionHeaderView viewHeight];
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:{
            UIView * sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 15)];
            sectionHeaderView.backgroundColor = kWhiteColor;
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
            line.backgroundColor = RGBCOLOR(228, 229,232);
            [sectionHeaderView addSubview:line];
            
            return sectionHeaderView;
        }
            break;
        case IndexSectionOne:{
            ExchangeDetailSectionHeaderView * sectionHeaderView = (ExchangeDetailSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ExchangeDetailSectionHeaderReuseIdentifier];
            
            return sectionHeaderView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }
    
    
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    NSDictionary* itemData = ((_sections[section])[kIndexInfo]);
    ExchangeType etype = [itemData[kType] integerValue];
    
    switch (type) {
        case IndexSectionOne:
            return [ExchangeDetailSectionFooterView viewHeightWithType:etype];;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    NSDictionary* itemData = ((_sections[section])[kIndexInfo]);
    
    switch (type) {
        case IndexSectionOne:
        {
            ExchangeDetailSectionFooterView * sectionHeaderView = (ExchangeDetailSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:ExchangeDetailSectionFooterReuseIdentifier];
            [sectionHeaderView richElementsInFooterView:itemData];
            
            return sectionHeaderView;
        }
            break;
        default:{
            
            return nil;
        }
            break;
            
    }
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    
    NSDictionary* infoData = ((_sections[section])[kIndexInfo]);
    ExchangeType etype = [infoData[kType] integerValue];
    
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    
    
    
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
        {
            ExchangeDetailCell *cell = [ExchangeDetailCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData withExchangeType:etype];
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
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
            return [ExchangeDetailCell cellHeightWithModel:itemData];
            break;
        default:
            return 0;
            break;
    }
        
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [ExchangeDetailSectionHeaderView sectionHeaderViewWith:_tableView];
        [ExchangeDetailSectionFooterView sectionFooterViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate exchangeDetailView:self requestListWithPage:self.currentPage];
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
