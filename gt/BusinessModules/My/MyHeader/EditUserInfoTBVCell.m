//
//  EditUserInfoTBVCell.m
//  gt
//
//  Created by Administrator on 02/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "EditUserInfoTBVCell.h"

@implementation EditUserInfoTBVCell

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.textLabel.x = 0;
    self.textLabel.y = 20*SCALING_RATIO;
    self.detailTextLabel.x = 0;
    self.detailTextLabel.y = 45*SCALING_RATIO;
    [self setBorderWithView:self
                borderColor:COLOR_HEX(0x8c96a5, 0.5)
                borderWidth:0.5
                borderType:UIBorderSideTypeBottom];
}

@end
