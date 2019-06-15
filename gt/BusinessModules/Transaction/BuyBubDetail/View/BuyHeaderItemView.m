//
//  BuyHeaderItemView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyHeaderItemView.h"

@interface BuyHeaderItemView ()
@property (nonatomic, strong) UILabel *itemLa;
@property (nonatomic, strong) UIView  *lienView;

@end

@implementation BuyHeaderItemView
-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type WithString:(NSString*)string andBool:(BOOL)is{
    self = [super initWithFrame:frame];
    if (self) {
        self.lienView = [[UIView alloc] init];
        if (type == 0) {
            self.lienView.frame = CGRectMake(frame.size.width/2, 10*SCALING_RATIO, frame.size.width/2, 1*SCALING_RATIO);
        }else if (is){
                self.lienView.frame = CGRectMake(0, 10*SCALING_RATIO, frame.size.width/2, 1*SCALING_RATIO);
        }else{
            self.lienView.frame = CGRectMake(0, 10*SCALING_RATIO, frame.size.width, 1*SCALING_RATIO);
        }
        [self addSubview:self.lienView];
        self.itemLa = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-10*SCALING_RATIO, 0, 20*SCALING_RATIO, 20*SCALING_RATIO)];
        self.itemLa.textColor = kWhiteColor;
        self.itemLa.layer.masksToBounds = YES;
        self.itemLa.layer.cornerRadius = 10*SCALING_RATIO;
        [self addSubview:self.itemLa];
        self.itemLa.text = [NSString stringWithFormat:@"%ld",type +1];
        self.itemLa.textAlignment = NSTextAlignmentCenter;
        self.itemLa.font = kFontSize(14*SCALING_RATIO);
        
        self.buttomLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 27*SCALING_RATIO, frame.size.width, 15*SCALING_RATIO)];
        [self addSubview:self.buttomLa];
        self.buttomLa.textAlignment = NSTextAlignmentCenter;
        self.buttomLa.font = kFontSize(14*SCALING_RATIO);
//        self.buttomLa.textColor = HEXCOLOR(0x666666);
        self.buttomLa.text = string;
        
    } return self;
}

-(void)setIsChooseView:(BOOL)isChooseView{
    if (isChooseView) {
        self.lienView.backgroundColor = HEXCOLOR(0x4d89ee);
        self.itemLa.backgroundColor = HEXCOLOR(0x4d89ee);
        self.buttomLa.textColor = HEXCOLOR(0x666666);
    }else{
        self.lienView.backgroundColor = HEXCOLOR(0xdddddd);
        self.itemLa.backgroundColor = HEXCOLOR(0xdddddd);
        self.buttomLa.textColor = HEXCOLOR(0x9a9a9a);
    }
}


@end
