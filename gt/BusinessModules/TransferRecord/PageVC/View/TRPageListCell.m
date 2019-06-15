//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "TRPageListCell.h"
#import "TRPageModel.h"
@interface TRPageListCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIButton *adIdBtn;


@property (nonatomic, strong) UILabel *statusLab;


@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) id modle;
@end

@implementation TRPageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    _adIdBtn = [[UIButton alloc]init];
    [self.contentView addSubview:_adIdBtn];
    [_adIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(22);
       make.top.equalTo(self.contentView).offset(15);
        make.width.equalTo(@180);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.adIdBtn);
        make.trailing.equalTo(@-22);
    }];
    
   
    
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdBtn.userInteractionEnabled = NO;
    _adIdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _adIdBtn.titleLabel.numberOfLines = 0;
    
    _statusLab.textAlignment = NSTextAlignmentRight;
//    _statusLab.font = [UIFont boldSystemFontOfSize:17];
    _statusLab.numberOfLines = 0;
//    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"TRPageListCell";
    TRPageListCell *cell = (TRPageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TRPageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 81;
}

- (void)richElementsInCellWithModel:(TRPageData*)model{
    _modle = model;
    
    NSString* address = @"";
    NSString* imageStr = @"";
    
    address = [model getTransferRecordAdress];
    imageStr = [model getTransferRecordImage];
    
//    _statusLab.text  = [model getTransferRecordNum];
//    _statusLab.textColor = [model getTransferRecordNumColor];
    
    [_statusLab setAttributedText:[NSString attributedStringWithString:[model getTransferRecordNum] stringColor:[model getTransferRecordNumColor] stringFont:kFontSize(17) subString:[NSString stringWithFormat:@"\n\n\n%@",[NSString stringWithFormat:@"手续费 %@ BUB",model.poundage]]  subStringColor:HEXCOLOR(0x777777) subStringFont:kFontSize(14)]];
    
    
    [_adIdBtn setAttributedTitle:[NSString attributedStringWithString:address stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(15) subString:[NSString stringWithFormat:@"\n\n%@",model.transferTime]  subStringColor:HEXCOLOR(0x666666) subStringFont:kFontSize(14)] forState:UIControlStateNormal];
    [_adIdBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [_adIdBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:14];
}


@end
