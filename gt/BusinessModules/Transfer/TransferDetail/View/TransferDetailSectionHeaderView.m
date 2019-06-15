//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransferDetailSectionHeaderView.h"
#define kTransferDetailHeightForHeaderInSections  151//19+25+19
@interface TransferDetailSectionHeaderView()
@property(nonatomic,strong)UIView* grandianView;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIButton* titleBtn;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation TransferDetailSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[TransferDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:TransferDetailSectionHeaderReuseIdentifier];
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
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(24, 30, MAINSCREEN_WIDTH -2*24, 121)];
        _bgView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:_bgView];
        
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 121-.5, _bgView.size.width, .5)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [_bgView addSubview:self.sectionLine];
    
        
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake(0, 33, _bgView.size.width, 40);
        _titleBtn.hidden = NO;
        [_bgView addSubview:_titleBtn];
        _titleBtn.layer.borderWidth=0.0;
        _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _titleBtn.titleLabel.font = kFontSize(24);
        _titleBtn.titleLabel.numberOfLines = 0;
        //        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_titleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_titleBtn setBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateNormal];
//        [_titleBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [_bgView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _topicRefreshBtn.titleLabel.font = kFontSize(14);
//        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:HEXCOLOR(0x545454) forState:UIControlStateNormal];
        [_topicRefreshBtn setBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
    }
    return self;
}

- (void)richElementsInViewWithModel:(NSDictionary*)model{
    TransferDetailType type = [model[kType] integerValue];
    NSString *title = model[kTip];
    NSString *subTitle = model[kSubTip];
    NSString *img = model[kImg];
    
    self.sectionLine.hidden = NO;
    _topicRefreshBtn.hidden = YES;
    _topicRefreshBtn.frame = CGRectZero;
    switch (type) {
        case TransferDetailTypeSuccess:
        {
            
            [_titleBtn setAttributedTitle: [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(28) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)] forState:UIControlStateNormal];
            [_titleBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
            [_titleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
            _topicRefreshBtn.hidden = NO;
            _topicRefreshBtn.frame = CGRectMake(0, CGRectGetMaxY(_titleBtn.frame)+13, _bgView.frame.size.width, 30);
            [_topicRefreshBtn setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
        
        default:{
            _sectionLine.hidden = NO;
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
    return kTransferDetailHeightForHeaderInSections;
}
@end


@interface TransferDetailSectionFooterView ()
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *appealBtn;

@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, copy) TwoDataBlock block;
@property(nonatomic,strong)NSDictionary* model;
@end


@implementation TransferDetailSectionFooterView
+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[TransferDetailSectionFooterView class] forHeaderFooterViewReuseIdentifier:TransferDetailSectionFooterReuseIdentifier];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self _initObject];
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
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 6;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    _sureBtn.userInteractionEnabled = YES;
    [_sureBtn addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_sureBtn];

    
    
}
- (void)richElementsInViewWithModel:(NSDictionary*)model{
    _model = model;
    TransferDetailType type = [model[kType] integerValue];
    NSDictionary* dic =model[kIndexSection];
    NSString *title = dic[kTip];
//    NSString *subTitle = dic[kSubTit];
    _bgView.frame = CGRectZero;
    _sectionLine.frame = CGRectZero;
    _timeLab.frame = CGRectZero;
    _tipLab.frame = CGRectZero;
    _sureBtn.frame = CGRectZero;
    _appealBtn.frame = CGRectZero;
    
    switch (type) {
        case TransferDetailTypeSuccess:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [TransferDetailSectionFooterView viewHeightWithType:type]);
            
            [_sureBtn setTitle:title forState:UIControlStateNormal];
            _sureBtn.frame = CGRectMake(68,34.3, _bgView.width-2*68, 40);
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
        self.block(@(bt.tag),self.model);
    }
}

+ (CGFloat)viewHeightWithType:(TransferDetailType)type
{
    switch (type) {
        case TransferDetailTypeSuccess:
        {
            return 104.3;
        }
            break;
            
        default:
            return 180;
            break;
    }
}
@end
