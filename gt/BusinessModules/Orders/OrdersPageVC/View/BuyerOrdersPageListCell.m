//
//  BuyerOrdersPageListCell.m
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.

#import "BuyerOrdersPageListCell.h"
#import "OrdersPageModel.h"
#import "OrderDetailModel.h"

@interface BuyerOrdersPageListCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)UIButton *statusBtn;
@property (nonatomic, strong)UIButton *leftStatusBtn;
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

@implementation BuyerOrdersPageListCell

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
    _typeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@21);
        
    }];
    _vipIV = [[UIImageView alloc]init];
    [self.contentView addSubview:_vipIV];
    
    _line1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _payMethodLab = [[UILabel alloc]init];
    [self.contentView addSubview:_payMethodLab];
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.line1.mas_bottom).offset(10);
        make.height.equalTo(@21);
    }];
    
    _distributeTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_distributeTimeLab];
    [_distributeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.payMethodLab.mas_bottom).offset(9);
        make.height.equalTo(self.payMethodLab);
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab);
        make.height.equalTo(self.typeLab);
        make.trailing.equalTo(@-22);
    }];
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.leading.equalTo(self.typeLab);
        make.trailing.equalTo(@-22);
        make.top.equalTo(self.payMethodLab);
        make.height.equalTo(self.payMethodLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.trailing.equalTo(@-22); make.top.equalTo(self.distributeTimeLab);
        make.height.equalTo(self.distributeTimeLab);
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _typeLab.textAlignment = NSTextAlignmentLeft;
    _typeLab.font = [UIFont boldSystemFontOfSize:15];
    _typeLab.textColor = HEXCOLOR(0x333333);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font =kFontSize(15);
    //layoutSubviews set prior richModel reset
    //    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    
    _balanceLab.textAlignment = NSTextAlignmentRight;
//    _balanceLab.font = kFontSize(13);
//    _balanceLab.textColor = HEXCOLOR(0x394368);
    
    _saledLab.textAlignment = NSTextAlignmentRight;
//    _saledLab.font = kFontSize(13);
//    _saledLab.textColor = HEXCOLOR(0x394368);
    
    
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(15);
//    _payMethodLab.textColor = HEXCOLOR(0x666666);
    
    _distributeTimeLab.textAlignment = NSTextAlignmentLeft;
    _distributeTimeLab.font = kFontSize(14);
    _distributeTimeLab.textColor = HEXCOLOR(0x666666);
}

+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"BuyerOrdersPageListCell";
    BuyerOrdersPageListCell *cell = (BuyerOrdersPageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BuyerOrdersPageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(OrderDetailModel*)model{
    return 116;
}

- (void)richElementsInCellWithModel:(OrderDetailModel*)model{
    _model = model;
    OrderType type =  [model getTransactionOrderType];
    
    _statusLab.text = [model getTransactionOrderTypeTitle];
    
    switch (type) {
        case BuyerOrderTypeNotYetPay:
        {
            _statusLab.textColor = HEXCOLOR(0xd02a2a);
        }
            break;
        case BuyerOrderTypeHadPaidWaitDistribute:
        {
            _statusLab.textColor = HEXCOLOR(0x4c7fff);
        }
            break;
        case BuyerOrderTypeAppealing:
        {
            _statusLab.textColor = HEXCOLOR(0xd02a2a);
        }
            break;
        default:
        {
            _statusLab.textColor =  HEXCOLOR(0x8c96a5);
        }
            break;
    }
    [self layoutTypeLabelWithModel:model];
    
    _payMethodLab.text = [model getOccurOrderTypeTitle];
    _payMethodLab.textColor = [model getOccurOrderType]== OccurOrderTypeBuy?HEXCOLOR(0xff2525):HEXCOLOR(0x00c6b0);
    
    _distributeTimeLab.text = [NSString stringWithFormat:@"%@",model.createdTime];
    
    _balanceLab.attributedText = [NSString attributedStringWithString:@"" stringColor:kClearColor stringFont:kFontSize(12) subString:[NSString stringWithFormat:@"数量：%.0f",[model.number floatValue]] subStringColor:HEXCOLOR(0x394368) subStringFont:kFontSize(14) numInSubColor:HEXCOLOR(0x394368) numInSubFont:kFontSize(15)];
    
    _saledLab.attributedText = [NSString attributedStringWithString:@"" stringColor:kClearColor stringFont:kFontSize(12) subString:[NSString stringWithFormat:@"共计：%.0f CNY",[model.orderAmount floatValue]] subStringColor:HEXCOLOR(0x394368) subStringFont:kFontSize(14) numInSubColor:HEXCOLOR(0x394368) numInSubFont:kFontSize(15)];
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_model);
    }
}

- (void)layoutTypeLabelWithModel:(OrderDetailModel*)model{
    _typeLab.text = [NSString stringWithFormat:@"%@",model.sellerName];
    //[NSString getAnonymousString:model.sellerName]
    CGFloat typeStringWidth =  [NSString getTextWidth:_typeLab.text withFontSize:[UIFont boldSystemFontOfSize:15] withHeight:21];
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
@end
