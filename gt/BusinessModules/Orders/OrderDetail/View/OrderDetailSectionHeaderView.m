//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "OrderDetailSectionHeaderView.h"
#define kOrderDetailHeightForHeaderInSections  125//19+25+19
@interface OrderDetailSectionHeaderView()
@property(nonatomic,strong)UIView* grandianView;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation OrderDetailSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[OrderDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:OrderDetailSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
        self.backgroundView = [[UIView alloc] init];
//        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
        _grandianView = [[UIView alloc]initWithFrame:CGRectMake(7, 20, MAINSCREEN_WIDTH -2*7, 20)];
        _grandianView.layer.cornerRadius = 10;
        [_grandianView gradientLayerAboveView:_grandianView withShallowColor:HEXCOLOR(0x737373) withDeepColor:HEXCOLOR(0x313131) isVerticalOrHorizontal:YES];
        
        [self.contentView addSubview:_grandianView];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(24, 30, MAINSCREEN_WIDTH -2*24, 95+5)];
        _bgView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:_bgView];
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0,_bgView.size.height - .5, _bgView.size.width, .5)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_bgView addSubview:self.sectionLine];
    
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _topicRefreshBtn.titleLabel.numberOfLines = 0;
        [_bgView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        
//        [_topicRefreshBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF9CE88)] forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        _topicRefreshBtn.frame = CGRectMake(0, 0, _bgView.size.width, _bgView.size.height-.5);
        [_topicRefreshBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:9];
    }
    return self;
}

- (void)richElementsInViewWithModel:(NSDictionary*)model{
    OrderType type = [model[kType] integerValue];
    NSString *title = model[kTip];
    NSString *subTitle = model[kSubTip];
    NSString *img = model[kImg];
    self.sectionLine.hidden = NO;
    _topicRefreshBtn.hidden = NO;
    
    switch (type) {
        case SellerOrderTypeWaitDistribute:{
            [_topicRefreshBtn setAttributedTitle:[NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(20) subString:[NSString stringWithFormat:@"\n%@",subTitle] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)] forState:UIControlStateNormal];
            [_topicRefreshBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }
            break;
        case SellerOrderTypeCancel:
        case SellerOrderTypeTimeOut:
        case SellerOrderTypeNotYetPay:
        case SellerOrderTypeAppealing:
        case SellerOrderTypeFinished:
            
        case BuyerOrderTypeNotYetPay:
        case BuyerOrderTypeHadPaidWaitDistribute:
        case BuyerOrderTypeHadPaidNotDistribute:
        case BuyerOrderTypeFinished:
        case BuyerOrderTypeCancel:
        case BuyerOrderTypeClosed:
        case BuyerOrderTypeAppealing:
        {
//            _topicRefreshBtn.titleLabel.font = kFontSize(24);
//            [_topicRefreshBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
//            [_topicRefreshBtn setTitle:title forState:UIControlStateNormal];//up attributed down attributed
            [_topicRefreshBtn setAttributedTitle:[NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)] forState:UIControlStateNormal];
            [_topicRefreshBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];

        }
            break;
        default:{
            _sectionLine.hidden = YES;
            _topicRefreshBtn.hidden = YES;
            _topicRefreshBtn.frame = CGRectZero;
            
        }
            break;
    }
}
- (void)refreshTopic:(UIButton*)sender {

}
+ (CGFloat)viewHeight
{
    return 125+5;
}
@end


@interface OrderDetailSectionFooterView ()
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *appealBtn;

@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, copy) TwoDataBlock block;
@property(nonatomic,strong)NSDictionary* model;
@property (nonatomic, strong) NSMutableArray *dataBtns;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,assign)OrderType type;
@end


@implementation OrderDetailSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[OrderDetailSectionFooterView class] forHeaderFooterViewReuseIdentifier:OrderDetailSectionFooterReuseIdentifier];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self _initObject];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(distoryTimer) name:kNotify_IsStopTimeRefresh object:nil];
    }
    return self;
}

- (void)_initObject
{
    self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
    self.backgroundView = [[UIView alloc] init];
    
    //        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
    
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:_bgView];
    
    _sectionLine = [[UIImageView alloc]init];
    _sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
    _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_bgView addSubview:_sectionLine];
    
    _timeLab = [[UILabel alloc]init];
    _timeLab.font = kFontSize(40);
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = HEXCOLOR(0xff9238);
    [_bgView addSubview:_timeLab];
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.font = kFontSize(12);
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.textColor = HEXCOLOR(0x4c7fff);
    [_bgView addSubview:_tipLab];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.tag = EnumActionTag0;
    _sureBtn.adjustsImageWhenHighlighted = NO;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sureBtn setTitle:@"确认已收款，放行" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 6;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    _sureBtn.userInteractionEnabled = YES;
    [_sureBtn addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_sureBtn];

    _appealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _appealBtn.tag = EnumActionTag1;
    _appealBtn.adjustsImageWhenHighlighted = NO;
    _appealBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_appealBtn setTitle:@"未收到款，去申诉" forState:UIControlStateNormal];
    [_appealBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    _appealBtn.layer.masksToBounds = YES;
    _appealBtn.layer.cornerRadius = 6;
    _appealBtn.layer.borderWidth = 1;
    _appealBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [_appealBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    _appealBtn.userInteractionEnabled = YES;
    [_appealBtn addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_appealBtn];
    
}
- (void)richElementsInViewWithModel:(NSDictionary*)model{
    _model = model;
    OrderType type = [model[kType] integerValue];
    _type = type;
    NSDictionary* dic =model[kIndexSection];
    NSString *title = dic[kTip];
    NSString *subTitle = dic[kSubTip];
    _bgView.frame = CGRectZero;
    _sectionLine.frame = CGRectZero;
    _timeLab.frame = CGRectZero;
    _tipLab.frame = CGRectZero;
    _sureBtn.frame = CGRectZero;
    _appealBtn.frame = CGRectZero;
    
    switch (type) {
        case BuyerOrderTypeHadPaidWaitDistribute://downT
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            _sureBtn.frame = CGRectMake(68, CGRectGetMaxY(_tipLab.frame)+4.3, _bgView.width-2*68, 40);
            [_sureBtn setTitle:@"我要申诉" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = NO;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0xcdcdcd).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xcdcdcd)] forState:UIControlStateNormal];
            
            
            _appealBtn.frame = CGRectZero;
            
//            _timeLab.text = title;
            [self startTimeCount:title];
        
            _tipLab.text = subTitle;
        }
            break;
        case BuyerOrderTypeHadPaidNotDistribute://downT
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 40);
            _tipLab.frame = CGRectMake(24, CGRectGetMaxY(_timeLab.frame)+13.7, _bgView.width-2*24, 34);
            _tipLab.numberOfLines = 0;
            _sureBtn.frame = CGRectMake(68, CGRectGetMaxY(_tipLab.frame)+4.3, _bgView.width-2*68, 40);
            [_sureBtn setTitle:@"我要申诉" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = @"00:00";//title;
            _tipLab.text = subTitle;
        }
            break;
        case BuyerOrderTypeNotYetPay:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            _sureBtn.frame = CGRectMake(68, CGRectGetMaxY(_tipLab.frame)+4.3, _bgView.width-2*68, 40);
            [_sureBtn setTitle:@"已完成付款" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            _appealBtn.frame = CGRectMake(68, CGRectGetMaxY(_sureBtn.frame)+10, _bgView.width-2*68, 40);
            [_appealBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            _appealBtn.userInteractionEnabled = YES;
            [_appealBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            _appealBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_appealBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            
//            _timeLab.text = title;
            [self startTimeCount:title];
            _tipLab.text = subTitle;
            
        }
            break;
        case BuyerOrderTypeCancel:
        case BuyerOrderTypeClosed:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;//CGRectMake(0, 30, _bgView.width, 17);
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = title;
            _tipLab.text = subTitle;
            
        }
            break;
        case SellerOrderTypeWaitDistribute:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            _sureBtn.frame = CGRectMake(68, CGRectGetMaxY(_tipLab.frame)+4.3, _bgView.width-2*68, 40);
            [_sureBtn setTitle:@"确认已收款，放行" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            
            _appealBtn.frame = CGRectMake(68, CGRectGetMaxY(_sureBtn.frame)+10, _bgView.width-2*68, 40);
            [_appealBtn setTitle:@"未收到款，去申诉" forState:UIControlStateNormal];
            _appealBtn.userInteractionEnabled = YES;
            [_appealBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            _appealBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_appealBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            
//            _timeLab.text = title;
            [self startTimeCount:title];
            _tipLab.text = subTitle;
            
        }
            break;
        case SellerOrderTypeCancel:
        case SellerOrderTypeTimeOut:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectMake(0, 30, _bgView.width, 17);
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = title;
            _tipLab.text = subTitle;
        }
            break;
        case SellerOrderTypeNotYetPay:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
//            _timeLab.text = title;
            [self startTimeCount:title];
            _tipLab.text = subTitle;
            
        }
            break;
        case BuyerOrderTypeAppealing:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
            
            _sureBtn.frame = CGRectMake(68, 76, _bgView.width-2*68, 40);
            [_sureBtn setTitle:@"取消申诉" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            _appealBtn.frame = CGRectZero;
        }
            break;
        case SellerOrderTypeAppealing:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
            
            _sureBtn.frame = CGRectZero;
            
            _appealBtn.frame = CGRectZero;
        }
            break;
        case SellerOrderTypeFinished:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _sectionLine.frame = CGRectMake(0, 26, _bgView.width, .5);
            
            _timeLab.frame = CGRectMake(23, CGRectGetMaxY(_sectionLine.frame)+25.5, _bgView.width-2*23, 85);
//            _tipLab.frame = CGRectMake(23, CGRectGetMaxY(_timeLab.frame)+14, _timeLab.width, 22);
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            //            _timeLab.text = title;
            _tipLab.frame = CGRectZero;
            _timeLab.numberOfLines = 0;
            _timeLab.attributedText = [NSString attributedStringWithString:@"交易号："  stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:[NSString stringWithFormat:@"\n%@",subTitle] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)];
//            _timeLab.lineBreakMode = NSLineBreakByCharWrapping;
        }
            break;
        case BuyerOrderTypeFinished:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _sectionLine.frame = CGRectZero;
            
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
            
            _sureBtn.frame = CGRectMake(24, 38, (_bgView.width - (2*24+13))/2, 40);
            [_sureBtn setTitle:@"查看资产" forState:UIControlStateNormal];
            _sureBtn.userInteractionEnabled = YES;
            [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            
            _appealBtn.frame = CGRectMake(CGRectGetMaxX(_sureBtn.frame)+13, 38, _sureBtn.width, 40);
            _appealBtn.userInteractionEnabled = YES;
            [_appealBtn setTitle:@"扫码转币" forState:UIControlStateNormal];
            [_appealBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
            _appealBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [_appealBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
            
            
        }
            break;

            
        default:
        {
            _bgView.frame = CGRectZero;
            _sectionLine.frame = CGRectZero;
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
        }
            break;
    }
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

#pragma mark - Click bt
- (void)_clickAction:(UIButton *)bt
{
    if (self.block)
    {
        self.block(@(bt.tag),@(_type));
    }
}

+ (CGFloat)viewHeightWithType:(OrderType)type
{
    switch (type) {
        case BuyerOrderTypeCancel:
        case BuyerOrderTypeClosed:
        {
            return 60;
        }
            break;
        case BuyerOrderTypeHadPaidNotDistribute:
        case BuyerOrderTypeHadPaidWaitDistribute:
        {
            return 194;
        }
            break;
        case BuyerOrderTypeNotYetPay:
        case SellerOrderTypeWaitDistribute:
        {
            return 217+30;
        }
            break;
        case SellerOrderTypeCancel:
        case SellerOrderTypeTimeOut:
        {
            return 60+17+40;
        }
            break;
        case SellerOrderTypeNotYetPay:
        {
            return 80+77;
        }
            break;
            
        case BuyerOrderTypeFinished:
        {
            return 114;
        }
            break;
        case SellerOrderTypeFinished:
        {
            return 122.5+26;
        }
            break;
        case BuyerOrderTypeAppealing:
        case SellerOrderTypeAppealing:
        {
            return 158;
        }
            break;
        default:
            return 180;
            break;
    }
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
//    self.timeLab.enabled = false;//grey
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    //    NSString *title = [NSString stringWithFormat:@"%ld",(long)self.timeCount];
    self.timeLab.text = [NSString timeWithSecond:self.timeCount];
    self.timeLab.textColor = HEXCOLOR(0xff9238);
//    [self.timeBtn setTitle:[NSString timeWithSecond:self.timeCount] forState:UIControlStateNormal];
//    [self.timeBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
    if(self.timeCount < 0)
    {
        [self distoryTimer];
//        self.timeLab.enabled = false;//grey
        self.timeLab.text = @"00:00";
        //        [self.timeBtn setTitle:@"已停止" forState:UIControlStateNormal];
        //        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        
        if (self.block) {
            self.block(@(EnumActionTag3), @(_type));
        }
        
    }
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [self distoryTimer];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotify_IsStopTimeRefresh object:nil];
}
@end
