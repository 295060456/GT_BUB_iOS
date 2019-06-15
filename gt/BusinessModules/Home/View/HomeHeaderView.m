//
//  HomeHeaderView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/16.
//  Copyright © 2019 GT. All rights reserved.
//

#import "HomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "UICountingLabel.h"
#import "HomeModel.h"

#define  remFont  [UIFont fontWithName:@"SFU DIN" size:37 * SCALING_RATIO]

@interface HomeHeaderView ()
<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) UILabel *myZC; // 我的资产la
@property (nonatomic, strong) UILabel *aliasLab;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UICountingLabel *rmbLab;
@property (nonatomic, strong) UICountingLabel *exchangeRmbLab;
@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIButton *jumpAssetBtn;
@property (nonatomic, strong) UITextField *texFile;
@property (nonatomic, strong) UIImageView *decorIv;
@end

@implementation HomeHeaderView

-(instancetype)initViewBlock:(TwoDataBlock)block{
    self = [super init];
    if (self) {
        self.block  = block;
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    } return self;
}

-(void)initView{
    UIImage* decorImage = kIMG(@"homes_img");
    _decorIv = [[UIImageView alloc]init];
    [self addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.leading.trailing.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH, 276*SCALING_RATIO));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    _decorIv.userInteractionEnabled = YES;
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _aliasLab = [[UILabel alloc]init];
    [_decorIv addSubview:_aliasLab];
    [_aliasLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(23*SCALING_RATIO);
        //        make.height.equalTo(@40);
    }];
    
    _loginBtn = [[UIButton alloc]init];
    [_decorIv addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.aliasLab.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(38*SCALING_RATIO);
        make.size.mas_equalTo(CGSizeMake(114,35*SCALING_RATIO));
    }];
    
    _myZC = [[UILabel alloc] init];
    [_decorIv addSubview:_myZC];
    _myZC.font = kFontSize(12);
    _myZC.textColor = HEXCOLOR(0xffffff);
    _myZC.text = @"可用资产";
    [_myZC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*SCALING_RATIO);
        make.top.mas_equalTo(25*SCALING_RATIO);
        //        make.height.equalTo(@17);
    }];
    
    _rmbLab = [[UICountingLabel alloc]init];
    _rmbLab.textColor = HEXCOLOR(0xffffff);
    _rmbLab.font = remFont;
    [_decorIv addSubview:_rmbLab];
    //    _rmbLab.backgroundColor = KYellowColor;
    [_rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*SCALING_RATIO);
        make.top.mas_equalTo(34*SCALING_RATIO);
        //        make.height.equalTo(@17);
    }];
    
    _exchangeRmbLab = [[UICountingLabel alloc]init];
    //    _exchangeRmbLab.backgroundColor = kRedColor;
    [_decorIv addSubview:_exchangeRmbLab];
    [_exchangeRmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*SCALING_RATIO);
        make.top.equalTo(self.rmbLab.mas_bottom).offset(0);
    }];
    
    _recordBtn = [[UIView alloc]init];
    [_decorIv addSubview:_recordBtn];
    _recordBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.4];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtnS)];
    [_recordBtn addGestureRecognizer:ta];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(49*SCALING_RATIO);
        make.left.mas_equalTo(self.decorIv.mas_right).offset(-87*SCALING_RATIO);
        make.size.mas_equalTo(CGSizeMake(87*SCALING_RATIO, 26*SCALING_RATIO));
    }];
    _recordBtn.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 87*SCALING_RATIO, 26*SCALING_RATIO) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(100*SCALING_RATIO, 100*SCALING_RATIO)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 87*SCALING_RATIO, 26*SCALING_RATIO);
    maskLayer.path = maskPath.CGPath;
    _recordBtn.layer.mask = maskLayer;
    UILabel *recordLa = [[UILabel alloc] init];
    [_recordBtn addSubview:recordLa];
    recordLa.textColor = HEXCOLOR(0xffffff);
    recordLa.font = kFontSize(12*SCALING_RATIO);
    recordLa.text = @"转账记录";
    [recordLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.recordBtn.mas_left).offset(14*SCALING_RATIO);
        make.height.mas_equalTo(self.recordBtn.mas_height);
    }];
    UIImageView *recordIm = [[UIImageView alloc] init];
    recordIm.image = kIMG(@"GroupCopyXi");
    [_recordBtn addSubview:recordIm];
    [recordIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5*SCALING_RATIO);
        make.left.mas_equalTo(self.recordBtn.mas_left).offset(70*SCALING_RATIO);
//       make.size.mas_equalTo(CGSizeMake(87*SCALING_RATIO, 26*SCALING_RATIO));
    }];
    
    //
    NSArray *dataAr = @[@"订单",@"兑换比特币",@"买币",@"卖币"];
    NSArray *imageAr = @[@"home_order",@"home_bite",@"home_jiaoyi",@"home_BuyBi"];
    NSInteger count = dataAr.count;
    float wi = (MAINSCREEN_WIDTH )/count;
    float itemTop = YBSystemTool.isIphoneX? 189*SCALING_RATIO +20 : 189*SCALING_RATIO;
    itemTop = itemTop - nabarHit;
    for (int i = 0; i<count; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake( wi*i , itemTop, wi, 47*SCALING_RATIO)];
        itemView.tag = 2900+i;
        [self addSubview:itemView];
        UIImageView *itemIm = [[UIImageView alloc]initWithFrame:CGRectMake(wi/2-13*SCALING_RATIO, 0, 26*SCALING_RATIO, 26*SCALING_RATIO)];
        itemIm.image = kIMG(imageAr[i]);
        itemIm.userInteractionEnabled = YES;
        [itemView addSubview:itemIm];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 33*SCALING_RATIO, wi, 14*SCALING_RATIO)];
        la.textColor = kWhiteColor;
        la.font = kFontSize(13*SCALING_RATIO);
        la.userInteractionEnabled = YES;
        la.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:la];
        la.text = dataAr[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellContenViewTapAction:)];
        [itemView addGestureRecognizer:tap];
    }
    
    float wiTop = YBSystemTool.isIphoneX? 250*SCALING_RATIO +20 : 250*SCALING_RATIO;
    wiTop = wiTop - nabarHit;
    UIView *witeView = [[UIView alloc] initWithFrame:CGRectMake(10*SCALING_RATIO, wiTop, MAINSCREEN_WIDTH - 20*SCALING_RATIO, 90*SCALING_RATIO)];
    witeView.backgroundColor = kWhiteColor;
    witeView.layer.cornerRadius = 6*SCALING_RATIO;
    [self addSubview:witeView];
    
    UILabel *oneClick = [[UILabel alloc] initWithFrame:CGRectMake(22*SCALING_RATIO, 14*SCALING_RATIO, 64*SCALING_RATIO, 18*SCALING_RATIO)];
    oneClick.font = kFontSize(15*SCALING_RATIO);
    [oneClick setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15*SCALING_RATIO]];
    oneClick.textColor = HEXCOLOR(0x333333);
    oneClick.text = @"一键购买";
    [witeView addSubview:oneClick];
    
    UILabel *unitPrice = [[UILabel alloc] initWithFrame:CGRectMake(90*SCALING_RATIO, 17*SCALING_RATIO, 101*SCALING_RATIO, 14*SCALING_RATIO)];
    unitPrice.font = kFontSize(12*SCALING_RATIO);
    unitPrice.textColor = HEXCOLOR(0x8c96a5); // 8c96a5
    unitPrice.text = @"单价:1BUB=1元";
    [witeView addSubview:unitPrice];
    
    UIView *tfView = [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 38*SCALING_RATIO, MAINSCREEN_WIDTH -50*SCALING_RATIO, 40*SCALING_RATIO)];
    tfView.backgroundColor = HEXCOLOR(0xf7f7f7);
    tfView.layer.cornerRadius = 6*SCALING_RATIO;
    [witeView addSubview:tfView];
    
    self.texFile = [[UITextField alloc] initWithFrame:CGRectMake(14*SCALING_RATIO, 0, tfView.bounds.size.width - 20*SCALING_RATIO - 103*SCALING_RATIO, 40*SCALING_RATIO)];
    [tfView addSubview:self.texFile];
    self.texFile.keyboardType = UIKeyboardTypeNumberPad;
    self.texFile.textAlignment = NSTextAlignmentLeft;
    self.texFile.textColor = HEXCOLOR(0x333333);
    self.texFile.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16*SCALING_RATIO];
    self.texFile.placeholder = @"请输入购买金额";
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(tfView.bounds.size.width-103*SCALING_RATIO, 0, 103*SCALING_RATIO, 40*SCALING_RATIO)];
    rightView.userInteractionEnabled = YES;
    rightView.image = [UIImage imageNamed:@"mastBuyXi"];
    rightView.contentMode = UIViewContentModeScaleToFill;
    [tfView addSubview:rightView];
    UITapGestureRecognizer *tfRightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tfRightTapAction)];
    [rightView addGestureRecognizer:tfRightTap];
    CGFloat wis = MAINSCREEN_WIDTH-20*SCALING_RATIO;
    CGFloat his = wis*71/355;
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( MAINSCREEN_WIDTH/2-wis/2, CGRectGetMaxY(witeView.frame) + 12*SCALING_RATIO, wis, his)  placeholderImage:[UIImage imageNamed:@"bub_LONG_PLACEDHOLDER_IMG"]];
    _sdCycleScrollView.autoScrollTimeInterval = 2.0;
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.showPageControl = NO;
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleScrollView.currentPageDotColor = HEXCOLOR(0xc6c6c6); // 自定义分页控件小圆标颜色
    _sdCycleScrollView.layer.masksToBounds = YES;
    _sdCycleScrollView.layer.cornerRadius = 4;
    [self addSubview:_sdCycleScrollView];
    [self layoutIfNeeded];
    
    _jumpAssetBtn= [[UIButton alloc]init];
    _jumpAssetBtn.tag = EnumActionTag12;
    _jumpAssetBtn.backgroundColor = kClearColor;
    [_decorIv addSubview:_jumpAssetBtn];
    [_jumpAssetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.exchangeRmbLab.mas_centerY);
        make.top.equalTo(self.decorIv.mas_top).offset(0);
        //        make.left.equalTo(self.msgBtn.mas_right).offset(0);
        make.right.equalTo(self.recordBtn.mas_left).offset(0);
        make.bottom.equalTo(self.sdCycleScrollView.mas_top).offset(0);
    }];
    
    
    
    _aliasLab.textAlignment = NSTextAlignmentCenter;
    _aliasLab.font = [UIFont systemFontOfSize:14];
    _aliasLab.textColor = HEXCOLOR(0xffffff);
    
    _loginBtn.tag = EnumActionTag8;
    _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 6;
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    _loginBtn.adjustsImageWhenHighlighted = NO;
    _loginBtn.titleLabel.font = kFontSize(15);
    
    
    _rmbLab.numberOfLines = 0;
    
    _exchangeRmbLab.textAlignment = NSTextAlignmentCenter;
    _exchangeRmbLab.font = kFontSize(12);
    _exchangeRmbLab.numberOfLines = 0;
    _exchangeRmbLab.textColor = HEXCOLOR(0xffffff);
    
    _recordBtn.tag = EnumActionTag9;
    //    _recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [_recordBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    //    _recordBtn.adjustsImageWhenHighlighted = NO;
    //    _recordBtn.titleLabel.font = kFontSize(12*SCALING_RATIO);
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    BOOL isLogin = GetUserDefaultBoolWithKey(kIsLogin);
    if (!isLogin) { // 非登录
        _aliasLab.hidden = YES;
        _loginBtn.hidden = NO;
        _aliasLab.text = @"账号余额：";
        [_loginBtn setTitle:@"请先登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _jumpAssetBtn.hidden = YES;
        _rmbLab.hidden = YES;
        _exchangeRmbLab.hidden = YES;
        _myZC.hidden = YES;
        _recordBtn.hidden = YES;
    }else{ // 已登录
        _aliasLab.hidden = YES;
        _loginBtn.hidden = YES;
        _rmbLab.hidden = NO;
        _rmbLab.text = @"0.00";
        _exchangeRmbLab.hidden = NO;
        _exchangeRmbLab.text = @"折合人民币 0.00";
        _recordBtn.hidden = NO;
        _myZC.hidden = NO;
        _jumpAssetBtn.hidden = NO;
        [_jumpAssetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (![model[kIndexInfo] isEqual:@""]) {
            
            UserAssertModel* usModel = model[kIndexInfo];
            //        _rmbLab.attributedText = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",model[kTit]] stringColor:HEXCOLOR(0xffffff) stringFont:kFontSize(14) subString:[NSString stringWithFormat:@"\n%@",usModel.amount] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(37)];
            CGFloat toValue = [usModel.usableFund floatValue];//123989.22;
            _rmbLab.attributedFormatBlock = ^NSAttributedString* (CGFloat value)
            {
                NSDictionary* highlight = @{ NSFontAttributeName: remFont,NSForegroundColorAttributeName:HEXCOLOR(0xffffff) }; // 修改字体
                NSString *postfix = [NSString stringWithFormat:@"%.2f", (float)value];
                postfix = [postfix formatDecimalNumber];
                NSAttributedString* postfixAttr = [[NSAttributedString alloc] initWithString: postfix
                                                                                  attributes:highlight];
                return postfixAttr;
            };
            [_rmbLab countFrom:0.0 to:toValue withDuration:2.];
            
            _exchangeRmbLab.formatBlock = ^NSString* (CGFloat value)
            {
                NSString *fix = [NSString stringWithFormat:@"%.2f", (float)value];
                fix = [fix formatDecimalNumber];
                return [NSString stringWithFormat:@"折合人民币 %@", fix];
            };
            _exchangeRmbLab.method = UILabelCountingMethodEaseOut;
            [_exchangeRmbLab countFrom:0.0 to:[usModel.usableFund floatValue] withDuration:2.5];
            //        _exchangeRmbLab.text = [NSString stringWithFormat:@"折合人民币   %@",usModel.convertRmb];
        }
    }
    NSArray* imagesModels = model[kArr];
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
    //    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            HomeBannerData *bData = imagesModels[i];
            [imageURLStrings addObject:bData.imageUrl];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    if (imagesModels.count==1) {
        _sdCycleScrollView.autoScroll = NO;
    }else{
        _sdCycleScrollView.autoScroll = YES;
    }
    
    WS(weakSelf);
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        HomeBannerData *model = imagesModels[index];
        if (model!=nil) {
            //        NSDictionary *model = imagesModels[index];
            if (weakSelf.block) {
                weakSelf.block(@(EnumActionTag10),model);
            }
        }
        
    };
}

-(void)cellContenViewTapAction:(UITapGestureRecognizer*)ta{
    UIView *view = ta.view;
    NSLog(@"-- %ld",view.tag);
    NSInteger typ = view.tag - 2900;
    EnumActionTag tg = EnumActionTag2;
    switch (typ) {
        case 0:
            tg = EnumActionTag2;
            break;
        case 1:
            tg = EnumActionTag3;
            break;
        case 2:
            tg = EnumActionTag1;
            break;
        case 3:
            tg = EnumActionTag4;
            break;
        default:
            return;
    }
    if (self.block) {
        self.block(@(tg),nil);
    }
}

- (void)clickBtn:(UIButton*)sender{
    if (self.block) {
        self.block(@(sender.tag),sender);
    }
}

- (void)clickBtnS{
    if (self.block) {
        self.block(@(EnumActionTag9),nil);
    }
}

-(void)tfRightTapAction{
    NSString *number = self.texFile.text;
    [self endEditing:YES];
    if (self.block) {
        self.block(@(EnumActionTag13), number);
    }
}


@end
