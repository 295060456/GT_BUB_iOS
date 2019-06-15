//
//  PostAdsPayChooseView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/23.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAdsPayChooseView.h"
#import "PostAdsPayChooseCell.h"

@interface PostAdsPayChooseView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSArray *myData;
@property (nonatomic ,copy) DataBlock myBlock;
@property (nonatomic ,strong) UITableView *myaTableView;
@property (nonatomic ,strong) NSMutableArray *firstAr;
@property (nonatomic ,assign) TransactionAmountType myType;
@end


@implementation PostAdsPayChooseView

-(instancetype)initWithMydata:(id)data andType:(TransactionAmountType)type block:(DataBlock)block{
    self = [super init];
    if (self) {
        self.myData = data;
        self.myBlock = block;
        self.myType = type;
        self.firstAr  = [NSMutableArray array]; // 记录旧数据
        if (self.myType == TransactionAmountTypeLimit) { // 单额
            for (AccountPaymentWayModel *model in singLeton.chooseModelAr1) {
                [self.firstAr addObject:model];
            }
        }else{
            for (AccountPaymentWayModel *model in singLeton.chooseModelAr2) {
                [self.firstAr addObject:model];
            }
        }
        self.alpha = 0.1;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.7];
        float bottom = YBSystemTool.isIphoneX? 62*SCALING_RATIO + 20 : 62*SCALING_RATIO;
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 235*SCALING_RATIO)];
        [self addSubview:tapV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QXAction)];
        [tapV addGestureRecognizer:tap];
        
        self.myaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT +235*SCALING_RATIO, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - 235*SCALING_RATIO - bottom) style:(UITableViewStyleGrouped)];
        self.myaTableView.backgroundColor = kWhiteColor;
        self.myaTableView.delegate = self;
        self.myaTableView.dataSource = self;
        self.myaTableView.separatorStyle = NO;
        [self addSubview:self.myaTableView];
        [self.myaTableView registerClass:[PostAdsPayChooseCell class] forCellReuseIdentifier:@"PostAdsPayChooseCell"];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.myaTableView.frame), MAINSCREEN_WIDTH, bottom)];
        v.backgroundColor = kWhiteColor;
        [self addSubview:v];
        
        UIButton *bu1 = [self creatButtonWithTitle:@"取消" setTitleColor:HEXCOLOR(0x4c7fff) setImage:nil backgroundColor:kWhiteColor cornerRadius:4 borderWidth:1 borderColor:HEXCOLOR(0x4c7fff) action:@selector(QXAction)];
        bu1.frame = CGRectMake(16*SCALING_RATIO, 10*SCALING_RATIO, 170*SCALING_RATIO,42*SCALING_RATIO);
        [v addSubview:bu1];
        
        UIButton *bu2 = [self creatButtonWithTitle:@"保存" setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:4 borderWidth:0 borderColor:nil action:@selector(suerAction)];
        bu2.frame = CGRectMake(192*SCALING_RATIO, 10*SCALING_RATIO, 170*SCALING_RATIO,42*SCALING_RATIO);
        [v addSubview:bu2];
        
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,0, MAINSCREEN_WIDTH, 49* SCALING_RATIO)];
        headerV.backgroundColor = kWhiteColor;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,3, MAINSCREEN_WIDTH, 49* SCALING_RATIO -6)];
        [headerV addSubview:titleLab];
        titleLab.textColor = HEXCOLOR(0x333333);
        titleLab.font = kFontSize(17*SCALING_RATIO);
        titleLab.text = @"收款账户编辑";
        titleLab.backgroundColor = kWhiteColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIView *lineVs = [[UIView alloc] initWithFrame:CGRectMake(0, 48* SCALING_RATIO, MAINSCREEN_WIDTH, 1)];
        lineVs.backgroundColor = HEXCOLOR(0xf4f4f4);
        [headerV addSubview:lineVs];
        self.myaTableView.tableHeaderView = headerV;
        
        [UIView animateWithDuration:0.3 animations:^{
            v.frame = CGRectMake(0, MAINSCREEN_HEIGHT - bottom, MAINSCREEN_WIDTH, bottom);
            self.myaTableView.frame = CGRectMake(0, 235*SCALING_RATIO, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - 235*SCALING_RATIO - bottom);
            self.alpha = 1.0;
        }];
        
    }return self;
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *modelDic = self.myData[section];
    NSArray *ar = modelDic[@"data"];
    return ar.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50*SCALING_RATIO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 58.5 * SCALING_RATIO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hearderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 44.5 * SCALING_RATIO)];
    hearderV.backgroundColor = kWhiteColor;
    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 14*SCALING_RATIO, MAINSCREEN_WIDTH-30*SCALING_RATIO, 44.5 * SCALING_RATIO)];
    v.backgroundColor = HEXCOLOR(0xf8f9f9);
    
    [self applyRoundCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) radius:6*SCALING_RATIO view:v andPathTyp:0];
    [hearderV addSubview:v];
    
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(15* SCALING_RATIO, 13* SCALING_RATIO, 16, 16)];
    [v addSubview:im];
    NSDictionary *dic = self.myData[section];
    im.image = kIMG(dic[@"iconImage"]);
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(36* SCALING_RATIO, 13* SCALING_RATIO, 150* SCALING_RATIO, 16* SCALING_RATIO)];
    titleLab.textColor = HEXCOLOR(0x333333);
    titleLab.font = kFontSize(15*SCALING_RATIO);
    titleLab.text = dic[@"title"];
    [v addSubview:titleLab];
    return hearderV;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *modelDic = self.myData[indexPath.section];
    NSArray *ar = modelDic[@"data"];
    AccountPaymentWayModel *cellModel = ar[indexPath.row];
    NSMutableArray *chooseArr = singLeton.chooseModelAr2;
    if (self.myType == TransactionAmountTypeLimit) {
        chooseArr = singLeton.chooseModelAr1;
    }
    if (chooseArr.count == 1 && [chooseArr[0] isEqual:cellModel]) { // 必须一个
        return;
    }
    
    //   数组是否包含该类型
    //     -  不包含  直接添加）
    //     二  包含该类型
    //       1. 是不是同一model 是 变NO移除
    //       2. 不是 上一model 移除病变NO 该mode 添加并 变YES
    BOOL isContemt = NO;
    BOOL isOneModel = NO;
    AccountPaymentWayModel *models = nil;
    for (AccountPaymentWayModel *model in chooseArr) {
        if ([model.paymentWay isEqualToString:cellModel.paymentWay]) {
            isContemt = YES;
            models = model;
        }
        if ([model isEqual:cellModel]) {
            isOneModel = YES;
        }
    }
    if (isContemt) {
        if (isOneModel) {
            [chooseArr removeObject:cellModel];
//            cellModel.isSelected = NO;
        }else{
            if (models) {
//                models.isSelected = NO;
                [chooseArr removeObject:models];
            }
//            cellModel.isSelected = YES;
            [chooseArr addObject:cellModel];
        }
    }else{
        [chooseArr addObject:cellModel];
//        cellModel.isSelected = YES;
    }
    NSLog(@"---- %@",chooseArr);
    [self.myaTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostAdsPayChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostAdsPayChooseCell" forIndexPath:indexPath];
    
    NSDictionary *modelDic = self.myData[indexPath.section];
    NSArray *ar = modelDic[@"data"];
    AccountPaymentWayModel *cellModel = ar[indexPath.row];
    [cell realCellDataWithModel:cellModel withChooseAr:self.myType==TransactionAmountTypeLimit?singLeton.chooseModelAr1:singLeton.chooseModelAr2 andShowBottomLien:indexPath.row+1 == ar.count?YES:NO   block:^(id data) {}];
    return cell;
}


-(void)QXAction{
    // 还原初
    if (self.myType == TransactionAmountTypeLimit) {
        [singLeton.chooseModelAr1 removeAllObjects];
        for (AccountPaymentWayModel *model in self.firstAr) {
            [singLeton.chooseModelAr1 addObject:model];
        }
    }else{
        [singLeton.chooseModelAr2 removeAllObjects];
        for (AccountPaymentWayModel *model in self.firstAr) {
            [singLeton.chooseModelAr2 addObject:model];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)suerAction{ // 确定

    if (self.myBlock) {
        self.myBlock(@(self.myType));
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius view:(UIView *) view andPathTyp:(NSInteger)type{
    CGRect rect;
    for (CAShapeLayer *layer in view.layer.sublayers){
        [layer removeFromSuperlayer];
    }
    if (type == 0) { // 不要底线
        rect = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height+10);
    }else if (type == 1){ // 不要顶部
        rect = CGRectMake(0, -10, view.bounds.size.width, view.bounds.size.height+10);
    }else if (type == 2){ // 上下
        rect = CGRectMake(0, -2, view.bounds.size.width, view.bounds.size.height+4);
        radius =0;
    }else{rect = view.bounds; }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *temp = [CAShapeLayer layer];
    temp.lineWidth = 1.f;
    temp.fillColor = [UIColor clearColor].CGColor;
    temp.strokeColor = HEXCOLOR(0xe4e4e4).CGColor;
    temp.frame = view.bounds;
    temp.path = path.CGPath;
    [view.layer addSublayer:temp];
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
    mask.path = path.CGPath;
    view.layer.mask = mask;
    view.clipsToBounds=YES;
}

-(void)dealloc{
    
}
@end
