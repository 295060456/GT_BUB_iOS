//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "PageListCell.h"
#import "ModifyAdsModel.h"
@interface PageListCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;

@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView *typeImg;

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
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) id modle;
@end

@implementation PageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    
    
    _adIdLab = [[UILabel alloc]init];
    [self.contentView addSubview:_adIdLab];
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(15);
       make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@21);
    }];
    
    _line1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0); make.top.equalTo(self.adIdLab.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.adIdLab);
        make.top.equalTo(self.line1.mas_bottom).offset(8.5);
        make.height.equalTo(@17.3);
    }];
    
    _typeImg = UIImageView.new;
    [_typeLab addSubview:_typeImg];
    [_typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@1);
        make.centerY.equalTo(self.typeLab.mas_centerY).offset(.4);
    }];
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(self.typeLab); make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(self.typeLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.balanceLab); make.top.equalTo(self.balanceLab.mas_bottom).offset(3);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _line2 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
       make.trailing.equalTo(@0); make.top.equalTo(self.saledLab.mas_bottom).offset(11);
        make.height.equalTo(@1);
    }];
    
    _distributeTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_distributeTimeLab];
    [_distributeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.saledLab);
        make.top.equalTo(self.line2.mas_bottom).offset(9.5);
        make.height.equalTo(@16);
    }];
    
    _modifyTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_modifyTimeLab];
    [_modifyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.distributeTimeLab); make.top.equalTo(self.distributeTimeLab.mas_bottom).offset(2);
        make.height.equalTo(self.distributeTimeLab);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-15);
    }];
    
    
    _statusBtns = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statusBtn.layer.cornerRadius = 4;
        statusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
        [statusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
        [statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        statusBtn.layer.borderWidth = 1;
        statusBtn.clipsToBounds = YES;
        statusBtn.tag = i;
        [self.contentView addSubview:statusBtn];
        [statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [_statusBtns addObject:statusBtn];
        float wi = 50;
        float ri = -15;
        if (i == 0) {
            wi = 89;
            ri = -77;
        }
            [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-13);
                make.right.mas_equalTo(self.contentView.mas_right).offset(ri);
                make.width.mas_equalTo(wi);
                make.height.mas_equalTo(@28);
            }];
    }
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        EnumActionTag ta = EnumActionTag0;
        if ([button.titleLabel.text isEqualToString:@"下架"]) {
             ta = EnumActionTag2;
        }else if ([button.titleLabel.text isEqualToString:@"补充并上架"]){
            ta = EnumActionTag1;
        }
        self.block(@(ta),_modle);
    }
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentLeft;
    _adIdLab.font = kFontMediumSize(15);
    _adIdLab.textColor = HEXCOLOR(0x333333);
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.font = kFontMediumSize(12);
    _typeLab.textColor = RGBCOLOR(255, 255, 255);
    _typeLab.backgroundColor = COLOR_RGB(76, 127, 255, .7);
    _typeLab.layer.masksToBounds = YES;
    _typeLab.layer.cornerRadius = 2;
    
    _balanceLab.textAlignment = NSTextAlignmentLeft;
    _balanceLab.font = kFontSize(13);
    _balanceLab.textColor = HEXCOLOR(0x394368);
    
    _saledLab.textAlignment = NSTextAlignmentLeft;
    _saledLab.font = kFontSize(14);
    _saledLab.textColor = HEXCOLOR(0x394368);
    
    _line2.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _distributeTimeLab.textAlignment = NSTextAlignmentLeft;
    _distributeTimeLab.font = kFontSize(11);
    _distributeTimeLab.textColor = HEXCOLOR(0x8c96a5);
    
    _modifyTimeLab.textAlignment = NSTextAlignmentLeft;
    _modifyTimeLab.font = kFontSize(11);
    _modifyTimeLab.textColor = HEXCOLOR(0x8c96a5);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font = kFontSize(15);
//    _statusLab.textColor =  RGBCOLOR(57, 67, 104);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"PageListCell";
    PageListCell *cell = (PageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 15+21+19+21+10+20+3+20+21+16+2+16+8;
}

- (void)richElementsInCellWithModel:(ModifyAdsModel*)model{
    _modle = model;
    _adIdLab.text = [NSString stringWithFormat:@"广告ID：%@",model.ugOtcAdvertId];
    
    _balanceLab.text = [NSString stringWithFormat:@"剩余库存：%@",model.balance];
    _saledLab.text = [NSString stringWithFormat:@"已售销量：%@",model.volume];
    
    _distributeTimeLab.text = [NSString stringWithFormat:@"发布时间：%@",model.createdtime];
    _modifyTimeLab.text = [NSString stringWithFormat:@"最后修改时间：%@",model.modifyTime];
    
    _statusLab.text = [model getOccurAdsTypeName];
    _statusLab.textColor = model.statusLabColor;
    
    NSArray* btnTitles = [model getOccurAdsType] == OccurAdsTypeTypeOnline?
      @[@"编辑",@"下架"]:
      @[@"补充并上架",@"编辑"];
    for (int i=0; i<2; i++) {
        UIButton* btn = _statusBtns[i];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize(12);
        [btn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    }
    UIButton* firstBtn = _statusBtns.firstObject;
    firstBtn.hidden = [model getOccurAdsType]==OccurAdsTypeTypeOnline?YES:NO;
    
    UIButton* lastBtn = _statusBtns.lastObject;
    lastBtn.tag = [model getOccurAdsType]==OccurAdsTypeTypeOnline?EnumActionTag2:EnumActionTag1;
    
    [self layoutTypeLabelWithModel:model];
    [self layoutPayMethodViewsWithModel:model];
}
- (void)layoutTypeLabelWithModel:(ModifyAdsModel*)model{
    TransactionAmountType amt = [model.amountType intValue];
    _typeLab.text = [NSString stringWithFormat:@"    单笔%@ %@  ",amt==TransactionAmountTypeLimit? @"限额":@"固额",amt==TransactionAmountTypeLimit? [NSString stringWithFormat:@"%@ - %@",model.limitMinAmount,model.limitMaxAmount]:model.fixedAmount];

    if (amt == TransactionAmountTypeLimit) {
        self.typeImg.image = kIMG(@"xc_x");
    }else{
        self.typeImg.image = kIMG(@"xc_g");
    }
    _typeLab.width = _typeLab.width + 6;
}
- (void)layoutPayMethodViewsWithModel:(ModifyAdsModel*)model{
    _payIvs = [NSMutableArray array];
    
    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saledLab);
        make.height.equalTo(self.saledLab);
        make.trailing.equalTo(@-15);
    }];
    
    
    _payMethodLab = [[UILabel alloc]init];
    _payMethodLab.text = @"";
    [self.payMethodView addSubview:_payMethodLab];
    
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x394368);
    
    _wIV = [[UIImageView alloc] init];
    _wIV.tag = EnumActionTag1;
    _wIV.image = [UIImage imageNamed:@"WEIXIXIRan"];
    [self.payMethodView addSubview:_wIV];
    
    _zIV = [[UIImageView alloc] init];
    _zIV.tag = EnumActionTag2;
    _zIV.image = [UIImage imageNamed:@"ZHIFUBAOXIRan"];
    [self.payMethodView addSubview:_zIV];
    
    _cIV = [[UIImageView alloc] init];
    _cIV.tag = EnumActionTag3;
    _cIV.image = [UIImage imageNamed:@"YINGHANGKAXIR"];
    [self.payMethodView addSubview:_cIV];
    
    if ([NSString isEmpty:model.paymentway]) {
        return;
    }
    NSArray  *paymentways = [NSArray array];
    if ([model.paymentway containsString:@","]) {
        paymentways = [model.paymentway componentsSeparatedByString:@","];
    }else{
        paymentways = @[model.paymentway];
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
    if (_payIvs.count ==1) {
        [_payIvs.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.payMethodView.mas_right); make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
    }
    else{
        [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
        
        [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
    }
    UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
        make.right.equalTo(firstIv.mas_left).offset(-5);
    }];
}
@end
