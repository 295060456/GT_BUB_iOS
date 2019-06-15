//
//  MsgListTableViewCell.m
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//

#import "MsgListTableViewCell.h"

@implementation MsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(16 * SCALING_RATIO, 18 * SCALING_RATIO, 43 * SCALING_RATIO, 43 * SCALING_RATIO)];
        self.iconImg.layer.cornerRadius = 43 * SCALING_RATIO/2;
        self.iconImg.layer.masksToBounds = YES;
        self.iconImg.backgroundColor = [UIColor redColor];
        [self addSubview:self.iconImg];
        
        self.timeLb = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 268 * SCALING_RATIO, 19 * SCALING_RATIO, 100 * SCALING_RATIO, 17* SCALING_RATIO)];
        self.timeLb.text = @"2018.10.12 12:32";
        self.timeLb.font = [UIFont systemFontOfSize:12 * SCALING_RATIO];
        [self.timeLb sizeToFit];
        self.timeLb.width  = self.timeLb.width + 5;
        self.timeLb.x = MAINSCREEN_WIDTH -self.timeLb.width - 16 * SCALING_RATIO;
        self.timeLb.textColor = COLOR_RGB(102, 102, 102, 1);
        [self addSubview:self.timeLb];
        
        self.nickLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 14 * SCALING_RATIO, CGRectGetMinY(self.iconImg.frame), 100, 22 * SCALING_RATIO)];
        self.nickLb.text = @"防水层啊";
        self.nickLb.font = [UIFont systemFontOfSize:16 * SCALING_RATIO];
        [self addSubview:self.nickLb];
        
        self.msgLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 14 * SCALING_RATIO, CGRectGetMaxY(_nickLb.frame) + 6 * SCALING_RATIO, MAINSCREEN_WIDTH - CGRectGetMaxX(self.iconImg.frame) + 14 * SCALING_RATIO - CGRectGetWidth(self.timeLb.frame) - 16 * SCALING_RATIO, 17 * SCALING_RATIO)];
        self.msgLb.font = [UIFont systemFontOfSize:12];
        self.msgLb.text = @"不好意思,只能取消订单了,很抱歉哈哈哈哈哈哈哈";
        self.msgLb.textColor = COLOR_RGB(102, 102, 102, 1);
        [self addSubview:self.msgLb];
        
        self.numLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.msgLb.frame) + 20 * SCALING_RATIO, CGRectGetMinY(self.msgLb.frame), 17 * SCALING_RATIO, 17 * SCALING_RATIO)];
        self.numLb.backgroundColor = COLOR_RGB(76, 127, 255, 1);
        self.numLb.text = @"12";
        self.numLb.textColor = [UIColor whiteColor];
        self.numLb.textAlignment = NSTextAlignmentCenter;
        self.numLb.font = [UIFont systemFontOfSize:10 * SCALING_RATIO];
        self.numLb.layer.cornerRadius = 17 * SCALING_RATIO/2;
        self.numLb.layer.masksToBounds = YES;
        [self addSubview:self.numLb];
        
//        if ([self.numLb.text isEqualToString:@"0"]) {
//            self.numLb.alpha = 0;
//        }
        
        
        UIImageView * rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numLb.frame) + 5, CGRectGetMinY(self.msgLb.frame) - 3.3 * SCALING_RATIO, 24 * SCALING_RATIO, 24 * SCALING_RATIO)];
        rightImg.image = [UIImage imageNamed:@"Btn_right"];
        [self addSubview:rightImg];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImg.frame) + 18 * SCALING_RATIO, MAINSCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = COLOR_RGB(230, 230, 230, 1);
        [self addSubview:lineView];
    }
    return self;
}

@end
