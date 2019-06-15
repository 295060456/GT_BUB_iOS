//
//  AccountMianView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AccountMianView.h"
#import "MyAccountWidthCell.h"
#import "MyAccountNarrowCell.h"
#import "PaymentAccountModel.h"




@interface AccountMianView()<UITableViewDelegate,UITableViewDataSource,MyAccountNarrowCellDelegate>{
    UIButton *_addButtomBu;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) DataTypeBlock block;
@property (nonatomic, strong) PaymentAccountModel* model;
@property (nonatomic, strong) PaymentAccountData *showChooseModel;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIImageView *emptyData;
@property (nonatomic, strong) NSMutableArray *chooseAr;
@property (nonatomic, strong) NSIndexPath *showIndexS;
@end



@implementation AccountMianView

-(NSMutableArray*)chooseAr{
    if (_chooseAr == nil) {
        _chooseAr = [NSMutableArray array];
    } return _chooseAr;
}

-(instancetype)initWithBlockSuccess:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:250.0/256 alpha:1];
        [self addSubview:self.tableView];
        float higth = [YBFrameTool getNavigationHeight] + ([YBSystemTool isIphoneX]? 22: 0);
        float hi = higth + 62*SCALING_RATIO;
        self.tableView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, self.bounds.size.height - hi);
        self.isEdit = NO;
    } return self;  
}

-(void)reloadDataWith:(id)data{
    
    [self.tableView.mj_header endRefreshing];
    [self.chooseAr removeAllObjects];
    self.showIndexS = [NSIndexPath indexPathForRow:10000 inSection:10000];
    if (data) {
        self.isEdit = NO;
        self.model = data;
        [self.tableView reloadData];
        [self addButtomBu];
        NSArray *ar = self.model.datas;
        if (ar == nil || ar.count == 0) {
            [self addSubview:self.emptyData];
        }else{
            [self.emptyData removeFromSuperview];
            self.emptyData = nil;
        }
    }
}

-(void)addButtomBu{
    if (_addButtomBu == nil) {
        float higth = [YBSystemTool isIphoneX]? 22: 0;
        float hi = higth + 62*SCALING_RATIO + [YBFrameTool getNavigationHeight];
        UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - hi + 1, MAINSCREEN_WIDTH, 1)];
        linV.backgroundColor = HEXCOLOR(0xdddddd);
        [self addSubview:linV];
        _addButtomBu = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButtomBu.frame = CGRectMake(20* SCALING_RATIO, self.bounds.size.height - hi + 11* SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 40*SCALING_RATIO);
        _addButtomBu.backgroundColor = HEXCOLOR(0x4c7fff);
        _addButtomBu.layer.masksToBounds = YES;
        _addButtomBu.layer.cornerRadius = 6*SCALING_RATIO;
        [_addButtomBu setTintColor:kWhiteColor];
        [_addButtomBu setTitle:@"添加收款账户" forState:(UIControlStateNormal)];
        [_addButtomBu addTarget:self action:@selector(addButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_addButtomBu];
    }
}

-(void)addButtonClicked{
    if (self.block) {
        self.block(accountAdd, self.model);
    }
}

- (void)tableViewfreshHeader{
    if (self.block) {
        self.block(accountfreshHeader, self.model);
    }
}

-(void)viewBigPictureModel:(id)model{
    if (self.block) {
        self.block(accountBigPicture, model);
    }
}

-(void)toEdit:(BOOL)isEdit{
    self.isEdit = isEdit;
    if (isEdit == NO) {
        if (self.chooseAr.count==0) {
            [self.tableView reloadData];
            return;
        }
        if (self.block) {
            NSArray *ar = [NSArray arrayWithArray:self.chooseAr];
            self.block(accountDetele, ar);
        }
    }else{
        [self.tableView reloadData];
    }
    for (PaymentAccountData *miniModel in self.chooseAr) {
        miniModel.editChooseCell = NO;
    }
    [self.chooseAr removeAllObjects];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PaymentSectionMo * m = self.model.datas[section];
    NSArray *row = m.data;
    return row.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f*SCALING_RATIO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    PaymentSectionMo * m = self.model.datas[section];
    titleLab.text = [NSString stringWithFormat:@"%@",m.title];
    [titleLab setTextColor:HEXCOLOR(0x333333)];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Semibold"
                                      size:17]];
    [titleLab sizeToFit];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(20);
    }];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaymentSectionMo * m = self.model.datas[indexPath.section];
    NSArray *row = m.data;
    
    PaymentAccountData *miniModel = row[indexPath.row];
    if (indexPath.row == row.count-1 || miniModel.showChooseCell) {
        return  127*SCALING_RATIO;
    }else{
        return 46*SCALING_RATIO;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentSectionMo * m = self.model.datas[indexPath.section];
    NSArray *row = m.data;
    PaymentAccountData *miniModel = row[indexPath.row];
    if (indexPath.row == row.count-1 || miniModel.showChooseCell) {
        MyAccountWidthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountWidthCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell reloadCellDataWith:miniModel andEdit:self.isEdit showBG:[self judgeWidthCellShowWith:indexPath andModel:m]];
        return cell;
    }else{
        MyAccountNarrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountNarrowCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell reloadCellDataWith:miniModel andEdit:self.isEdit showBG:[self judgeNarrowCellShowWith:indexPath]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentSectionMo * m = self.model.datas[indexPath.section];
    NSArray *row = m.data;
    PaymentAccountData *miniModel = row[indexPath.row];
    if (self.showChooseModel) {
        self.showChooseModel.showChooseCell = NO;
    }
    self.showIndexS = indexPath;
    self.showChooseModel = miniModel;
    miniModel.showChooseCell = YES;
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = HEXCOLOR(0xF8F9F9);
        [_tableView registerClass:[MyAccountWidthCell class] forCellReuseIdentifier:@"MyAccountWidthCell"];
        [_tableView registerClass:[MyAccountNarrowCell class] forCellReuseIdentifier:@"MyAccountNarrowCell"];
        kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            [weakself  tableViewfreshHeader];
        }];
        UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 16*SCALING_RATIO)];
        v.backgroundColor = HEXCOLOR(0xF8F9F9);
        _tableView.tableHeaderView = v;
    }
    return _tableView;
}

-(UIImageView*)emptyData{
    if (_emptyData == nil) {
        _emptyData = [[UIImageView alloc] initWithFrame:CGRectMake(116*SCALING_RATIO, 115*SCALING_RATIO, 143*SCALING_RATIO, 143*SCALING_RATIO)];
        _emptyData.image = kIMG(@"invalidNameXR");
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 180*SCALING_RATIO, 140*SCALING_RATIO, 22*SCALING_RATIO)];
        la.textColor = HEXCOLOR(0x999999);
        la.textAlignment = NSTextAlignmentRight;
        la.font = kFontSize(16*SCALING_RATIO);
        la.text = @"暂无收款账户～";
        [_emptyData addSubview:la];
    } return  _emptyData;
}

-(void)myAccountWidthCellActin:(UIButton*)button andModel:(id)model{
    [self myAccountNarrowCellActin:button andModel:model];
}

-(void)myAccountNarrowCellActin:(UIButton*)button andModel:(id)model{
    
    PaymentAccountData *accdata = model;
    if (accdata.editChooseCell) {
        [self.chooseAr removeObject:accdata];
        accdata.editChooseCell = NO;
        [button setImage:kIMG(@"idNameX") forState:(UIControlStateNormal)];
    }else{
        [self.chooseAr addObject:accdata];
        accdata.editChooseCell = YES;
        [button setImage:kIMG(@"invalidNameX") forState:(UIControlStateNormal)];
    }
}


-(BOOL)judgeWidthCellShowWith:(NSIndexPath*)indexPath andModel:(PaymentSectionMo *)m{
    BOOL sho = YES;
    if (indexPath.row == 0) {
        sho = NO;
    }else if (indexPath.section == self.showIndexS.section){
        if (indexPath.row == self.showIndexS.row-1) {
            sho = NO;
        }else if (self.showIndexS.row == m.data.count-2){
            if (indexPath.row == m.data.count-1) {
                sho = NO;
            }
        }
    }
    return sho;
}

-(BOOL)judgeNarrowCellShowWith:(NSIndexPath*)indexPath {
    BOOL sho = YES;
    if (indexPath.row == 0 ) {
        sho = NO;
    }else if (indexPath.section == self.showIndexS.section) {
        if (indexPath.row == self.showIndexS.row + 1) {
            sho = NO;
        }
    }
    return sho;
}

@end
