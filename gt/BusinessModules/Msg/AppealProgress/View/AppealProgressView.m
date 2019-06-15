//
//  AppealProgressView.m
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealProgressView.h"
#import "AppealProgressCell.h"
#import "AppealProgresssHeaderView.h"

@interface AppealProgressView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) DataTypeBlock block;
@property (nonatomic, strong) AppealProgressModel *model;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *buttomView;
@property (nonatomic, assign)CGFloat buttomHeith;
@end

@implementation AppealProgressView


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VicNavigationHeight + 10*SCALING_RATIO, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - (VicNavigationHeight + 10.5*SCALING_RATIO + self.buttomHeith))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AppealProgressCell  class] forCellReuseIdentifier:@"AppealProgressCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(instancetype)initWithBlockSuccess:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -VicNavigationHeight,MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = kWhiteColor;
        self.block = block;
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, VicNavigationHeight, MAINSCREEN_WIDTH, 10*SCALING_RATIO)];
        lineV.backgroundColor = kTableViewBackgroundColor;
        [self addSubview:lineV];
        float hi = ([YBSystemTool isIphoneX]?  [YBFrameTool tabBarHeight]: 60*SCALING_RATIO);
        self.buttomHeith = hi;
        
    } return self;
}

-(void)layoutView:(AppealProgressModel*)model{
    self.model = model;
    [self.buttomView removeAllSubViews];
    self.buttomView = [self creatButtonView:self.model];
    [self addSubview:self.buttomView];
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[AppealProgresssHeaderView alloc] initWithAppealProgressData:self.model BlockSuccess:^(NSInteger types, id data2) {
        if (self.block) {
            NSArray *ar = self.model.appeal[@"data"];
            self.block(progressExamImageType, ar);
        }
    }];
    [self.tableView reloadData];
}



#pragma mark tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppealProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppealProgressCell" forIndexPath:indexPath];
    [cell realData:self.model];
    return cell;
}


-(UIView*)creatButtonView:(AppealProgressModel*)model{
    
    NSInteger count = 1;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - self.buttomHeith , MAINSCREEN_WIDTH, self.buttomHeith)];
    NSLog(@"--- %f",self.buttomHeith);
//    v.backgroundColor = kBlueColor;
    UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 0.5*SCALING_RATIO)];
    linV.backgroundColor = HEXCOLOR(0xe6e6e6);
    [v addSubview:linV];
   
    if (!model.isAppealer) {//我是被申诉人时
        //            //仲裁中,,指已经发起了反申诉
        if ([model.status isEqualToString:@"4"]) {
            count = 2;
            [self addNoeButton:@"您已发起反申诉，点击取消" withSubview:v];
        } else{
            if ([model.reason isEqualToString:@"2_B_1_5"]) {//已付款，但未在时间内点击确认付款
                count = 3;
                [self addTwoButton:@"未收到汇款" andButton:@"放行BUB" withSubview:v];
            }else if ([model.reason isEqualToString:@"1_B_1_2"] ){//卖家责任超时
                count = 3;
                [self addTwoButton:@"去申诉" andButton:@"放行BUB" withSubview:v];
                //                [self initCutDown]; 、、倒计时
            } else if ([model.reason isEqualToString:@"0_B_1_2"]){ //已付款 申诉 选择其他原因 ---- 倒计时
                count = 3;
               [self addTwoButton:@"未收到汇款" andButton:@"放行BUB" withSubview:v];
//                [self initCutDown]; 、、倒计时
            }else if ([model.reason isEqualToString:@"1_S_1_2"]){//买家被申诉,,未付款却点击了"已付款"
                count = 2;
                [self addNoeButton:@"我已转账,我要申诉" withSubview:v];
            }else { // 其他
                
            }
        }
    } else {//我是申诉人
        count = 2;
        [self addNoeButton:@"取消申诉" withSubview:v];
    }
    UIView *leftV = [self creatLeftButton:model.isBuy full: count == 1? YES :NO];
    [v addSubview:leftV];
    return v;
}


-(void)addTwoButton:(NSString*)titel1 andButton:(NSString*)titel2 withSubview:(UIView*)vi{
    
   
    UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bu1 setTitle:titel2 forState:UIControlStateNormal];
    bu1.userInteractionEnabled = YES;
    bu1.titleLabel.font = kFontSize(15*SCALING_RATIO);
    bu1.layer.masksToBounds = YES;
    bu1.layer.cornerRadius = 4;
    [bu1 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    bu1.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    bu1.layer.borderWidth = 1.0f;
    bu1.frame = CGRectMake(86*SCALING_RATIO , 7*SCALING_RATIO, 108*SCALING_RATIO, 42*SCALING_RATIO);
    [bu1 addTarget:self action:@selector(buttomAction1:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:bu1];
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bu2 setTitle:titel1 forState:UIControlStateNormal];
    bu2.userInteractionEnabled = YES;
    bu2.layer.masksToBounds = YES;
    bu2.layer.cornerRadius = 4;
    bu2.titleLabel.font = kFontSize(15*SCALING_RATIO);
    [bu2 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    bu2.backgroundColor = HEXCOLOR(0x4c7fff);
    bu2.frame = CGRectMake(MAINSCREEN_WIDTH - 150*SCALING_RATIO -14*SCALING_RATIO, 7*SCALING_RATIO, 150*SCALING_RATIO, 42*SCALING_RATIO);
    [bu2 addTarget:self action:@selector(buttomAction2:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:bu2];

}

-(void)addNoeButton:(NSString*)titel withSubview:(UIView*)vi{
    
    UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bu1 setTitle:titel forState:UIControlStateNormal];
    bu1.userInteractionEnabled = YES;
    bu1.layer.masksToBounds = YES;
    bu1.layer.cornerRadius = 4;
    bu1.titleLabel.font = kFontSize(15*SCALING_RATIO);
    [bu1 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    bu1.backgroundColor = HEXCOLOR(0x4c7fff);
    bu1.frame = CGRectMake(MAINSCREEN_WIDTH - 278*SCALING_RATIO -14*SCALING_RATIO, 7*SCALING_RATIO, 278*SCALING_RATIO, 42*SCALING_RATIO);
    [bu1 addTarget:self action:@selector(buttomAction1:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:bu1];
    
}



-(UIView*)creatLeftButton:(BOOL)bo full:(BOOL)full{
    float wi = 60*SCALING_RATIO;
    if (full) {
        wi = MAINSCREEN_WIDTH- 28*SCALING_RATIO;
    }

    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(16*SCALING_RATIO, 1*SCALING_RATIO,wi, self.buttomHeith)];
    vi.backgroundColor = kWhiteColor;
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake((wi - 23*SCALING_RATIO)/2, 9*SCALING_RATIO,23*SCALING_RATIO, 23*SCALING_RATIO)];
//    UIImageView *im = [[UIImageView alloc] init];
    im.userInteractionEnabled = YES;
    [vi addSubview:im];
    im.image = [UIImage imageNamed:@"contactSellerXi"];
//    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(vi).offset(9);
//        make.height.with.mas_equalTo(23);
//        make.centerX.mas_equalTo(vi.mas_centerX);
//    }];
    
    UILabel *appealTimeLable = [[UILabel alloc] initWithFrame:CGRectMake((wi -60*SCALING_RATIO)/2 , 35*SCALING_RATIO, 60*SCALING_RATIO, 16*SCALING_RATIO)];
//    UILabel *appealTimeLable = [[UILabel alloc] init];
    [vi addSubview:appealTimeLable];
    appealTimeLable.userInteractionEnabled = YES;
    appealTimeLable.font = [UIFont systemFontOfSize:12*SCALING_RATIO];
    appealTimeLable.textColor =  HEXCOLOR(0x4c7fff);
    if (bo) {
       appealTimeLable.text = @"联系卖家";
    }else{
        appealTimeLable.text = @"联系买家";
    }
//    [appealTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(vi).offset(35);
//        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(60);
//        make.centerX.mas_equalTo(vi.mas_centerX);
//    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttomTapAction)];
    [vi addGestureRecognizer:tap];
    return vi;
}

-(void)buttomTapAction{
    if (self.model.isBuy) {
        self.block(progressContactSellers,self.model);
    }else{
        self.block(progressContactBuyer,self.model);
    }
}

-(void)buttomAction1:(UIButton*)bu{
    if (self.block) {
        NSString *s = bu.titleLabel.text;
        AppealProgressType typ = [self buttonTitelString:s];
        self.block(typ,self.model);
    }
}

-(void)buttomAction2:(UIButton*)bu{
    if (self.block) {
        NSString *s = bu.titleLabel.text;
        AppealProgressType typ = [self buttonTitelString:s];
        self.block(typ,self.model);
    }
}

//progressGotoAppeal, //去申诉
//progressCancelAppeal,  // 取消申诉
//progressReleaseBUB,  // 放行BUB
//progressContactOrder,  // 取消订单
//progressZZToAppeal, //我已转账,我要申诉
//progressNotReceived, // 未收到汇款
// progressQXFAppeal //您已发起反申诉，点击取消

-(AppealProgressType)buttonTitelString:(NSString*)titel{
    
    AppealProgressType ty = 30;
    if ([titel isEqualToString:@"去申诉"]) {
        ty = progressGotoSellerAppeal;
    }else if ([titel isEqualToString:@"取消申诉"]){
        ty = progressCancelAppeal;
    }
    else if ([titel isEqualToString:@"放行BUB"]){
        ty = progressReleaseBUB;
    }
    else if ([titel isEqualToString:@"取消订单"]){
        ty = progressContactOrder;
    }
    else if ([titel isEqualToString:@"我已转账,我要申诉"]){
        ty = progressZZToAppeal;
    }else if ([titel isEqualToString:@"未收到汇款"]){
        ty = progressNotReceived;
    }else if ([titel isEqualToString:@"您已发起反申诉，点击取消"]){
        ty = progressQXFAppeal;
    }
    return ty;
}

@end
