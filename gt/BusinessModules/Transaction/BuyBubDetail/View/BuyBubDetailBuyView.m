//
//  BuyBubDetailBuyView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyBubDetailBuyView.h"
#import "BuyHeaderView.h"
#import "BuyDetailTypeCell.h" // 第一栏样式 、、订单状态样式
#import "BuyDetailTemCell.h"  // 中间 cell
#import "BuyBubDetailModel.h"
#import "BuyBubDetailTimeCell.h" // 时间cell
#import "BaseCell.h"

//  food样式
#import "BuyDetailQRFooterV.h"  //  BuyBubDetail_BuyTime
#import "BuyBubDetailTextFooderV.h"
#import "BuyDetailBulTextFooderV.h"
#import "BuyDetailTimeTextFooderV.h"
#import "BuyDetailSellFinishFoodV.h" // 特殊不要脸的两个 完成就两行
// 底部按钮
#import "BuyFooderButtonV.h"

@interface BuyBubDetailBuyView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy)   DataTypeBlock block;
@property (nonatomic, strong) BuyHeaderView *myHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BuyFooderButtonV *buttomButViwe; // 最底部按钮样式
@property (nonatomic, strong) BuyBubDetailModel *dataModel;

@end

@implementation BuyBubDetailBuyView

-(instancetype)initWithFrame:(CGRect)frame  actionBlock:(DataTypeBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.backgroundColor = kWhiteColor;
        float naHi =  YBSystemTool.isIphoneX ? 88 : 64;
        float hi = YBSystemTool.isIphoneX ? 60*SCALING_RATIO+20 : 60*SCALING_RATIO;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - naHi - hi) style:UITableViewStylePlain];
        [self addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        kWeakSelf(self);
        [self.tableView YBGeneral_addRefreshHeader:^{
            [weakself timeReloadData];
        }];
        self.myHeaderView = [[BuyHeaderView alloc] init];
        self.tableView.tableHeaderView = self.myHeaderView;
        
        UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height- naHi -hi, MAINSCREEN_WIDTH, 0.5)];
        lin.backgroundColor = HEXCOLOR(0xe6e6e6);
        [self addSubview:lin];
        self.buttomButViwe = [[BuyFooderButtonV alloc] initWithActionBlock:^(id data) {
            [weakself addButtomBtnView:data];
        }];
        self.buttomButViwe.frame = CGRectMake(0, frame.size.height- naHi -hi + 2, MAINSCREEN_WIDTH, hi);
        [self addSubview:self.buttomButViwe];
    } return self;
}

-(void)reloadTableViewDataWith:(nullable id)data andHeaderTitleAr:( nullable NSArray*)ar{
     [self.tableView.mj_header endRefreshing];
    self.dataModel = data;
    if (ar) {
         [self.myHeaderView chooseItem:self.dataModel.scheduleType andTitelAR:ar];
    }
    [self.tableView reloadData];
    [self addFooderView];
    [self.buttomButViwe addButtonViewWith:self.dataModel.buttomBtnArr];
}


#pragma mark tableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataModel.buyType == BuyBubDetail_BuyTime) {
        return 3;
    }else if (self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor){
        return 4;
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return self.dataModel.twoCellArr.count;
    }else if (section == 2){
        return 1;
    }else if (section == 3 && self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor ){
        return self.dataModel.bankCarInfor.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.dataModel.noeCellHi;     //  只有标题 没有图片 没有小标题  58    只有标题 有有图片 80   三个有 // 112
    }else if(indexPath.section == 1){
        return 28*SCALING_RATIO;
    }else if (indexPath.section == 2){
        return 60*SCALING_RATIO;
    }else if (indexPath.section == 3 && self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor){
        return 28*SCALING_RATIO;
    }else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 && self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor) {
        return 40*SCALING_RATIO;
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3 && self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 40*SCALING_RATIO)];
        
        UIView*linV = [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 39*SCALING_RATIO, MAINSCREEN_WIDTH - 30 *SCALING_RATIO, 1)];
        [v addSubview:linV];
        
        linV.backgroundColor = HEXCOLOR(0xf0f1f3);
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 2*SCALING_RATIO, 200*SCALING_RATIO, 36*SCALING_RATIO)];
        la.textColor = HEXCOLOR(0x333333);
        la.font = kFontSize(14*SCALING_RATIO);
        la.text = @"使用银行卡账号汇款";
        [v addSubview:la];
        
        return v;
    }else{
        return [[UIView alloc] init];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BuyDetailTypeCell  *cell = [BuyDetailTypeCell cellWith:tableView];
        cell.myData = self.dataModel;
        return cell;
        
    }else if(indexPath.section == 1){
        BuyDetailTemCell  *cell = [BuyDetailTemCell cellWith:tableView];
        NSDictionary *dic = self.dataModel.twoCellArr[indexPath.row];
        [cell cellDataWithDic:dic];
        return cell;
    }else if (indexPath.section ==  2){
        BuyBubDetailTimeCell  *cell = [BuyBubDetailTimeCell cellWith:tableView];
        kWeakSelf(self);
        [cell timeReloadWeithTimeModel:self.dataModel actionBlock:^(id data) {
            [weakself timeReloadData];
        }];
        return cell;
    }else if (indexPath.section == 3 && self.dataModel.buyType == BuyBubDetail_BuyTimeAndBankInfor ){
        BuyDetailTemCell  *cell = [BuyDetailTemCell cellWith:tableView];
        NSDictionary *dic = self.dataModel.bankCarInfor[indexPath.row];
        [cell cellShowCopyButnWithDic:dic];
        return cell;
    }else{
        BaseCell *cell = [BaseCell cellWith:tableView];
        cell.hideSeparatorLine = YES;
        cell.frame = CGRectZero;
        return cell;
    }
}



-(void)addFooderView{
    
    if (self.dataModel.buyType == BuyBubDetail_BuyTime) { // 有二维码
        kWeakSelf(self);
        BuyDetailQRFooterV *v = [[BuyDetailQRFooterV alloc] initWithTitleString:self.dataModel.payCardString andPayCode:self.dataModel.payCodeS andQRUrlString:self.dataModel.payQrUrls actionBlock:^(id data) {
            kStrongSelf(self);
            if (self.block) {
                self.block(BuyTapTypeToOrthApp, data);
            }
        }];
        self.tableView.tableFooterView = v;
    }
    else if (self.dataModel.buyType == BuyBubdetail_Text){ // 两列文本类型
        kWeakSelf(self);
        BuyBubDetailTextFooderV *v = [[BuyBubDetailTextFooderV alloc] initWithTimeString:self.dataModel actionBlock:^(id data) {
            [weakself timeReloadData];
        }];
        self.tableView.tableFooterView = v;
    }
    else if (self.dataModel.buyType == BuyBubdetail_BulText){ // // 一列蓝色字样式
        BuyDetailBulTextFooderV *v = [[BuyDetailBulTextFooderV alloc] initWithString:self.dataModel.fooderString];
        self.tableView.tableFooterView = v;
    }
    else if (self.dataModel.buyType == BuyBubdetail_TimeText ){ // //// 有倒计时 下面还有一行文字
        kWeakSelf(self);
        BuyDetailTimeTextFooderV *v = [[BuyDetailTimeTextFooderV alloc] initWithTime:self.dataModel anddetailString:self.dataModel.fooderString actionBlock:^(id data) {
            [weakself timeReloadData];
        }];
        self.tableView.tableFooterView = v;
    }else if (self.dataModel.buyType == BuyBubdetail_SellFinish){
        BuyDetailSellFinishFoodV *v = [[BuyDetailSellFinishFoodV alloc] initWithDataArrary:self.dataModel.sellFinishDic];
        self.tableView.tableFooterView = v;
    }
    else{
        self.tableView.tableFooterView = [UIView new];
    }
    
}


-(void)addButtomBtnView:(NSString*)butTitelS{
    if (butTitelS && self.block) {
        if ([butTitelS isEqualToString:@"lianXi"]) {
            if (self.block) {self.block(BuyTapTypeContactOther, nil);}
        }
        else if ([butTitelS isEqualToString:CancleOrder]){
            if (self.block) { self.block(BuyTapTypeCancelOrders, self.dataModel.orderNo);}
        }
        else if ([butTitelS isEqualToString:MeRedPay]){ // 我已付款 s刷新数据
            if (self.block) { self.block(BuyTapTypeBuyRelease, nil);}
        }
        else if ([butTitelS isEqualToString:ToAppeal]){// 去申诉
            if (self.block) { self.block(BuyTapTypeToAppeal, self.dataModel.orderNo);}
        }
        else if ([butTitelS isEqualToString:SellRelease]){ // 卖家确认收款，放行订单
            if (self.block) {self.block(BuyTapTypeSellReleaseOrders, self.dataModel.orderNo);}
        }
        else if ([butTitelS isEqualToString:SeeMyaSsets]){ // 查看资产
            if (self.block) {self.block(BuyTapTypeSeeMyaSsets, nil);}
        }
        else if ([butTitelS isEqualToString:ToConsumption]){ // 现在去消费
            if (self.block) {self.block(BuyTapTypeSeeToConsumption, nil);}
        }
        else if ([butTitelS isEqualToString:CloseAppeal]){ // 取消z申诉
            if (self.block) {self.block(BuyTapTypeCloseAppeal, nil);}
        }
    }
}


-(void)timeReloadData{
    if (self.block) {
        self.block(BuyTapTypeTimeReloadDa, nil);
    }
}

@end
