//
//  SubmitOrderPopView.m
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "SubmitOrderPopView.h"
#define XHHTuanNumViewHight 283

@interface SubmitOrderPopView ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    
    double duration;
    
    UILabel *notEnoughTipLab;
    
    UILabel *quotaLab;
    
    UILabel *remainingLab;
    
    UIButton *buyBtn;
    
    UILabel *valueLeftLab;
    
    UILabel *valueRightLab;
    
    UILabel *tipLab;
}

@property (nonatomic, copy) ActionBlock block;

@property (nonatomic, strong) UIView *contentView;//内容物
@property (nonatomic, assign) CGFloat contentViewHeight;
@property (nonatomic, assign) TransactionAmountType transactionAmountType;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, copy)   ActionBlock noeBuyBubblock;
@property (nonatomic,strong) NSArray * dataSource;

@property (nonatomic,strong) NSMutableArray *titleBtnMutArr;

@property (nonatomic,strong) NSMutableArray *picBtnMutArr;

@property (nonatomic,strong) NSMutableArray *btnMutArr;

@property (nonatomic,assign) BOOL keyboardIsVisible;

@end

@implementation SubmitOrderPopView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(instancetype)initWithPaymentWay:(NSString *)paymentWay
                       QuotaStyle:(TransactionAmountType)quotaStyle{
    
    if (self = [super init]) {

        self.transactionAmountType = quotaStyle;
        
        [self setupData:paymentWay];
        
        switch (quotaStyle) {
            case TransactionAmountTypeFixed://固定额度
                
                [self setupFixedUI];
                
                break;
            case TransactionAmountTypeLimit://限定额度
                
                 [self setupLimitUI];
                
                break;
                
            default:
                break;
        }
        [IQKeyboardManager sharedManager].enable = NO; // 控制整个功能是否启用
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(keyboardWillShow:)
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(keyboardWillHide:)
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    }
    
    return self;
}

-(void)setupFixedUI{
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0
                                           green:0
                                            blue:0
                                           alpha:0.8];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(disMissView)];
    
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    
    _contentViewHeight = XHHTuanNumViewHight + [YBFrameTool tabBarHeight];
    //开始装载内容物
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeight, MAINSCREEN_WIDTH, _contentViewHeight)];
        
        _contentView.userInteractionEnabled = YES;
        
        _contentView.backgroundColor = kWhiteColor;
        
        [self addSubview:_contentView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(5, 5)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = _contentView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        _contentView.layer.mask = maskLayer;
        
        UILabel *titleLab1 = UILabel.new;
        
        [titleLab1 sizeToFit];
        
        titleLab1.font = kFontSize(17);
        
        titleLab1.textColor = HEXCOLOR(0x232630);
        
        titleLab1.text = @"您的购买金额";
        
        titleLab1.textAlignment = NSTextAlignmentLeft;
        
        [_contentView addSubview:titleLab1];
        
        [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(47);
            
            make.top.equalTo(self.contentView);
            
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        //tip:固额～
        quotaLab = UILabel.new;
        
        [quotaLab sizeToFit];
        
        quotaLab.textColor = RGBCOLOR(91, 91, 91);
        
        quotaLab.textAlignment = NSTextAlignmentLeft;
        
        quotaLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                        size:12];
        
        [self.contentView addSubview:quotaLab];
        
        [quotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(titleLab1);
            
            make.left.equalTo(titleLab1.mas_right);
            
            make.right.equalTo(self.contentView).offset(-30);
        }];

        UILabel *lab = UILabel.new;
        
        [NSObject cornerCutToCircleWithView:lab
                            AndCornerRadius:4];
        
        [NSObject colourToLayerOfView:lab
                           WithColour:RGBCOLOR(221, 221, 221)
                       AndBorderWidth:1];
        
        [self.contentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(titleLab1);
            
            make.top.equalTo(titleLab1.mas_bottom).offset(2);
            
            make.height.mas_equalTo(40);
            
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        //中间的装饰
        UIButton *btn = UIButton.new;
        
        [btn setBackgroundImage:kIMG(@"Link")
                       forState:UIControlStateNormal];
        
        [lab addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.center.equalTo(lab);
            
            make.size.mas_equalTo(CGSizeMake(22, 9));
        }];
        
        //CNY
        UILabel *CNYlab = UILabel.new;
        
        CNYlab.textAlignment = NSTextAlignmentLeft;
        
        CNYlab.text = @"CNY";
        
        [CNYlab sizeToFit];
        
        [lab addSubview:CNYlab];
        
        [CNYlab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(lab);
            
            make.right.equalTo(btn.mas_left).offset(-10);
        }];
        
        // |
        UILabel *segmentationLeft = UILabel.new;
        
        segmentationLeft.backgroundColor = RGBCOLOR(151, 151, 151);
        
        [lab addSubview:segmentationLeft];
        
        [segmentationLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(CNYlab.mas_left).offset(-10);
            
            make.top.bottom.equalTo(btn);
            
            make.width.mas_equalTo(@1);
        }];
        
        //左值
        valueLeftLab = UILabel.new;
        
        [valueLeftLab sizeToFit];
        
        valueLeftLab.textAlignment = NSTextAlignmentRight;
        
        [lab addSubview:valueLeftLab];
        
        [valueLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(CNYlab);
            
            make.left.equalTo(lab.mas_left).offset(10);
            
            make.right.equalTo(segmentationLeft.mas_left).offset(-10);
        }];
        
        //右值
        valueRightLab = UILabel.new;
        
        [valueRightLab sizeToFit];
        
        valueRightLab.textAlignment = NSTextAlignmentLeft;
        
        [lab addSubview:valueRightLab];
        
        [valueRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(btn.mas_right).offset(10);
            
            make.top.bottom.equalTo(lab);
        }];
        
        // |
        UILabel *segmentationRight = UILabel.new;
        
        segmentationRight.backgroundColor = RGBCOLOR(151, 151, 151);
        
        [lab addSubview:segmentationRight];
        
        [segmentationRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self->valueRightLab.mas_right).offset(10);
            
            make.top.bottom.equalTo(btn);
            
            make.width.mas_equalTo(@1);
        }];
        
        //BUB
        UILabel *BUBlab = UILabel.new;
        
        BUBlab.textAlignment = NSTextAlignmentCenter;
        
        [BUBlab sizeToFit];
        
        BUBlab.text = @"BUB";
        
        [lab addSubview:BUBlab];
        
        [BUBlab mas_makeConstraints:^(MASConstraintMaker *make) {

//            make.right.equalTo(lab.mas_right);
            make.top.bottom.equalTo(lab);

            make.left.equalTo(segmentationRight.mas_right).offset(10);
        }];
        
        //加一个提示框
        tipLab = UILabel.new;
        
        tipLab.textColor = kRedColor;
        
        tipLab.numberOfLines = 0;
        
        [tipLab sizeToFit];
        
        tipLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                      size:9];
        
        [_contentView addSubview:tipLab];
        
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(lab.mas_left);
            
            make.right.equalTo(lab.mas_right);
            
            make.top.equalTo(lab.mas_bottom).offset(4);
            
//            make.bottom.equalTo(titleLab2.mas_top);
        }];

    
        //标题 - 选择您的支付方式
        UILabel *titleLab2 = UILabel.new;
        
        titleLab2.font = kFontSize(17);
        
        titleLab2.textColor = HEXCOLOR(0x232630);
        
        titleLab2.text = @"选择您的支付方式";
        
        titleLab2.textAlignment = NSTextAlignmentLeft;
        
        [_contentView addSubview:titleLab2];
        
        [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(titleLab1);
            
            make.size.mas_equalTo(CGSizeMake(190, 47));
            
            make.top.equalTo(self->tipLab.mas_bottom).offset(0);
        }];
        

        //按钮 - 微信支付1
        //按钮 - 支付宝2
        //按钮 - 银行卡3
        for (int y = 0; y < self.titleBtnMutArr.count; y++) {
            
            UIButton *btn = UIButton.new;
            
            [self.btnMutArr addObject:btn];
            
            [btn addTarget:self
                    action:@selector(paymentStyleClickEvent:)
          forControlEvents:UIControlEventTouchUpInside];
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                  size:12];
            
            [NSObject cornerCutToCircleWithView:btn
                                AndCornerRadius:4];
            
            [btn setTitle:(NSString *)self.titleBtnMutArr[y]
                 forState:UIControlStateNormal];
            
            if (y == 0) {//默认提示 第一个优先
                
                [self btnValue:btn];
                
            }else{
                
                [NSObject colourToLayerOfView:btn
                                   WithColour:RGBCOLOR(245, 245, 245)
                               AndBorderWidth:1];
            }
            
            [btn setTitleColor:kBlackColor
                      forState:UIControlStateNormal];
            
            [btn setImage:kIMG((NSString *)self.picBtnMutArr[y])
                 forState:UIControlStateNormal];
            
            [self.contentView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(titleLab2.mas_bottom).offset(2);
                
                make.size.mas_equalTo(CGSizeMake(86, 28));
                
                make.left.equalTo(self.contentView).offset(20 + y * (86 + 38));
            }];
        }
        //按钮 - 取消
        UIButton *cancelBtn = UIButton.new;
        
        [cancelBtn setTitle:@"取消"
                   forState:UIControlStateNormal];
        
        [cancelBtn setTitleColor:RGBCOLOR(76, 127, 255)
                        forState:UIControlStateNormal];
        
        [NSObject cornerCutToCircleWithView:cancelBtn
                            AndCornerRadius:4];
        
        [NSObject colourToLayerOfView:cancelBtn
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        [cancelBtn addTarget:self
                      action:@selector(cancelBtnClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [NSObject cornerCutToCircleWithView:cancelBtn
                            AndCornerRadius:6];
        
        [self.contentView addSubview:cancelBtn];
        
        UIButton *someBtn = [self.btnMutArr lastObject];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(140, 40));
            
            make.left.equalTo(self.contentView).offset(33);
            
            make.top.equalTo(someBtn.mas_bottom).offset(33);
        }];
        
        //按钮 - 下单购买
        buyBtn = UIButton.new;
        
        [buyBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
        
        [buyBtn setTitle:@"下单购买"
                forState:UIControlStateNormal];
        
        [NSObject cornerCutToCircleWithView:buyBtn
                            AndCornerRadius:6];
        
        [buyBtn addTarget:self
                   action:@selector(buyBtnClickEvent:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:buyBtn];
        
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(140, 40));
            
            make.right.equalTo(self.contentView).offset(-33);
            
            make.centerY.equalTo(cancelBtn);
        }];
        
        //        WS(weakSelf);
        //        [_contentView bottomSingleButtonInSuperView:_contentView
        //                                  WithButtionTitles:@"确定"
        //                                    leftButtonEvent:^(id data) {
        ////            [weakSelf postAdsAndRuleButtonClickItem];
        //        }];
    }
}

-(void)setupData:(NSString *)paymentWay{
    
    //1、微信 ;2、支付宝 ;3、银行卡
    if ([paymentWay containsString:@"1"]||
        [paymentWay containsString:@"2"]||
        [paymentWay containsString:@"3"]) {
        
        if ([paymentWay containsString:@"1"]&&
            [paymentWay containsString:@"2"]&&
            [paymentWay containsString:@"3"]) {//支付宝、微信、银行卡
            
            [self.titleBtnMutArr addObject:@"微信支付"];
            [self.picBtnMutArr addObject:@"icon_cir_weixin"];//微信图标
            
            [self.titleBtnMutArr addObject:@"支付宝"];
            [self.picBtnMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
            [self.titleBtnMutArr addObject:@"银行卡"];
            [self.picBtnMutArr addObject:@"YINGHANGKAXIR"];//银行卡
            
        }else if ([paymentWay containsString:@"1"]&&
                  [paymentWay containsString:@"2"]){//微信、支付宝
            
            [self.titleBtnMutArr addObject:@"微信支付"];
            [self.picBtnMutArr addObject:@"icon_cir_weixin"];//微信图标
            
            [self.titleBtnMutArr addObject:@"支付宝"];
            [self.picBtnMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
        }else if ([paymentWay containsString:@"1"]&&
                  [paymentWay containsString:@"3"]){//微信、银行卡
            
            [self.titleBtnMutArr addObject:@"微信支付"];
            [self.picBtnMutArr addObject:@"icon_cir_weixin"];//微信图标
            
            [self.titleBtnMutArr addObject:@"银行卡"];
            [self.picBtnMutArr addObject:@"YINGHANGKAXIR"];//银行卡
        }else if ([paymentWay containsString:@"2"]&&
                  [paymentWay containsString:@"3"]){//支付宝、银行卡
            
            [self.titleBtnMutArr addObject:@"支付宝"];
            [self.picBtnMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
            [self.titleBtnMutArr addObject:@"银行卡"];
            [self.picBtnMutArr addObject:@"YINGHANGKAXIR"];//银行卡
        }else if ([paymentWay containsString:@"1"]){//微信
            
            [self.titleBtnMutArr addObject:@"微信支付"];
            [self.picBtnMutArr addObject:@"icon_cir_weixin"];//微信图标
            
        }else if ([paymentWay containsString:@"2"]){//支付宝
            
            [self.titleBtnMutArr addObject:@"支付宝"];
            [self.picBtnMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
        }else if ([paymentWay containsString:@"3"]){//银行卡
            
            [self.titleBtnMutArr addObject:@"银行卡"];
            [self.picBtnMutArr addObject:@"YINGHANGKAXIR"];//银行卡
        }
    }
}

-(void)setupLimitUI{
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0
                                           green:0
                                            blue:0
                                           alpha:0.8];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(disMissView)];
    
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    
    _contentViewHeight = (248 + 60) * SCALING_RATIO;
    //开始装载内容物
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeight, MAINSCREEN_WIDTH, _contentViewHeight)];

        _contentView.userInteractionEnabled = YES;
        
        _contentView.backgroundColor = kWhiteColor;
        
        [self addSubview:_contentView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(5, 5)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = _contentView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        _contentView.layer.mask = maskLayer;
        
        UILabel *titleLab1 = UILabel.new;
        
        titleLab1.font = kFontSize(17);
        
        titleLab1.textColor = HEXCOLOR(0x232630);
        
        titleLab1.text = @"填写您的购买金额";
        
        titleLab1.textAlignment = NSTextAlignmentLeft;

        [_contentView addSubview:titleLab1];
        
        [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(190, 47));
            
            make.top.equalTo(self.contentView);
            
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        //tip:限额～
        quotaLab = UILabel.new;
        
        quotaLab.hidden = YES;
        
        quotaLab.textColor = RGBCOLOR(208, 2, 27);
        
        quotaLab.textAlignment = NSTextAlignmentLeft;
        
        quotaLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                        size:12];
        
        [self.contentView addSubview:quotaLab];
        
        [quotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(titleLab1);
            
            make.left.equalTo(titleLab1.mas_right);
            
            make.right.equalTo(self.contentView).offset(-30);
        }];
        
        _line1 = [[UIImageView alloc]init];
        
        [self.contentView addSubview:_line1];
        
        _line1.backgroundColor = kClearColor;
        
        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        //左边的输入框
        UIView *bg1 = UIView.new;
        bg1.backgroundColor = RGBCOLOR(245, 245, 245);
        [self.contentView addSubview:bg1];
        [bg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line1.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 3 - (MAINSCREEN_WIDTH / 2.5 - MAINSCREEN_WIDTH / 3)  , 40));
        }];
        self.leftTextField = UITextField.new;
        
        self.leftTextField.font = kFontMediumSize(15);
        
        self.leftTextField.backgroundColor = RGBCOLOR(245, 245, 245);
        
        self.leftTextField.keyboardType = UIKeyboardTypeNumberPad;

        self.leftTextField.delegate = self;
        
        self.leftTextField.placeholder = @"购买金额";
        
        [bg1 addSubview:self.leftTextField];
        
        [self.leftTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.centerY.equalTo(bg1);
            make.width.mas_equalTo(70);
        }];
        
        //左边的币类型选择按钮
        UIButton *leftBtn = UIButton.new;
        
        [leftBtn setTitle:@"CNY"
                 forState:UIControlStateNormal];
        
        [leftBtn setTitleColor:kBlackColor
                      forState:UIControlStateNormal];
        
        leftBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        
        
        UIView *line1S = [UIView new];
        line1S.backgroundColor = HEXCOLOR(0x979797);
        [leftBtn addSubview:line1S];
        [self.contentView addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(bg1);
            
            make.left.equalTo(bg1.mas_right);
            
            make.width.mas_equalTo((MAINSCREEN_WIDTH / 2.5 - MAINSCREEN_WIDTH / 3) * 2);
        }];
        
        [line1S mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg1).offset(12);
            make.left.equalTo(leftBtn.mas_left).offset(-6);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(1);
        }];
        
        //右边的币类型选择按钮
        UIButton *rightBtn = UIButton.new;
        
        [rightBtn setTitle:@"BUB"
                  forState:UIControlStateNormal];
        
        rightBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        
        [rightBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        
        [self.contentView addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(bg1);
            
            make.right.equalTo(self.contentView).offset(-15);
            
            make.width.mas_equalTo((MAINSCREEN_WIDTH / 2.5 - MAINSCREEN_WIDTH / 3) * 2);
        }];
        
        //右边的输入框
        UIView *bg2 = UIView.new;
        bg2.backgroundColor = RGBCOLOR(245, 245, 245);
        [self.contentView addSubview:bg2];
        [bg2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line1.mas_bottom).offset(10);
            make.right.equalTo(rightBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 3 - (MAINSCREEN_WIDTH / 2.5 - MAINSCREEN_WIDTH / 3), 40));
        }];
        self.rightTextField = UITextField.new;
        
        self.rightTextField.font = kFontMediumSize(15);
        
        self.rightTextField.backgroundColor = RGBCOLOR(245, 245, 245);
        
        self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.rightTextField.delegate = self;
        
        self.rightTextField.placeholder = @"折合BUB";
        
        UIView *line2S = [UIView new];
        line2S.backgroundColor = HEXCOLOR(0x979797);
        [self.rightTextField addSubview:line2S];
        
        
        [bg2 addSubview:self.rightTextField];
        
        [self.rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@10);
            make.centerY.equalTo(bg2);
            make.width.mas_equalTo(70);
        }];
        
        [line2S mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bg1).offset(12);
            make.left.equalTo(self.rightTextField.mas_right).offset(13);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(1);
        }];
        
        //中间的装饰
        UIButton *btn = UIButton.new;
        
        [btn setBackgroundImage:kIMG(@"Link")
                       forState:UIControlStateNormal];
        
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(bg1);
            
            make.centerX.equalTo(self.contentView);
            
            make.size.mas_equalTo(CGSizeMake(22, 9));
        }];
        
        //标题 - 选择您的支付方式
        UILabel *titleLab2 = UILabel.new;
        
        titleLab2.font = kFontSize(17);
        
        titleLab2.textColor = HEXCOLOR(0x232630);
        
        titleLab2.text = @"选择您的支付方式";
        
        titleLab2.textAlignment = NSTextAlignmentLeft;
        
        [_contentView addSubview:titleLab2];
        
        [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(titleLab1);
            
            make.size.mas_equalTo(CGSizeMake(190, 47));
            
            make.top.equalTo(bg1.mas_bottom).offset(13);
        }];
        
        //剩余总数
        remainingLab = UILabel.new;
        
        remainingLab.textColor = RGBCOLOR(154, 154, 154);
        
        remainingLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                            size:12];
        
        [self.contentView addSubview:remainingLab];
        
        [remainingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(bg1);
            
            make.top.equalTo(bg1.mas_bottom).offset(5);
            
            make.bottom.equalTo(titleLab2.mas_top);
        }];
        
        //剩余库存不够
        notEnoughTipLab = UILabel.new;
        
        notEnoughTipLab.hidden = YES;
        
        notEnoughTipLab.textAlignment = NSTextAlignmentRight;
        
        notEnoughTipLab.textColor = RGBCOLOR(208, 2, 27);
        
        notEnoughTipLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                               size:12];
        
        [self.contentView addSubview:notEnoughTipLab];
        
        [notEnoughTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(bg2);
            
            make.top.equalTo(bg2.mas_bottom);
        }];
        
        //按钮 - 微信支付1
        //按钮 - 支付宝2
        //按钮 - 银行卡3
        for (int y = 0; y < self.titleBtnMutArr.count; y++) {
            
            UIButton *btn = UIButton.new;
            
            [self.btnMutArr addObject:btn];
            
            [btn addTarget:self
                    action:@selector(paymentStyleClickEvent:)
          forControlEvents:UIControlEventTouchUpInside];
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                  size:12];
            
            [NSObject cornerCutToCircleWithView:btn
                                AndCornerRadius:4];
            
            [btn setTitle:(NSString *)self.titleBtnMutArr[y]
                 forState:UIControlStateNormal];
     
            if (y == 0) {//默认提示 第一个优先
                
                [self btnValue:btn];
                
            }else{
                
                [NSObject colourToLayerOfView:btn
                                   WithColour:RGBCOLOR(245, 245, 245)
                               AndBorderWidth:1];
            }
            
            [btn setTitleColor:kBlackColor
                      forState:UIControlStateNormal];
            
            [btn setImage:kIMG((NSString *)self.picBtnMutArr[y])
                 forState:UIControlStateNormal];
            
            [self.contentView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(titleLab2.mas_bottom).offset(2);
                
                make.size.mas_equalTo(CGSizeMake(86, 28));
                
                make.left.equalTo(self.contentView).offset(20 + y * (86 + 38));
            }];
        }
        //按钮 - 取消
        UIButton *cancelBtn = UIButton.new;
        
        [cancelBtn setTitle:@"取消"
                   forState:UIControlStateNormal];
        
        [cancelBtn setTitleColor:RGBCOLOR(76, 127, 255)
                        forState:UIControlStateNormal];
        
        [NSObject cornerCutToCircleWithView:cancelBtn
                            AndCornerRadius:4];
        
        [NSObject colourToLayerOfView:cancelBtn
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        [cancelBtn addTarget:self
                      action:@selector(cancelBtnClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [NSObject cornerCutToCircleWithView:cancelBtn
                            AndCornerRadius:6];
        
        [self.contentView addSubview:cancelBtn];
        
        UIButton *someBtn = [self.btnMutArr lastObject];

        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(140, 40));

            make.left.equalTo(self.contentView).offset(33);

            make.top.equalTo(someBtn.mas_bottom).offset(33);
        }];

        //按钮 - 下单购买
        buyBtn = UIButton.new;
        
        buyBtn.userInteractionEnabled = NO;//一开始不能点

        [buyBtn setBackgroundColor:RGBCOLOR(205, 205, 205)];
        
        [buyBtn setTitle:@"下单购买"
                forState:UIControlStateNormal];

        [NSObject cornerCutToCircleWithView:buyBtn
                            AndCornerRadius:6];

        [buyBtn addTarget:self
                   action:@selector(buyBtnClickEvent:)
         forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:buyBtn];

        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.size.mas_equalTo(CGSizeMake(140, 40));

            make.right.equalTo(self.contentView).offset(-33);

            make.centerY.equalTo(cancelBtn);
        }];

//        WS(weakSelf);
//        [_contentView bottomSingleButtonInSuperView:_contentView
//                                  WithButtionTitles:@"确定"
//                                    leftButtonEvent:^(id data) {
////            [weakSelf postAdsAndRuleButtonClickItem];
//        }];
    }
}

//超额警告⚠️
-(void)showWarning:(MoreOrLess)moreOrLess{
    
    notEnoughTipLab.hidden = NO;
    
    quotaLab.hidden = NO;
    
    [NSObject colourToLayerOfView:self.leftTextField
                       WithColour:RGBCOLOR(208, 2, 27)
                   AndBorderWidth:1];
    
    [NSObject colourToLayerOfView:self.rightTextField
                       WithColour:RGBCOLOR(208, 2, 27)
                   AndBorderWidth:1];
    
    switch (moreOrLess) {
        case MoreOrLessOnce_more:{//大于单次购买上限
            
            notEnoughTipLab.text = @"大于单次购买上限!";
        }
            break;
        case MoreOrLessOnce_less:{//小于单次购买下限
            
            notEnoughTipLab.text = @"低于最低交易限度!";
        }
            break;
        case MoreOrLessRemain:{//大于实际库存
            
            notEnoughTipLab.text = @"剩余库存不够!";
        }
            break;
            
        default:
            break;
    }
}

-(void)disappearWarning{
    
    notEnoughTipLab.hidden = YES;
    
    quotaLab.hidden = YES;
    
    [NSObject colourToLayerOfView:self.leftTextField
                       WithColour:kClearColor
                   AndBorderWidth:1];
    
    [NSObject colourToLayerOfView:self.rightTextField
                       WithColour:kClearColor
                   AndBorderWidth:1];
}

#pragma mark - 支付方式按钮 点击事件
-(void)paymentStyleClickEvent:(UIButton *)sender{

    //全部色归0
    for (int r = 0; r < self.btnMutArr.count; r++) {
        
        UIButton *btn = self.btnMutArr[r];
        
        [NSObject colourToLayerOfView:btn
                           WithColour:RGBCOLOR(245, 245, 245)
                       AndBorderWidth:1];
    }
    
//    NSLog(@"%d",sender.tag);
    
    [self btnValue:sender];
    
//    if ([btn.titleLabel.text isEqualToString:@"微信支付"]) {
//
//        [NSObject colourToLayerOfView:sender
//                           WithColour:RGBCOLOR(76, 127, 255)
//                       AndBorderWidth:0.5f];
//
//        self.paymentStyle = PaywayTypeWX;
//    }else if ([btn.titleLabel.text isEqualToString:@"支付宝"]){
//
//        [NSObject colourToLayerOfView:sender
//                           WithColour:RGBCOLOR(76, 127, 255)
//                       AndBorderWidth:0.5f];
//
//        self.paymentStyle = PaywayTypeZFB;
//    }else if ([btn.titleLabel.text isEqualToString:@"银行卡"]){
//
//        [NSObject colourToLayerOfView:sender
//                           WithColour:RGBCOLOR(76, 127, 255)
//                       AndBorderWidth:0.5f];
//
//        self.paymentStyle = PaywayTypeCard;
//    }
}

-(void)btnValue:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"微信支付"]) {
        
        [NSObject colourToLayerOfView:sender
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        self.paymentStyle = PaywayTypeWX;
    }else if ([sender.titleLabel.text isEqualToString:@"支付宝"]){
        
        [NSObject colourToLayerOfView:sender
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        self.paymentStyle = PaywayTypeZFB;
    }else if ([sender.titleLabel.text isEqualToString:@"银行卡"]){
        
        [NSObject colourToLayerOfView:sender
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        self.paymentStyle = PaywayTypeCard;
    }
}

#pragma mark - buyBtn 点击事件
-(void)buyBtnClickEvent:(UIButton *)sender{
    
//    [self disMissView];
    if (self.MyBlock) {
        self.MyBlock();
    }
    if (self.noeBuyBubblock) {
        self.noeBuyBubblock(@(self.paymentStyle));
    }
}

#pragma mark - cancelBtn 点击事件
-(void)cancelBtnClickEvent:(UIButton *)sender{
    
    [self disMissView];
}

- (void)actionBlock:(ActionBlock)block{
    
    self.block = block;
}

- (void)showInApplicationKeyWindow{
    
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    
    if (!view) return;
    self.keyboardIsVisible = NO;
    [view addSubview:self];
    
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, _contentViewHeight)];
    
    kWeakSelf(self);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
        kStrongSelf(self);
                         
        self.alpha = 1.0;
        
        [self.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - self.contentViewHeight),MAINSCREEN_WIDTH,self.contentViewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    if (self.keyboardIsVisible) {
        [self.leftTextField resignFirstResponder];
        [self.rightTextField resignFirstResponder];
    }else{
        [self hideKeyboard];
    }
}

//询问委托人是否应该更改指定的文本
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    [self disappearWarning];
    
//    NSLog(@"%@",textField.text);
//
//    NSLog(@"%@",string);
    
    //这里的textField.text 是没有在屏幕上显示的value
    if (![NSString isEmpty:string]) {//有输入值,可以点击
        
        buyBtn.userInteractionEnabled = YES;//可以点
        
        [buyBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    }
    
    if ([NSString isEmpty:string] &&
        textField.text.length == 1) {//执行删除操作,返回string为空串，textField.text还有最后y一个字符，还没赋值在屏幕上，实际上内存已经接受还正在处理之中
        
        buyBtn.userInteractionEnabled = NO;//一开始不能点
        
        [buyBtn setBackgroundColor:RGBCOLOR(205, 205, 205)];

    }
    
    if ([NSString isEmpty:string]) {//返回空串意味着正在进行删除操作

        if ([textField isEqual:self.leftTextField]) {
            
            NSString *str = self.leftTextField.text;
            
            str = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
            
            self.rightTextField.text = str;
            
            
        }else if ([textField isEqual:self.rightTextField]){
            
            NSString *str = self.rightTextField.text;
            
            str = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
            
            self.leftTextField.text = str;
        }
        
    }else{//输入操作
        
        if ([textField isEqual:self.leftTextField]) {
            
            self.rightTextField.text = [NSString stringWithFormat:@"%@%@",self.leftTextField.text,string];
            
            
        }else if ([textField isEqual:self.rightTextField]){
            
            self.leftTextField.text = [NSString stringWithFormat:@"%@%@",self.rightTextField.text,string];
        }
    }

    return YES;
}

//询问委托人是否应删除文本字段的当前内容
//- (BOOL)textFieldShouldClear:(UITextField *)textField;

//询问委托人文本字段是否应处理按下返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

#pragma mark ---- 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardIsVisible = YES;
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];@weakify(self)
    [UIView animateWithDuration:duration animations:^{@strongify(self) self.contentView.mj_y = MAINSCREEN_HEIGHT-self.contentView.mj_h-kbHeight;}];
}

#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    self.keyboardIsVisible = NO;
    duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self hideKeyboard];
}

- (void) hideKeyboard{
    @weakify(self)
    [UIView animateWithDuration:duration>0?duration:0.25 animations:^{
        @strongify(self)
        self.contentView.mj_y = MAINSCREEN_HEIGHT;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            @strongify(self)
            [self removeFromSuperview];
            [self.contentView removeFromSuperview];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillShowNotification
                                                          object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillHideNotification
                                                          object:nil];
            [IQKeyboardManager sharedManager].enable = YES; // 控制整个功能是否启用
            [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
        }
    }];
}

#pragma mark - lazyload
-(NSMutableArray *)titleBtnMutArr{
    
    if (!_titleBtnMutArr) {
        
        _titleBtnMutArr = NSMutableArray.array;
    }
    
    return _titleBtnMutArr;
}

-(NSMutableArray *)picBtnMutArr{
    
    if (!_picBtnMutArr) {
        
        _picBtnMutArr = NSMutableArray.array;
    }
    
    return _picBtnMutArr;
}

-(NSMutableArray *)btnMutArr{
    
    if (!_btnMutArr) {
        
        _btnMutArr = NSMutableArray.array;
    }
    
    return _btnMutArr;
}

-(void)setQuotaStr:(NSString *)quotaStr{
    
    _quotaStr = quotaStr;
    
    if (self.transactionAmountType == TransactionAmountTypeLimit) {
        
        quotaLab.text = [NSString stringWithFormat:@"限额%@",_quotaStr];
    }else if (self.transactionAmountType == TransactionAmountTypeFixed){
        
        quotaLab.text = @"单笔固额不可编辑单价";
    }
}

-(void)setRemainingStr:(NSString *)remainingStr{
    
    _remainingStr = remainingStr;
    
    remainingLab.text = [NSString stringWithFormat:@"剩余总数:%@",_remainingStr];
}

-(void)setFixedAmountStr:(NSString *)fixedAmountStr{
    
    _fixedAmountStr = fixedAmountStr;
    
    valueLeftLab.text = _fixedAmountStr;
    
    valueRightLab.text = _fixedAmountStr;
}

-(void)setFixedAmountMsg:(NSString *)fixedAmountMsg{
    
    _fixedAmountMsg = fixedAmountMsg;
    
    tipLab.text = _fixedAmountMsg;
}
-(void)noeBuyBubActionAnd:(BOOL)show block:(ActionBlock)noeBlock{
    if (show) {
        buyBtn.userInteractionEnabled = YES;//可以点
        [buyBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    }
    self.noeBuyBubblock = noeBlock;
}

@end
