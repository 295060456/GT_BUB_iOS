//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "TransactionCell.h"
#import "TransactionModel.h"
//#import "IdentityAuthVC.h"

@interface TransactionCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;
@property (nonatomic, strong) UIButton *userNameBtn;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView *typeImg;

@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *saledLab;

@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, strong) UILabel *distributeTimeLab;
@property (nonatomic, strong) UILabel *modifyTimeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UILabel *buyBtn;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) UILabel *payMethodLab;
@property (nonatomic, strong) UIImageView* zIV;
@property (nonatomic, strong) UIImageView* wIV;
@property (nonatomic, strong) UIImageView* cIV;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) NSMutableArray* payIvs;
@property (nonatomic, strong) NSMutableArray* statusBtns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id modle;
@end

@implementation TransactionCell

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
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@24);
    }];
    
    _userNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userNameBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_userNameBtn];
    [_userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIdLab.mas_right).offset(10);
        make.centerY.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
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
        make.top.equalTo(self.line1.mas_bottom).offset(15);
        make.height.equalTo(@17.3);
        //        make.width.equalTo(@190);
    }];
    
    _typeImg = UIImageView.new;
    [_typeLab addSubview:_typeImg];
    [_typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@1);
        make.centerY.equalTo(self.typeLab.mas_centerY).offset(0.2);
    }];
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab); make.top.equalTo(self.typeLab.mas_bottom).offset(11);
        make.height.equalTo(self.typeLab);
    }];
    
    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.balanceLab); make.top.equalTo(self.balanceLab.mas_bottom).offset(8);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-14);
    }];
    
    self.img = UIImageView.new;
    self.img.image = kIMG(@"xc_mb_right_arrow");
    [self.contentView addSubview:self.img];
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_modle);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentCenter;
    _adIdLab.font = [UIFont systemFontOfSize:14];;
    _adIdLab.textColor = HEXCOLOR(0xffffff);
    _adIdLab.layer.masksToBounds = YES;
    _adIdLab.layer.cornerRadius = 24/2;
    _adIdLab.backgroundColor = HEXCOLOR(0x4c7fff);
    
    _userNameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_userNameBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _userNameBtn.titleLabel.font = kFontMediumSize(15);
    _userNameBtn.titleLabel.numberOfLines = 1;
    [_userNameBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.font = kFontMediumSize(12);
    _typeLab.textColor = RGBCOLOR(255, 255, 255);
    _typeLab.backgroundColor = COLOR_RGB(76, 127, 255,.7);
    _typeLab.layer.masksToBounds = YES;
    _typeLab.layer.cornerRadius = 2;
    
    _balanceLab.textAlignment = NSTextAlignmentLeft;
    _balanceLab.font = kFontMediumSize(13);
    _balanceLab.textColor = RGBCOLOR(57, 57, 104);
    
    _saledLab.textAlignment = NSTextAlignmentLeft;
    _saledLab.font = kFontMediumSize(13);
    _saledLab.textColor = RGBCOLOR(57, 67, 104);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"TransactionCell";
    TransactionCell *cell = (TransactionCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TransactionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 150;
}

- (NSMutableAttributedString *) getAttributedString:(NSString *)text{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:@"|"];
    if (range.location == NSNotFound) {
        return AttributedStr;
    }
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:HEXCOLOR(0x8c96a5)
                          range:NSMakeRange(0, range.location-1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:RGBCOLOR(240, 241, 243)
                          range:NSMakeRange(range.location, 1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:HEXCOLOR(0x8c96a5)
                          range:NSMakeRange(range.location+1, text.length-range.location-1)];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:kFontMediumSize(13)
                          range:NSMakeRange(0, range.location-1)];
    [AttributedStr addAttribute:NSFontAttributeName
                               value:kFontMediumSize(10)
                               range:NSMakeRange(range.location, 1)];
    [AttributedStr addAttribute:NSFontAttributeName
                               value:kFontMediumSize(13)
                               range:NSMakeRange(range.location+1, text.length-range.location-1)];
    return AttributedStr;
}

- (void)richElementsInCellWithModel:(TransactionData*)model{
    _modle = model;
    
    NSString* userName = model.nickName!=nil? model.nickName: model.username !=nil ? model.username:@" ";
    
    [_userNameBtn setTitle:userName forState:UIControlStateNormal];
    //[NSString getAnonymousString:userName]
    [_userNameBtn setImage:[UIImage imageNamed:[model getPriorityImageName]] forState:UIControlStateNormal];
    [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    _adIdLab.text = [NSString stringWithFormat:@"%@",[userName substringToIndex:1]];
    
    
    _balanceLab.text = [NSString stringWithFormat:@"单价 %@",[model getRateName]];
    _saledLab.text = [NSString stringWithFormat:@"剩余数量 %@",model.balance];
    
    _statusLab.attributedText = [self getAttributedString:[NSString stringWithFormat:@"交易量 %@ | 成功率 %@", model.orderAllNumber,model.successRate]];//[NSString stringWithFormat:@"交易量 %@ | 成功率 %@", model.orderAllNumber,model.successRate];
    
    [self layoutTypeLabelWithModel:model];
    [self layoutPayMethodViewsWithModel:model];
    
//    [self layoutIfNeeded];
    
    __block CGFloat wi = [NSString textWidthWithStirng:_statusLab.text font:13 hit:15];
    
    wi =  MAINSCREEN_WIDTH - wi - 30 - 20 - 30;
    
    _userNameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [_userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIdLab.mas_right).offset(10);
        make.centerY.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.width.mas_equalTo(wi);
    }];
}

- (void)layoutTypeLabelWithModel:(TransactionData*)model{
    _typeLab.text = [model getTransactionAmountTypeName];
    _typeLab.width = _typeLab.width+6;
    
    if ([model getTransactionAmountType] == TransactionAmountTypeLimit) {
        self.typeImg.image = kIMG(@"xc_x");
    }else{
        self.typeImg.image = kIMG(@"xc_g");
    }
}

- (void)layoutPayMethodViewsWithModel:(TransactionData*)model{
    
    _payIvs = [NSMutableArray array];
    
    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    if (_buyBtn) {
        [_buyBtn removeFromSuperview];
    }
    
    _buyBtn = [[UILabel alloc]init];
    _buyBtn.numberOfLines = 0;
    _buyBtn.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_buyBtn];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saledLab);
        make.height.equalTo(self.saledLab);
        make.trailing.equalTo(@-32);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.buyBtn.mas_trailing).offset(2);
        make.centerY.equalTo(self.buyBtn.mas_centerY).offset(0);
    }];
    
    // 修改  原因 该页面显示的逻辑 和本用户没有任何关系  、、 只显示 发布者的 要求   XiRan 修改
    if ([model.isSeniorCertification isEqualToString:@"1"]
        &&[model.isIdNumber isEqualToString:@"1"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"卖家要求实名认证/高级验证"
                                                                                             attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium"
                                                                                                                                                size: 13.0f],
                                                                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:76.0f / 255.0f
                                                                                                                                                           green:127.0f / 255.0f
                                                                                                                                                            blue:1.0f                             alpha:1.0f],                      NSKernAttributeName: @(-0.0)
                                                                                                           }];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:57.0f / 255.0f
                                                       green:67.0f / 255.0f
                                                        blue:104.0f / 255.0f
                                                       alpha:1.0f]
                                 range:NSMakeRange(0, 4)];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:57.0f / 255.0f
                                                       green:67.0f / 255.0f
                                                        blue:104.0f / 255.0f
                                                       alpha:1.0f]
                                 range:NSMakeRange(8, 1)];
        _buyBtn.attributedText = attributedString;
    }else if ([model.isIdNumber isEqualToString:@"1"]){
        
        _buyBtn.attributedText = [NSString attributedStringWithString:@"卖家要求"
                                                          stringColor:HEXCOLOR(0x394368)
                                                           stringFont:kFontMediumSize(13)
                                                            subString:@"实名认证"
                                                       subStringColor:HEXCOLOR(0x4c7fff)
                                                        subStringFont:kFontMediumSize(13)];
    }else{
        
        _buyBtn.attributedText = [NSString attributedStringWithString:@"点击购买"
                                                          stringColor:HEXCOLOR(0x4c7fff)
                                                           stringFont:kFontMediumSize(13)
                                                            subString:@""
                                                       subStringColor:kClearColor
                                                        subStringFont:kFontSize(13)];
    }
    // Xiran

    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab);
        make.height.equalTo(self.typeLab);
        make.trailing.equalTo(@-12);
    }];
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
    
    _payMethodLab = [[UILabel alloc]init];
    _payMethodLab.text = @"";//支付方式：
    [self.payMethodView addSubview:_payMethodLab];
    
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x394368);
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
    
    if (_payIvs.count>0) {
        if (_payIvs.count == 1) {
            [_payIvs.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.payMethodView.mas_right);
                make.centerY.equalTo(self.payMethodView);
                make.width.mas_equalTo(@15);
                make.height.mas_equalTo(@15);
            }];
        }
        else{
            if (_payIvs.count>1) {
                [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                     withFixedSpacing:10
                                          leadSpacing:0
                                          tailSpacing:0];
                
                [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.payMethodView);
                    make.width.mas_equalTo(@15);
                    make.height.mas_equalTo(@15);
                }];
            }
        }
        
        UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
        [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.payMethodView);
            make.right.equalTo(firstIv.mas_left).offset(-5);
        }];
    }
}


@end
