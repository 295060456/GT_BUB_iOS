//
//  PostAdsView.m
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "BaseCell.h"
#import "PostAppealCell.h"
#import "PostAdsReplyCell.h"
#import "PostAppealPhotoCell.h"
#import "PostAppealSectionHeaderView.h"
#import "PostAppealView.h"
#import "PickerPopUpView.h"

#import "PostAppealVM.h"


@interface PostAppealView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, copy) DataBlock dataBlock;

@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, copy) NSString*  remark;
@property (nonatomic, copy) NSString*  pickTag;
@property (nonatomic, copy) NSString*  contactTx;

@property (nonatomic, strong)PostAppealVM *postAppealVM;

@property(nonatomic,strong)id requestParams;

@property (nonatomic, assign) BOOL isantiAppeal;
@property (nonatomic, strong) NSString *reason;

@end

@implementation PostAppealView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
                requestParams:(id)requestParams{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.requestParams = requestParams;
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
//    [self.delegate postAppealView:self
//              requestListWithPage:0];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.left.right.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:-48.5);
    }];
    [self bottomSingleButtonInSuperView:self WithButtionTitles:@"已确认，提交申诉" leftButtonEvent:^(id data) {
        
        NSString* remark = ![NSString isEmpty:self.remark]?self.remark:@"";
        NSString* pickTag = ![NSString isEmpty:self.pickTag]?self.pickTag:@"";
        NSString* contactTx = ![NSString isEmpty:self.contactTx]?self.contactTx:@"";
        if (self.isantiAppeal == NO) {
            if ( [NSString isEmpty:pickTag]||[pickTag isEqualToString:@"0"]) {
                [YKToastView showToastText:@"请选择申诉原因"];
                return ;
            }
        }
        if ([NSString isEmpty:contactTx]) {
            [YKToastView showToastText:@"请填写联系方式"];
            return ;
        }
        if (self.block) {
            self.block(@(EnumActionTag1), @[remark,pickTag,contactTx]);
        }
    }];
//    [self bottomDoubleButtonInSuperView:self leftButtonEvent:^(id data) {
//        if (self.block) {
//            self.block(@(EnumActionTag0), data);
//        }
//    } rightButtonEvent:^(id data) {
//        NSString* remark = ![NSString isEmpty:self.remark]?self.remark:@"";
//        NSString* pickTag = ![NSString isEmpty:self.pickTag]?self.pickTag:@"";
//        NSString* contactTx = ![NSString isEmpty:self.contactTx]?self.contactTx:@"";
//        if ([NSString isEmpty:pickTag]||[pickTag isEqualToString:@"0"]) {
//            [YKToastView showToastText:@"请选择申诉原因"];
//            return ;
//        }
//        if ([NSString isEmpty:contactTx]) {
//            [YKToastView showToastText:@"请填写联系方式"];
//            return ;
//        }
//        if (self.block) {
//            self.block(@(EnumActionTag1), @[remark,pickTag,contactTx]);
//        }
//    }];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array andIsAntiAppeal:(BOOL)isantiAppeal andResonString:(NSString*)reason{
    self.isantiAppeal = isantiAppeal;
    self.reason = reason;
    if (array.count > 0) {
        if (self.currentPage == 0) {
            [self.sections removeAllObjects];
        }
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
//        [self.tableView.mj_footer endRefreshing];
    } else {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
//    [self.tableView.mj_header endRefreshing];
    
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

//    return _sections.count;
    
    return 3;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section >= _sections.count) {
//        section = _sections.count - 1;
//    }
////    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
//    return [(_sections[section])[kIndexRow] count];
    
    return 1;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionZero:
            return 5;
            break;
        case IndexSectionTwo:
            return [PostAppealSectionHeaderView viewHeight];
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
        case IndexSectionTwo: {
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            PostAppealSectionHeaderView * sectionHeaderView = (PostAppealSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAppealSectionHeaderReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            
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
    
    switch (type) {
        case IndexSectionTwo:
            return [PostAppealSectionFooterView viewHeightWithType:type];
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

    switch (type) {
        case IndexSectionTwo: {
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            PostAppealSectionFooterView * sectionFootView = (PostAppealSectionFooterView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAppealSectionFooterReuseIdentifier];
            [sectionFootView richElementsInViewWithModel:model];
            [sectionFootView actionBlock:^(id data, id data2) {
                if (self.block) {
                    self.block(@(EnumActionTag3), data2 );
                }
            }];
            return sectionFootView;
        }
            break;
            
        default:
            return [UIView new];
            break;
            
    }
    
    return nil;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    kWeakSelf(self);
    
    switch (indexPath.section) {
        case 0:{
            
            PostAppealCell *cell = [PostAppealCell cellWith:tableView
                                              requestParams:self.requestParams
                                                       data:self.postAppealVM.listData];
            
            id itemData = ((_sections[indexPath.section])[kIndexRow])[indexPath.row];
            
            [cell richElementsInCellWithModel:itemData];
            if (self.isantiAppeal) {
                [cell chengButtonTextString:self.reason];
            }
            [cell actionBlock:^(id data,id data2) {
                if (self.isantiAppeal) {
                     [YKToastView showToastText:@"反申诉理由不可选"];
                    self.pickTag = [NSString stringWithFormat:@"%@",self.reason];
                }else{
                [self endEditing:YES];
                UIButton* pickerButton=(UIButton*)data;
                PickerPopUpView* popupView = [[PickerPopUpView alloc]init];
                [popupView richElementsInViewWithModel:data2];
                [popupView showInApplicationKeyWindow];
                [popupView actionBlock:^(id data) {
                    NSDictionary* dic = data;
                    [pickerButton setTitle:[NSString stringWithFormat:@"     %@",dic.allValues[0]]
                                  forState:UIControlStateNormal];
                    self.pickTag = dic.allKeys[0];
                }];
            }
            }];
            [cell txActionBlock:^(id data) {
                self.contactTx = data;
            }];
            return cell;
        }
            break;
        case 1:{
            self.postAppealPhotoCell = [PostAppealPhotoCell cellWith:tableView];
            self.postAppealPhotoCell.PhotoBlock = ^{
                kStrongSelf(self);
                if (self.block) {
                    self.block(@(EnumActionTag2), self.postAppealPhotoCell.photoBtn );
                }
            };
            return self.postAppealPhotoCell;
        }
            break;
        case 2:{
            
            PostAdsReplyCell *cell = [PostAdsReplyCell cellWith:tableView];

            [cell actionBlock:^(id data) {
                //        if (self.block) {
                //            self.block(data);
                //        }
                self.remark = data;
            }];
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

- (void)actionBlock:(TwoDataBlock)block{
    
    self.block = block;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger section = indexPath.section;
//    if(section >= _sections.count)
//    section = _sections.count - 1;
//
//    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
//    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
//    switch (type) {
//        case IndexSectionZero:
//            return [PostAppealCell cellHeightWithModel:itemData];
//            break;
//
//        case IndexSectionOne:
//        {
//            return [PostAdsReplyCell cellHeightWithModel:itemData];
//        }
//            break;
//        default:
//            return 0;
//            break;
//    }
    
    switch (indexPath.section) {
        case 0:{
            
          return   268.1f;
        }
            break;
        case 1:{
            
            return 117.0f;
        }
            break;
        case 2:{
            
            return MAINSCREEN_HEIGHT / 3.7;
        }
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
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [PostAppealSectionHeaderView sectionHeaderViewWith:_tableView];
        [PostAppealSectionFooterView sectionFooterViewWith:_tableView];
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{

            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate postAppealView:self
                      requestListWithPage:self.currentPage];

            [self.tableView.mj_header endRefreshing];
        }
                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
        }];
    }
    return _tableView;
}

-(PostAppealVM *)postAppealVM{
    
    if (!_postAppealVM) {
        
        _postAppealVM = PostAppealVM.new;
    }
    
    return _postAppealVM;
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
