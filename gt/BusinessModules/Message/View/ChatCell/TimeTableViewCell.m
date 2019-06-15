//
//  TimeTableViewCell.m
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

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
        
        self.timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 17)];
        self.timeLb.text = @"2018-10-12 13:08:02";
        self.timeLb.font = [UIFont systemFontOfSize:12];
        self.timeLb.textAlignment = NSTextAlignmentCenter;
        self.timeLb.textColor = COLOR_RGB(153, 153, 153, 1);
        [self addSubview:self.timeLb];
        
    }
    return self;
}

@end
