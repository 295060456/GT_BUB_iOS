//
//  BuyDetailSellFinishFoodV.m
//  gt
//
//  Created by 鱼饼 on 2019/6/3.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailSellFinishFoodV.h"

@implementation BuyDetailSellFinishFoodV

-(instancetype)initWithDataArrary:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 13*SCALING_RATIO, MAINSCREEN_WIDTH - 30*SCALING_RATIO, 1)];
        linV.backgroundColor = HEXCOLOR(0xf0f1f3);
        [self addSubview:linV];
        NSArray *allKey = dic.allKeys;
        NSArray *allValu = dic.allValues;
        for (int i = 0 ; i< allKey.count; i++) {
            UILabel *la= [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 30*SCALING_RATIO + 25*SCALING_RATIO*i , MAINSCREEN_WIDTH - 30*SCALING_RATIO, 14*SCALING_RATIO)];
            [self addSubview:la];
            la.font = kFontSize(13*SCALING_RATIO);
            NSString *str = [NSString stringWithFormat:@"%@  %@",allKey[i],allValu[i]];
            NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                    value:HEXCOLOR(0x333333)
                                    range:[str rangeOfString:str]];
            [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                    value:HEXCOLOR(0x9a9a9a)
                                    range:[str rangeOfString:allKey[i]]];
            la.attributedText = attrDescribeStr;
        }
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 60*SCALING_RATIO + 25*SCALING_RATIO*allKey.count);
        
    } return self;
}

@end
