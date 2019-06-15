//
//  OtherFogetGetPwCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OtherFogetGetPwCell.h"

@implementation OtherFogetGetPwCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 0, MAINSCREEN_WIDTH /2, 57*SCALING_RATIO)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.textColor = HEXCOLOR(0x333333);
        self.dateLabel.font = kFontSize(15*SCALING_RATIO);
        [self.contentView addSubview:self.dateLabel];
        UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 57*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 1)];
        lin.backgroundColor = HEXCOLOR(0xdddddd);
        [self.contentView addSubview:lin];
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 36*SCALING_RATIO,24*SCALING_RATIO , 13*SCALING_RATIO, 13*SCALING_RATIO)];
        im.image = kIMG(@"rietherLaftO");
        [self.contentView addSubview:im];
    }
    return self;
}

@end
