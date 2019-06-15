//
//  BuyDetailTypeCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailTypeCell.h"



@interface BuyDetailTypeCell ()
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel  *titleLa;
@property (nonatomic, strong) UILabel *detailLa;
@property (nonatomic, strong) UIView  *buttomLinV;
@end


@implementation BuyDetailTypeCell

+(instancetype)cellWith:(UITableView*)tabelView{
    BuyDetailTypeCell *cell = (BuyDetailTypeCell *)[tabelView dequeueReusableCellWithIdentifier:@"BuyDetailTypeCell"];
    if (!cell) {
        cell = [[BuyDetailTypeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuyDetailTypeCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.typeImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.typeImage];
        
        self.titleLa = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLa];
        
        self.detailLa = [[UILabel alloc] init];
        self.detailLa.numberOfLines = 2;
        self.detailLa.textColor = HEXCOLOR(0x666666);
        self.detailLa.font = kFontSize(14*SCALING_RATIO);
        self.detailLa.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.detailLa];
        
        self.buttomLinV = [[UIView alloc] init];
        self.buttomLinV.backgroundColor = HEXCOLOR(0xf0f1f3);
        [self.contentView addSubview:self.buttomLinV];
    }
    return self;
}


-(void)setMyData:(BuyBubDetailModel *)myData{
    self.buttomLinV.frame = CGRectMake(15*SCALING_RATIO, myData.noeCellHi - 1.5, MAINSCREEN_WIDTH - 30*SCALING_RATIO, 1);
   
    self.typeImage.hidden = YES;
    self.detailLa.hidden = YES;
    
    if( !HandleStringIsNull(myData.titleImage) && !HandleStringIsNull(myData.detailString)){
        //    //  只有标题 没有图片 没有小标题
        self.titleLa.textColor = HEXCOLOR(0x333333);
        self.titleLa.text = @"只有标题 没有图片 没有小标题";
        self.titleLa.font = kFontSize(18*SCALING_RATIO);
        self.titleLa.frame = CGRectMake(15*SCALING_RATIO, 20*SCALING_RATIO, MAINSCREEN_WIDTH - 30*SCALING_RATIO, 19*SCALING_RATIO);
        self.titleLa.textAlignment = NSTextAlignmentCenter;
        self.titleLa.text = myData.titleString;
    }else{
        // 有标题有图片 没有 没有小标题
        NSString *titlS = myData.titleString;
        float  stringWi = [NSString textWidthWithStirng:titlS font:24*SCALING_RATIO hit:33*SCALING_RATIO];
        stringWi = stringWi + 10 * SCALING_RATIO + 35*SCALING_RATIO;
        self.typeImage.hidden = NO;
        float x = MAINSCREEN_WIDTH/2 - stringWi/2;
        if (x < 10*SCALING_RATIO) {
            x = 10*SCALING_RATIO;
        }
        self.typeImage.frame = CGRectMake(x, 25*SCALING_RATIO, 35*SCALING_RATIO, 35*SCALING_RATIO);
        self.typeImage.image = kIMG(myData.titleImage);
        
        self.titleLa.frame = CGRectMake(CGRectGetMaxX(self.typeImage.frame) + 10* SCALING_RATIO, 25*SCALING_RATIO, stringWi, 35* SCALING_RATIO);
        self.titleLa.textAlignment = NSTextAlignmentLeft;
        self.titleLa.text = titlS;
        self.titleLa.font = kFontSize(24*SCALING_RATIO);
        
        if (HandleStringIsNull(myData.detailString)) {   // 全有
            self.detailLa.hidden = NO;
            self.detailLa.frame = CGRectMake(15*SCALING_RATIO, 68*SCALING_RATIO, MAINSCREEN_WIDTH - 30*SCALING_RATIO, 40*SCALING_RATIO);
            self.detailLa.text = myData.detailString;
        }
    }
}



@end
