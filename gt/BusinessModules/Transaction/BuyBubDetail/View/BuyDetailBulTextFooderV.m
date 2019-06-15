//
//  BuyDetailBulTextFooderV.m
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailBulTextFooderV.h"

@implementation BuyDetailBulTextFooderV

-(instancetype)initWithString:(NSString*)string{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 200*SCALING_RATIO);
      
        
        UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALING_RATIO,10*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 180*SCALING_RATIO)];
        titleLa.font = kFontSize(12*SCALING_RATIO);
        titleLa.textColor = HEXCOLOR(0x4c7fff);
        titleLa.numberOfLines = 0;
        titleLa.textAlignment = NSTextAlignmentCenter;
        titleLa.text = string;
        [self addSubview:titleLa];
    } return self;
}

@end
