//
//  HomeView.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransactionView.h"
#import "TransactionCell.h"
#import "BaseCell.h"
#import "SDRangeSliderView.h"
#import "FixedRectTagView.h"
#import "TransactionVM.h"
#import "TransactionModel.h"
#define kHeightForListHeaderInSections 5


#define BTNTAG 889
#define OTHERBTNTAG 1306

@interface TransactionView () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, copy)NSString *choosePayWay ;  // 筛选按钮  0 ：全部 1 银行卡  2 支付宝 3 微信
@property (nonatomic, strong) SDRangeSliderView* slider;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UIView * bottomLine2;

@property (nonatomic, strong) UIView *alphaBlackView;
@property (nonatomic, strong) UIButton * quickNolim;
@property (nonatomic, strong) UIButton * titleChoose;
@property (nonatomic, strong) UIView * serviceErrorView;
@property (nonatomic, strong) UIView * networkErrorView;
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic,assign) NSInteger fixedCount;
@property (nonatomic,assign) NSInteger choosePayMax ;  // 筛选最大值 2000
@property (nonatomic,assign) NSInteger choosePayMin ;  // 筛选最小值 0
@property (nonatomic,assign) TransactionAmountType transactionAmountType;
@property (nonatomic, strong) UIButton * topFunctionView;
@property (nonatomic, strong) UIView * chooseSubView;
@property (nonatomic, strong) UIButton * quickBtn;
@property (nonatomic, strong) UIButton * smallAndBig;

@property (nonatomic, strong) UILabel * sliderMin;
@property (nonatomic, strong) UILabel * sliderMax;
@property (nonatomic, strong)FixedRectTagView* qucikNumView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong)NSArray* fliterArr;
@property (nonatomic, strong) UITextField* tf;
@property (nonatomic, copy) NSString * inputTfString;

@property (nonatomic, strong) UIView *payMethodView;

@property (nonatomic, strong) NSMutableArray* fliterBtns;

@property (nonatomic, strong) NSMutableArray* paymentsBtns;
@property (nonatomic, strong) UIButton *paywayLastBtn;
@end


@implementation TransactionView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTopFunctionView];
        [self initViews];
        [self crateChooseSubView];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topFunctionView.mas_bottom);
    }];
    [self.tableView.mj_header beginRefreshing];
    
    kWeakSelf(self);
    self.networkErrorView = [self setNetworkErrorViewInSuperView:self leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self addButtonClicked];
    }];
    self.serviceErrorView = [self setServiceErrorViewInSuperView:self leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self addButtonClicked];
    }];
    self.dataEmptyView = [self setDataEmptyViewInSuperView:self withTopMargin:36];
    
}
- (void)initTopFunctionView{
    self.topFunctionView = [[UIButton alloc]init];
    [self addSubview:self.topFunctionView];
    [self.topFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@36);
    }];
    self.topFunctionView.selected = NO;
    self.topFunctionView.backgroundColor = [UIColor whiteColor];
    [self.topFunctionView addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* fliterIv = [[UIImageView alloc]init];
    fliterIv.image = kIMG(@"cTransAction_fliter");
    [self.topFunctionView addSubview:fliterIv];
    [fliterIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topFunctionView.mas_left).offset(22);
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self.topFunctionView);
    }];
    
    self.titleChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleChoose.selected = NO;
    self.titleChoose.userInteractionEnabled = NO;
//    [self.titleChoose addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    self.titleChoose.titleLabel.font = kFontMediumSize(18);
    [self.titleChoose setTitle:@"筛选" forState:UIControlStateNormal];
    [self.titleChoose setImage:[UIImage imageNamed:@"btnPop"] forState:UIControlStateNormal];
    [self.titleChoose setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [self.topFunctionView addSubview:self.titleChoose];
    [self.titleChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fliterIv.mas_right).offset(13);
//        make.width.mas_equalTo(90);
        make.height.mas_equalTo(self.topFunctionView);
    }];
    [self.titleChoose layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    self.titleChoose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _fliterBtns = [NSMutableArray array];
    _payMethodView = [[UIView alloc]init];
    _payMethodView.userInteractionEnabled = NO;
    [self.topFunctionView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.topFunctionView);
        make.left.equalTo(self.titleChoose.mas_right).offset(19);
    }];
    for (int i=0; i<2; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = kFontSize(13);
        [btn setTintColor:RGBCOLOR(76, 127, 255)];
        [_payMethodView addSubview:btn];
        [_fliterBtns addObject:btn];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGBCOLOR(76, 127, 255).CGColor;
    }
    [_fliterBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:16 leadSpacing:0 tailSpacing:0];
    
    [_fliterBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
//        make.width.mas_equalTo(@67);
        make.height.mas_equalTo(@21);
    }];
    
    [self richElementsInFliterBtns:@[@"",@""]];//@"支付方式",@"金额"
    
    [self richImageInTitleChooseBtns];
}

- (void)getInitFliterStatus{
    [self richElementsInFliterBtns:@[@"",@""]];//@"支付方式",@"金额"
    
    [self richImageInTitleChooseBtns];
    
    
    for (int i=0; i<_paymentsBtns.count; i++) {
        UIButton* btn = _paymentsBtns[i];
        btn.backgroundColor = HEXCOLOR(0xfafafa);
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    }
    UIButton* firstBtn = _paymentsBtns.firstObject;
    firstBtn.backgroundColor = HEXCOLOR(0x4c7fff);
    [firstBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.paywayLastBtn = firstBtn;
    self.choosePayWay = @"";
    
    [self changeQuickNoLimStatusIsSelected:YES];
    
    self.fliterArr = @[];
    [self.delegate transactionView:self requestListWithPage:1 WithFilterArr:self.fliterArr];
    
}
-(void)changeQuickNoLimStatusIsSelected:(BOOL)isSelected{
    if (isSelected) {
        self.quickNolim.backgroundColor = HEXCOLOR(0x4c7fff);
        [self.quickNolim setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
        self.inputTfString = @"";
        [self.qucikNumView clearSelecedBtn];
        self.tf.text = @"";
        self.tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    }else{
        self.quickNolim.backgroundColor = HEXCOLOR(0xfafafa);
        [self.quickNolim setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    }
}
-(void)clickQuickNoLim:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.quickNolim.backgroundColor = HEXCOLOR(0x4c7fff);
        [self.quickNolim setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
        self.inputTfString = @"";
        [self.qucikNumView clearSelecedBtn];
        self.tf.text = @"";
        self.tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    }else{
        self.quickNolim.selected = YES;//保证不反选
        self.quickNolim.backgroundColor = HEXCOLOR(0x4c7fff);
        [self.quickNolim setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
        self.inputTfString = @"";
        [self.qucikNumView clearSelecedBtn];
        self.tf.text = @"";
        self.tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        
        //可反选
//        self.quickNolim.backgroundColor = HEXCOLOR(0xfafafa);
//        [self.quickNolim setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    }
    
}

-(void)richImageInTitleChooseBtns{
    UIButton* btn0 = _fliterBtns.firstObject;
    UIButton* btn1 = _fliterBtns.lastObject;
    if ([btn0.titleLabel.text containsString:@"不限支付方式"]
        &&[btn1.titleLabel.text containsString:@"不限金额"]) {
        [self.titleChoose setImage:[UIImage imageNamed:@"btnPop"] forState:UIControlStateNormal];
    }else{
        [self.titleChoose setImage:[UIImage imageNamed:@"btnRight"] forState:UIControlStateNormal];
    }
}
-(void)richElementsInFliterBtns:(NSArray*)titles{
    UIButton* btn0 = _fliterBtns.firstObject;
    
    NSString* firstString = titles.firstObject;
    if ([firstString isEqualToString:@""]) {
        firstString = @"不限支付方式";
    }else if ([firstString isEqualToString:@"1"]){
        firstString = @"微信支付";
    }else if ([firstString isEqualToString:@"2"]){
        firstString = @"支付宝";
    }else if ([firstString isEqualToString:@"3"]){
        firstString = @"银行卡";
    }
    
    [btn0 setTitle:[NSString stringWithFormat:@" %@ ",firstString] forState:UIControlStateNormal];
    
//    NSInteger width = [NSString getTextWidth:[NSString stringWithFormat:@" %@ ",firstString] withFontSize:kFontSize(13) withHeight:21];
//    if (width>67) {
//        [btn0 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@(width));
//        }];
//    }else{
//        [btn0 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@67);
//        }];
//    }
    
    if ([btn0.titleLabel.text containsString:@"不限支付方式"]) {
        btn0.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [btn0 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
        [btn0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    }else{
        btn0.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [btn0 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [btn0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    }
    
    
    UIButton* btn1 = _fliterBtns.lastObject;
    NSString* lastString = titles.lastObject;
    if ([lastString isEqualToString:@""]) {
        lastString = @"不限金额";
    }
    
    [btn1 setTitle:[NSString stringWithFormat:@" %@ ",lastString] forState:UIControlStateNormal];
//    NSInteger width1 = [NSString getTextWidth:[NSString stringWithFormat:@" %@ ",lastString] withFontSize:kFontSize(13) withHeight:21];
//    if (width1>67) {
//        [btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@(width1));
//        }];
//    }else{
//        [btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(@67);
//        }];
//    }
    
    if ([btn1.titleLabel.text containsString:@"不限金额"]) {
        btn1.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [btn1 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    }else{
        btn1.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [btn1 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    }
    
    
    
}

- (void)filterAction:(UIButton *)sender{
    self.titleChoose.selected = !self.titleChoose.selected;
    if (self.titleChoose.selected) {
        
        [self.titleChoose setImage:[UIImage imageNamed:@"btnUp"] forState:UIControlStateNormal];
        _payMethodView.hidden = YES;
        self.chooseSubView.hidden = NO;
        self.alphaBlackView.hidden = NO;
        
//        [self getAdList];
    }else{
//        [self.titleChoose setImage:[UIImage imageNamed:@"btnPop"] forState:UIControlStateNormal];
        [self richImageInTitleChooseBtns];
        _payMethodView.hidden = NO;
        self.chooseSubView.hidden = YES;
        self.alphaBlackView.hidden = YES;
    }
}

- (void)crateChooseSubView{
    _paymentsBtns = [NSMutableArray array];
    self.chooseSubView = [[UIView alloc]init];
    [self addSubview:self.chooseSubView];
    
    self.chooseSubView.hidden = YES;
    self.chooseSubView.backgroundColor = [UIColor whiteColor];
    [self.chooseSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.topFunctionView.mas_bottom);
        make.height.mas_equalTo(258);
    }];
    
    UILabel * sepLine = [[UILabel alloc]init];
    sepLine.backgroundColor = kTableViewBackgroundColor;
    [self.chooseSubView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.chooseSubView);
        make.top.mas_equalTo(self.chooseSubView);
        make.height.mas_equalTo(5);
    }];
    
    UILabel * payWay = [[UILabel alloc]init];
    [self.chooseSubView addSubview:payWay];
    payWay.text = @"支付方式";
    payWay.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];;
    payWay.textColor = HEXCOLOR(0x333333);
    [payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
    }];
    
    NSArray* arr = @[@"不限",@"银行卡",@"支付宝",@"微信支付"];
    for (int i = 0 ; i < 4; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chooseSubView addSubview:btn];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseHowToPay:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        btn.layer.cornerRadius = 6;
        btn.tag = BTNTAG + i;
        if (i==0) {
            btn.selected = YES;
            btn.backgroundColor = HEXCOLOR(0x4c7fff);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.paywayLastBtn = btn;
            self.choosePayWay = @"";//1,2,3
        }else
        {
            btn.selected = NO;
            btn.backgroundColor = HEXCOLOR(0xfafafa);
        }
        float space = (MAINSCREEN_WIDTH - 78*4 - 30)/3.0;
        float orginX = (15 + (78+space) * i);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(payWay.mas_bottom).mas_offset(12);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(orginX);
            make.width.mas_equalTo(78);
        }];
        [_paymentsBtns addObject:btn];
    }
    
    self.quickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseSubView addSubview:self.quickBtn];
    [self.quickBtn setTitle:@"金额快选" forState:UIControlStateNormal];
    [self.quickBtn addTarget:self action:@selector(fixedLabTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.quickBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.quickBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
//    [self.quickBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateSelected];
    [self.quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chooseSubView).mas_offset(15);
        make.top.mas_equalTo(self.chooseSubView).mas_offset(97);
    }];
    
    self.smallAndBig = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseSubView addSubview:self.smallAndBig];
    [self.smallAndBig setTitle:@"自选金额范围" forState:UIControlStateNormal];
    self.smallAndBig.hidden = YES;
    [self.smallAndBig addTarget:self action:@selector(limiteLabTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.smallAndBig.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.smallAndBig setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.smallAndBig setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateSelected];
    [self.smallAndBig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quickBtn.mas_right).mas_offset(25);
        make.top.mas_equalTo(self.chooseSubView).mas_offset(97);
    }];
    
    self.bottomLine = [[UIView alloc]init];
    [self.chooseSubView addSubview:self.bottomLine];
//    bottomLie.backgroundColor = HEXCOLOR(0x4c7fff);
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.left.right.mas_equalTo(self.quickBtn);
        make.top.mas_equalTo(self.quickBtn.mas_bottom);
    }];
    [self.chooseSubView layoutIfNeeded];
    
    self.bottomLine2 = [[UIView alloc]init];
    [self.chooseSubView addSubview:self.bottomLine2];
    self.bottomLine2.backgroundColor = HEXCOLOR(0xffffff);//HEXCOLOR(0x4c7fff);
    [self.bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.left.right.mas_equalTo(self.smallAndBig);
        make.top.mas_equalTo(self.smallAndBig.mas_bottom);
    }];
    
    self.quickNolim = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseSubView addSubview:self.quickNolim];
    [self.quickNolim setTitle:@"不限" forState:UIControlStateNormal];
    self.quickNolim.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.quickNolim.layer.cornerRadius = 6;
//        paywayLastBtn = btn;
//        choosePayWay = @"";//1,2,3
    self.quickNolim.frame = CGRectMake(15, CGRectGetMaxY(self.bottomLine.frame)+17, 78, 30);
//    self.quickNolim.selected = YES;
    
    [self.quickNolim addTarget:self action:@selector(clickQuickNoLim:) forControlEvents:UIControlEventTouchUpInside];
    [self changeQuickNoLimStatusIsSelected:YES];
    
    
    UITextField* tf = [[UITextField alloc] init];
    tf.delegate = self;
    tf.placeholder = @"输入自定义金额";
    [tf setValue:HEXCOLOR(0x4c7fff) forKeyPath:@"_placeholderLabel.textColor"];
    [tf setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    tf.font = kFontSize(13);
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.layer.cornerRadius = 17.5;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    tf.backgroundColor = HEXCOLOR(0xffffff);
    tf.textColor = HEXCOLOR(0x394368);
    tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.chooseSubView addSubview:tf];
    _tf = tf;
    tf.frame = CGRectMake(CGRectGetMaxX(self.quickNolim.frame)+11, CGRectGetMaxY(self.bottomLine.frame)+17, MAINSCREEN_WIDTH - 2*16-11-78, 35);
    
    self.fixedCount = 0;
    NSArray * numArr = GetUserDefaultWithKey(kFixedAccountsInTransactions);
    self.qucikNumView =[[FixedRectTagView alloc ]initBtnWithFrame:CGRectMake(40, CGRectGetMaxY(tf.frame), MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:
                        numArr];
    kWeakSelf(self);
    self.qucikNumView.clickSectionBlock = ^(UIButton* btn, NSString *btnTit) {
        kStrongSelf(self);
//        NSLog(@"%ld,.....%@",(long)btn.tag,btnTit);
        self.fixedCount = [btnTit intValue];
        self.tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        self.tf.text = @"";
        
        if (self.fixedCount==0) {
//            self.quickNolim.selected = YES;
            [self changeQuickNoLimStatusIsSelected:YES];
        }else{
//            self.quickNolim.selected = NO;
            [self changeQuickNoLimStatusIsSelected:NO];
        }
        
        self.inputTfString = self.fixedCount ==0?@"":[NSString stringWithFormat:@"%ld",self.fixedCount];
        NSLog(@"input.........%@",self.inputTfString);
        
    };
    
    [self.chooseSubView addSubview:self.qucikNumView];
    UIView* tagView0 = [FixedRectTagView creatBtnWithFrame:CGRectMake(40,CGRectGetMaxY(tf.frame), MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:numArr];
    [self.chooseSubView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.height.mas_equalTo(CGRectGetMaxY(tagView0.frame)+100);
    }];
    
    self.slider = [[SDRangeSliderView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.bottomLine.frame)+tagView0.size.height/2, MAINSCREEN_WIDTH - 32, 3)];
    /*
     *打开任意注释观察变化(Open comment to observe the change)
     */
    //    slider.minimumSize = 10;//最小刻度
    
    //    [slider usingValueUnequal];//游标接触时取值间隔一个刻度;
    
    self.slider.offsetOfAdjustLineStart = 8;//look at viewHierarcy
    self.slider.offsetOfAdjustLineEnd = 8;//look at viewHierarcy
    
    self.slider.minValue = 0;
    self.slider.maxValue = 3000;
    
    self.choosePayMin = 0;
    self.choosePayMax = 2000;
    
    self.slider.leftValue = 0;
    self.slider.rightValue = 2000;
    
    //        [slider update];
    
    [self.slider customUIUsingBlock:^(UIButton *leftCursor, UIButton *rightCursor) {
        [leftCursor setImage:[UIImage imageNamed:@"icon_slider"] forState:UIControlStateNormal];
        [rightCursor setImage:[UIImage imageNamed:@"icon_slider"] forState:UIControlStateNormal];
    }];
    [self.chooseSubView addSubview:self.slider];
    
    self.sliderMax = [UILabel new];
    self.sliderMax.text = @"¥2000";
    [self.chooseSubView addSubview:self.sliderMax];
    self.sliderMax.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.sliderMax.textColor = HEXCOLOR(0x4c7fff);
    [self.sliderMax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.smallAndBig.mas_bottom).mas_offset(13);
    }];
    self.sliderMin = [UILabel new];
    self.sliderMin.text = @"¥0";
    [self.chooseSubView addSubview:self.sliderMin];
    self.sliderMin.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.sliderMin.textColor = HEXCOLOR(0x4c7fff);
    [self.sliderMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.smallAndBig.mas_bottom).mas_offset(13);
    }];
    
    [self.slider eventValueDidChanged:^(double left, double right) {
        self.sliderMin.text = [NSString stringWithFormat:@"¥%d",[[NSNumber numberWithDouble:left]intValue]];
        self.sliderMax.text = [NSString stringWithFormat:@"¥%d",[[NSNumber numberWithDouble:right]intValue]];
        
        self.choosePayMin = [[NSNumber numberWithDouble:left]intValue];
        self.choosePayMax = [[NSNumber numberWithDouble:right]intValue];
        
    }];
    
    [self fixedLabTap];
    
    UIButton * confirmBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseSubView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:HEXCOLOR(0x4c7fff)];
    confirmBtn.layer.cornerRadius = 6.0;
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.chooseSubView);
        make.bottom.mas_equalTo(self.chooseSubView).mas_offset(-20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(121);
    }];
    
    [self layoutIfNeeded];
    self.alphaBlackView = [[UIView alloc]init];
    UIView* kV = [[[UIApplication sharedApplication] delegate] window];
    [kV addSubview:self.alphaBlackView];
    [self.alphaBlackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    self.alphaBlackView.hidden = YES;
    self.alphaBlackView.backgroundColor = [UIColor blackColor];
    self.alphaBlackView.alpha = 0.8;
    float orginY = YBSystemTool.isIphoneX? 517 : 497;
    [self.alphaBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MAINSCREEN_WIDTH);
        make.top.mas_equalTo(orginY);//买单 选框 黑色背景覆盖高度有问题
        make.height.mas_equalTo(MAINSCREEN_HEIGHT - orginY);
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tf) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
//        if ([string isEqualToString:@"0"]&&range.location== 0) {
//
//            return NO;//第一位不能为0
//        }
        if (range.location>= 9)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(void)textField1TextChange:(UITextField *)textField{
    if ([_tf isEqual: textField]) {
        if (![NSString isEmpty:textField.text]) {
            int i = [textField.text intValue];
            if (i>0) {
                self.tf.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            }else{
                self.tf.layer.borderColor = [UIColor redColor].CGColor;
                [YKToastView showToastText:@"自定义金额不能0"];
            }
            self.inputTfString = [NSString stringWithFormat:@"%d",i];
            textField.text = self.inputTfString;
        }else{
           self.inputTfString = @"";
        }
    
        
        if (![NSString isEmpty:self.inputTfString]) {//self.inputTfString
            [self.qucikNumView clearSelecedBtn];
            self.fixedCount = 0;
//            self.quickNolim.selected = NO;
            [self changeQuickNoLimStatusIsSelected:NO];
        }else{
            if (self.fixedCount==0) {
//                self.quickNolim.selected = YES;
                [self changeQuickNoLimStatusIsSelected:YES];
            }
        }
    }
}

- (void)fixedLabTap{
    _transactionAmountType = TransactionAmountTypeFixed;
    self.slider.hidden = YES;
    self.sliderMin.hidden = YES;
    self.sliderMax.hidden = YES;
    self.bottomLine2.hidden = YES;
    self.bottomLine.hidden =  NO;
    self.qucikNumView.hidden = NO;
    self.smallAndBig.selected = NO;
    self.quickBtn.selected = YES;
}

- (void)limiteLabTap{
    _transactionAmountType = TransactionAmountTypeLimit;
    self.slider.hidden = NO;
    self.sliderMin.hidden = NO;
    self.sliderMax.hidden = NO;
    self.bottomLine2.hidden = NO;
    self.bottomLine.hidden = YES;
    self.qucikNumView.hidden = YES;
    self.smallAndBig.selected = YES;
    self.quickBtn.selected = NO;
}
- (void)disMissView{
    self.chooseSubView.hidden = YES;
    self.alphaBlackView.hidden = YES;
    self.payMethodView.hidden = NO;
//    [self.titleChoose setImage:[UIImage imageNamed:@"btnPop"] forState:UIControlStateNormal];
    [self richImageInTitleChooseBtns];
}

- (void)clickConfirm{
    NSLog(@"%@  ",self.choosePayWay);
    _fliterArr = [NSArray array];
    
    if (_transactionAmountType == TransactionAmountTypeFixed) {
//        if (self.fixedCount == 0) {
//            [YKToastView showToastText:@"请选择固定的金额"];
//            return;
//        }
        
        if ([self.inputTfString isEqualToString:@"0"]) {

            [YKToastView showToastText:@"自定义金额不能0"];
            return;
        }
        
        _fliterArr = @[self.choosePayWay,@(_transactionAmountType),![NSString isEmpty:self.inputTfString]?self.inputTfString:@""];
        
        [self richElementsInFliterBtns:@[self.choosePayWay,self.inputTfString]];
        //[NSString stringWithFormat:@"%ld",(long)self.fixedCount]
    }else{
        
        _fliterArr = @[self.choosePayWay,@(_transactionAmountType),[NSString stringWithFormat:@"%ld",(long)self.choosePayMin],[NSString stringWithFormat:@"%ld",(long)self.choosePayMax]];
    }
    [self.delegate transactionView:self requestListWithPage:1 WithFilterArr:self.fliterArr];
    
    
    self.chooseSubView.hidden = YES;
    self.alphaBlackView.hidden = YES;
    self.payMethodView.hidden = NO;
    
//    [self.titleChoose setImage:[UIImage imageNamed:@"btnPop"]
//                 forState:UIControlStateNormal];
    [self richImageInTitleChooseBtns];
}
- (void)chooseHowToPay:(UIButton *)sender{
    if(self.paywayLastBtn != sender)
    {
        sender.backgroundColor = HEXCOLOR(0x4c7fff);
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.paywayLastBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        self.paywayLastBtn.backgroundColor =HEXCOLOR(0xfafafa);
        self.paywayLastBtn = sender;
    }
    if (sender.tag == BTNTAG) {
        self.choosePayWay = @"";//1,2,3
    }else if(sender.tag == BTNTAG + 1){
        self.choosePayWay = @"3";
    }else if(sender.tag == BTNTAG + 2){
        self.choosePayWay = @"2";
    }else {
        self.choosePayWay = @"1";
    }
}
#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page
                            WithSum:(NSInteger)sum{
    self.networkErrorView.hidden = YES;
    self.serviceErrorView.hidden = YES;
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
        [self.tableView reloadData];
        return;
    }
    if (array.count > 0) {
        self.dataEmptyView.hidden = YES;
        [self.dataSource addObjectsFromArray:array];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    
}

- (void)requestListServiceErrorFailed {
    self.currentPage = 0;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    //    [self crateChooseSubView];
    self.networkErrorView.hidden = YES;
    self.serviceErrorView.hidden = NO;
    self.dataEmptyView.hidden = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)requestListNetworkErrorFailed {
    self.currentPage = 0;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
//    [self crateChooseSubView];
    self.networkErrorView.hidden = NO;
    self.serviceErrorView.hidden = YES;
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
    TransactionCell *cell = [TransactionCell cellWith:tableView];
    TransactionData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    [cell richElementsInCellWithModel:itemData];
    [cell actionBlock:^(id data) {
        if (self.block) {
             self.block(@(EnumActionTag0),data);
        }
    }];
    return cell;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransactionData* itemData = ((_dataSource[indexPath.section])[indexPath.row]);
    
    if ([itemData isBuyAvailable]) {
        if (self.block) {
            self.block(@(EnumActionTag1),itemData);
        }
    }else{
        if (self.block) {
            self.block(@(EnumActionTag2),itemData);
        }
    }
    
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TransactionCell cellHeightWithModel];
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
            [self.delegate transactionView:self requestListWithPage:self.currentPage WithFilterArr:self.fliterArr];
        }
        footer:^{
            kStrongSelf(self);
            ++self.currentPage;
            [self.delegate transactionView:self requestListWithPage:self.currentPage WithFilterArr:self.fliterArr];
        }
    ];
    }
    return _tableView;
}

-(void)addButtonClicked{
    if (self.block) {
        self.block(@(EnumActionTag3), @"");
    }
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
