//
//  BuyDetailTimeTextFooderV.m
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailTimeTextFooderV.h"
#import "BuyBubDetailModel.h"

@interface BuyDetailTimeTextFooderV ()
@property (nonatomic ,copy)   DataBlock block;
@property (nonatomic ,strong) NSTimer *myTime;
@property (nonatomic ,strong) UILabel *timeLa;
@property (nonatomic ,strong) BuyBubDetailModel* mo;
@property (nonatomic ,assign) NSInteger tim;
@end

@implementation BuyDetailTimeTextFooderV


-(instancetype)initWithTime:(id)mo anddetailString:(NSString*)detail actionBlock:(DataBlock)block{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 240*SCALING_RATIO);
        self.mo = mo;
        self.block = block;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 70*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 120*SCALING_RATIO)];
        v.backgroundColor = HEXCOLOR(0xf6f7f9);
        v.layer.cornerRadius = 4*SCALING_RATIO;
        [self addSubview:v];
        
       self.timeLa = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 17*SCALING_RATIO, MAINSCREEN_WIDTH - 80*SCALING_RATIO, 50*SCALING_RATIO)];
        self.timeLa.font = kFontSize(40*SCALING_RATIO);
        self.timeLa.textColor = HEXCOLOR(0xff9238);
        self.timeLa.textAlignment = NSTextAlignmentCenter;
        [v addSubview:self.timeLa];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 65*SCALING_RATIO, MAINSCREEN_WIDTH - 80*SCALING_RATIO, 50*SCALING_RATIO)];
        la.font = kFontSize(12*SCALING_RATIO);
        la.textColor = HEXCOLOR(0x4c7fff);
        la.textAlignment = NSTextAlignmentCenter;
        la.numberOfLines = 3;
        la.text = detail;
        [v addSubview:la];
        
        if (self.mo.myTime) {
            NSInteger ti = [self.mo.myTime integerValue];
            if (ti > 0) {
                self.tim = ti;
                self.timeLa.text =  [NSString getMMSSFromSS:self.tim];
                [self starTime];
            }
        }
    } return self;
}

-(void)starTime{
    [self stopTime];
    self.myTime = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(timerAction)
                                                 userInfo:nil
                                                  repeats:YES];
}

-(void)stopTime{
    if (self.myTime != nil){
        [self.myTime invalidate];
        self.myTime = nil;
    }
}
-(void)timerAction{
    self.tim --;
    if (self.tim<0) {
        self.mo.myTime = @"0";
        [self stopTime];
        [self reloaData];
        self.timeLa.text = @"00:00";
    }else{
        self.timeLa.text =  [NSString getMMSSFromSS:self.tim];
        self.mo.myTime = [NSString stringWithFormat:@"%ld",self.tim];
    }
}

-(void)reloaData{
    if (self.block) {
        self.block(nil);
    }
}
-(void)dealloc{
    [self stopTime];
}

@end
