//
//  AutoTableViewCell.m
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AutoTableViewCell.h"

@implementation AutoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        NSString *str = @"自动回复: 您好,大量供应AB币,拍下5分钟内自动发货.谢谢合作.";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(76, 127, 255, 1) range:NSMakeRange(0, 5)];

        self.autoTV = [[UITextView alloc] initWithFrame:CGRectMake(25, 5, 323 * SCALING_RATIO, 44)];
        self.autoTV.backgroundColor = [UIColor whiteColor];
        self.autoTV.editable = NO;
        self.autoTV.selectable = NO;
        self.autoTV.scrollEnabled = NO;
        self.autoTV.font = [UIFont systemFontOfSize:13];
        self.autoTV.attributedText = attrStr;
        self.autoTV.layer.cornerRadius = 5;
        self.autoTV.layer.masksToBounds = YES;
        [self addSubview:self.autoTV];
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
