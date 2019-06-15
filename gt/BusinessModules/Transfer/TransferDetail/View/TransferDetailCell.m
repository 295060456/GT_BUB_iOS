//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//
#import "TransferDetailCell.h"
#import "ExchangeDetailModel.h"

@interface TransferDetailCell ()
@property (nonatomic, strong) NSMutableArray *btns;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* titleBtn;
@property(nonatomic,strong)UIView* bgView;
@end

@implementation TransferDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
    self.backgroundView = [[UIView alloc] init];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, 15+21)];
    _bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:_bgView];
    
    
    _btns = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.tag =  i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        
        //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
        //        [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.titleLabel.font = kFontSize(15);
    [bt0 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bt0.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    UIButton* bt1 =_btns[1];
    bt1.titleLabel.font = kFontSize(16);
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    bt1.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    bt1.titleLabel.numberOfLines = 0;
    
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:MAINSCREEN_WIDTH/2-48 leadSpacing:48 tailSpacing:48];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@11);
        make.height.mas_equalTo(@20);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    TransferDetailCell *cell = (TransferDetailCell *)[tabelView dequeueReusableCellWithIdentifier:@"TransferDetailCell"];
    if (!cell) {
        cell = [[TransferDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TransferDetailCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 11+[NSString getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:model.allValues[0] fontOfSize:16 boundingRectWithWidth:MAINSCREEN_WIDTH/2-48];
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    _bgView.height = [TransferDetailCell cellHeightWithModel:model];
    
    UIButton* bt0 =_btns[0];
    UIButton* bt1 =_btns[1];
    [bt0 setTitle:model.allKeys[0] forState:UIControlStateNormal];
    [bt1 setTitle:model.allValues[0] forState:UIControlStateNormal];
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_btns mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo([NSString getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:model.allValues[0] fontOfSize:16 boundingRectWithWidth:MAINSCREEN_WIDTH/2-48]);
    }];
    
}

@end
