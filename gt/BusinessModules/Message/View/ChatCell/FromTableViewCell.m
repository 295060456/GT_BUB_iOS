//
//  FromTableViewCell.m
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
//

#import "FromTableViewCell.h"

@implementation FromTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16 * SCALING_RATIO, 5, 40 * SCALING_RATIO, 40 * SCALING_RATIO)];
//        self.iconImgView.layer.cornerRadius = 20 * SCALING_RATIO;
//        self.iconImgView.layer.masksToBounds = YES;
//        self.iconImgView.backgroundColor = [UIColor redColor];
//        [self addSubview:self.iconImgView];
//        
//        self.msgTV = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImgView.frame) + 8 * SCALING_RATIO, 5, MAINSCREEN_WIDTH - 40 * SCALING_RATIO - 16* SCALING_RATIO - 56 * SCALING_RATIO, 63)];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.msgTV.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.msgTV.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.msgTV.text = @"不好意思,订单只能取消了,很抱歉.";
//        self.msgTV.layer.mask = maskLayer;
//        self.msgTV.editable = NO;
//        self.msgTV.scrollEnabled = NO;
//        [self addSubview:self.msgTV];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
