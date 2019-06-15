//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.

#import "OrdersPageListCell.h"
#import "OrdersPageModel.h"
#import "OrderDetailModel.h"
@interface OrdersPageListCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)UIButton *statusBtn;
@property (nonatomic, strong)UIButton *leftStatusBtn;
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;

@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView* vipIV;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *saledLab;

@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, strong) UILabel *distributeTimeLab;
@property (nonatomic, strong) UILabel *modifyTimeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) UILabel *payMethodLab;
@property (nonatomic, strong) UIImageView* zIV;
@property (nonatomic, strong) UIImageView* wIV;
@property (nonatomic, strong) UIImageView* cIV;
@property (nonatomic, strong) NSMutableArray* payIvs;
@property (nonatomic, strong) NSMutableArray* statusBtns;

@property (nonatomic, strong) OrderDetailModel* model;
@end

@implementation OrdersPageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}
-(void)actionBlock:(ActionBlock)block{
    self.block = block;
}

- (void)richEles{
    
    
    _adIdLab = [[UILabel alloc]init];
    [self.contentView addSubview:_adIdLab];
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(20);
       make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@21);
    }];
    
    _line1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.adIdLab);
        make.trailing.equalTo(@0); make.top.equalTo(self.adIdLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.adIdLab);
   make.top.equalTo(self.line1.mas_bottom).offset(16.5);
        make.height.equalTo(@18);
//        make.width.equalTo(@190);
    }];
    _vipIV = [[UIImageView alloc]init];
    [self.contentView addSubview:_vipIV];
    
    _payMethodLab = [[UILabel alloc]init];
    [self.contentView addSubview:_payMethodLab];
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(@18);
    }];
    
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.leading.equalTo(self.typeLab);
        make.trailing.equalTo(@-22);
        make.top.equalTo(self.typeLab);
        make.height.equalTo(self.typeLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.trailing.equalTo(@-22); make.top.equalTo(self.balanceLab.mas_bottom).offset(10);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _modifyTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_modifyTimeLab];
    [_modifyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.saledLab); make.top.equalTo(self.saledLab.mas_bottom).offset(10);
        make.height.equalTo(self.saledLab);
       
    }];
    
    _distributeTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_distributeTimeLab];
    [_distributeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.modifyTimeLab.mas_top);
        make.height.equalTo(self.saledLab);
    }];
    
    _line2 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
       make.leading.equalTo(self.typeLab); make.top.equalTo(self.modifyTimeLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-22);
    }];

    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.layer.cornerRadius = 4;
    _statusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
    [_statusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
//    [_statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    _statusBtn.layer.borderWidth = 1;
    _statusBtn.clipsToBounds = YES;
    _statusBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_statusBtn];
    
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(5.5);
        make.trailing.equalTo(@-22);
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];

    _leftStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _leftStatusBtn.layer.cornerRadius = 4;
//    _leftStatusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
    
    //    [_statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
//    _leftStatusBtn.layer.borderWidth = 1;
//    _leftStatusBtn.clipsToBounds = YES;
    _leftStatusBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_leftStatusBtn];
    
    [_leftStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(5.5);
        make.leading.equalTo(@22);
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentLeft;
    _adIdLab.font = [UIFont boldSystemFontOfSize:15];;
    _adIdLab.textColor = HEXCOLOR(0x394368);
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _typeLab.textAlignment = NSTextAlignmentLeft;
    _typeLab.font = kFontSize(13);
    _typeLab.textColor = HEXCOLOR(0x666666);
    
    
    _balanceLab.textAlignment = NSTextAlignmentRight;
    _balanceLab.font = kFontSize(13);
    _balanceLab.textColor = HEXCOLOR(0x666666);
    
    _saledLab.textAlignment = NSTextAlignmentRight;
    _saledLab.font = kFontSize(13);
    _saledLab.textColor = HEXCOLOR(0x666666);
    
    _line2.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _modifyTimeLab.textAlignment = NSTextAlignmentRight;
    _modifyTimeLab.font = kFontSize(13);
    _modifyTimeLab.textColor = HEXCOLOR(0x666666);
    
    _distributeTimeLab.textAlignment = NSTextAlignmentLeft;
    _distributeTimeLab.font = kFontSize(14);
    _distributeTimeLab.textColor = HEXCOLOR(0x666666);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font =kFontSize(15);
    //layoutSubviews set prior richModel reset
//    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
    
    _statusBtn.titleLabel.font = kFontSize(15);
    _leftStatusBtn.titleLabel.font = kFontSize(15);
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"OrdersPageListCell";
    OrdersPageListCell *cell = (OrdersPageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OrdersPageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(OrderDetailModel*)model{
    OrderType type = [model getTransactionOrderType];
    switch (type) {
        case SellerOrderTypeFinished:
        case SellerOrderTypeCancel:
        case SellerOrderTypeTimeOut:
            return 152;
            break;
        default:
            return 186;
            break;
    }
    return 186;
}

- (void)richElementsInCellWithModel:(OrderDetailModel*)model{
    _model = model;
    OrderType type =  [model getTransactionOrderType];
    
    _statusLab.text = [model getTransactionOrderTypeTitle];
    [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];
    [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
    }];
    [_line2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    switch (type) {
        case SellerOrderTypeNotYetPay:
            {
                _statusLab.textColor = HEXCOLOR(0xd02a2a);
                
                _statusBtn.tag = type;
                [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
                [_statusBtn setTitle:@"提醒付款" forState:UIControlStateNormal];
                [_statusBtn setTitleColor:HEXCOLOR(0xd02a2a) forState:UIControlStateNormal];
                _statusBtn.layer.borderColor = HEXCOLOR(0xd02a2a).CGColor;
            }
            break;
        case SellerOrderTypeWaitDistribute:
        {
            _statusLab.textColor = HEXCOLOR(0x4c7fff);
            
            _statusBtn.tag = type;
            [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [_statusBtn setTitle:@"放行订单" forState:UIControlStateNormal];
            [_statusBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            _statusBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        }
            break;
        case SellerOrderTypeAppealing:
        {
            _statusLab.textColor = HEXCOLOR(0xd02a2a);
            
            _statusBtn.tag = type;
            [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [_statusBtn setTitle:@"联系买家" forState:UIControlStateNormal];
            [_statusBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
            _statusBtn.layer.borderColor = HEXCOLOR(0xff9238).CGColor;
            
            [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@85);
                make.height.equalTo(@28);
            }];
            [_leftStatusBtn setTitle:@"买家已申诉" forState:UIControlStateNormal];
            _leftStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_leftStatusBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
        }
            break;
        default:
        {
            _statusLab.textColor =  HEXCOLOR(0x8c96a5);
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@0);
            }];
            [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@0);
            }];
            [_line2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
            break;
    }
    
    _adIdLab.text = [model getOccurOrderTypeTitle];
    
    _balanceLab.text = [NSString stringWithFormat:@"放币数量：%@",model.number];
    _saledLab.text = [NSString stringWithFormat:@"应收款：%@ CNY",model.orderAmount];
    
    
    _modifyTimeLab.text = [NSString stringWithFormat:@"付款参考号：%@",model.paymentNumber];
    _distributeTimeLab.text = [NSString stringWithFormat:@"%@",model.createdTime];
    
    
    
    [self layoutTypeLabelWithModel:model];
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x666666);
    _payMethodLab.text = @"支付方式：";
    
    [self layoutPayMethodViewsWithModel:model];
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_model);
    }
}

- (void)layoutTypeLabelWithModel:(OrderDetailModel*)model{
    _typeLab.text = [NSString stringWithFormat:@"买方：%@",model.buyerName];
    //[NSString getAnonymousString:model.buyerName]
    CGFloat typeStringWidth =  [NSString getTextWidth:_typeLab.text withFontSize:kFontSize(13) withHeight:18];
    [_typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(typeStringWidth+6));
    }];
    [_vipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLab.mas_right);
        make.centerY.equalTo(self.typeLab);
        make.height.equalTo(@15);
        make.width.equalTo(@38);
    }];
    _vipIV.image = [UIImage imageNamed:[_model getPriorityImageName]];
}
- (void)layoutPayMethodViewsWithModel:(OrderDetailModel*)model{
    _payIvs = [NSMutableArray array];
    
    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payMethodLab);
        make.height.equalTo(self.payMethodLab);
        make.left.equalTo(self.payMethodLab.mas_right).offset(5);
    }];
    
    _wIV = [[UIImageView alloc] init];
    _wIV.tag = EnumActionTag1;
    _wIV.image = [UIImage imageNamed:@"icon_cir_weixin"];
    [self.payMethodView addSubview:_wIV];
    
    _zIV = [[UIImageView alloc] init];
    _zIV.tag = EnumActionTag2;
    _zIV.image = [UIImage imageNamed:@"icon_cir_zhifubao"];
    [self.payMethodView addSubview:_zIV];
    
    
    
    _cIV = [[UIImageView alloc] init];
    _cIV.tag = EnumActionTag3;
    _cIV.image = [UIImage imageNamed:@"YINGHANGKAXIR"];
    [self.payMethodView addSubview:_cIV];
    
    if ([NSString isEmpty:model.paymentWayString]) {
        return;
    }
    NSArray  *paymentways = [NSArray array];
    if ([model.paymentWayString containsString:@","]) {
        paymentways = [model.paymentWayString componentsSeparatedByString:@","];
    }else{
        paymentways = @[model.paymentWayString];
    }
    
    for (int i=0; i<paymentways.count; i++) {
        NSInteger tag = [paymentways[i] integerValue];
        if (tag == _wIV.tag&&![_payIvs containsObject:_wIV]) {
            [_payIvs addObject:_wIV];
        }
        if (tag == _zIV.tag&&![_payIvs containsObject:_zIV]) {
            [_payIvs addObject:_zIV];
        }
        if (tag == _cIV.tag&&![_payIvs containsObject:_cIV]) {
            [_payIvs addObject:_cIV];
        }
    }
    //    _payIvs = [@[_zIV, _wIV, _cIV]mutableCopy];
    if (_payIvs.count ==1) {
        [_payIvs.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.payMethodView.mas_left); make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@25);
            make.height.mas_equalTo(@25);
        }];
    }
    else{
        [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
        
        [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@25);
            make.height.mas_equalTo(@25);
            
        }];
    }
    
}
@end
