//
//  XcSSCellTableViewCell.m
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcSSCellTableViewCell.h"

@implementation XcSSCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSString *)data{
    self.textField.placeholder = data;
}

@end
