//
//  PromptTableViewCell.m
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
////提示

#import "PromptTableViewCell.h"

@implementation PromptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.promptLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 17)];
        self.promptLb.text = @"对方已成功下单,请及时放行";
        self.promptLb.font = [UIFont systemFontOfSize:13];
        self.promptLb.textAlignment = NSTextAlignmentCenter;
        self.promptLb.textColor = COLOR_RGB(153, 153, 153, 1);
        self.promptLb.backgroundColor = COLOR_RGB(233, 239, 255, 1);
        [self.promptLb sizeToFit];
        self.promptLb.frame = CGRectMake((MAINSCREEN_WIDTH - self.promptLb.width)/2, 0, self.promptLb.width, 20);
        [self addSubview:self.promptLb];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
