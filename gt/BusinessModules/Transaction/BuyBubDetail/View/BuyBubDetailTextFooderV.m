//
//  BuyBubDetailTextFooderV.m
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyBubDetailTextFooderV.h"
#import "BuyBubDetailModel.h"

@interface BuyBubDetailTextFooderV ()
@property (nonatomic ,copy)   DataBlock block;
@property (nonatomic ,strong) NSTimer *myTime;
@property (nonatomic ,strong) BuyBubDetailModel* mo;
@property (nonatomic ,strong) UILabel *titleLa2;
@property (nonatomic ,assign) NSInteger timeCount;
@end

@implementation BuyBubDetailTextFooderV

-(instancetype)initWithTimeString:(id)mo actionBlock:(DataBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 170*SCALING_RATIO);
        self.backgroundColor = kWhiteColor;
        self.block = block;
        self.mo = mo;
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 20*SCALING_RATIO, MAINSCREEN_WIDTH-40*SCALING_RATIO, 150*SCALING_RATIO)];
        mainView.backgroundColor = HEXCOLOR(0xf6f7f9);
        mainView.layer.cornerRadius = 4*SCALING_RATIO;
        [self addSubview:mainView];
        UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(131*SCALING_RATIO, 14*SCALING_RATIO, 100*SCALING_RATIO, 24*SCALING_RATIO)];
        titleLa.font = kFontSize(17*SCALING_RATIO);
        titleLa.textColor = HEXCOLOR(0x000000);
        titleLa.text = @"官方提醒";
        [mainView addSubview:titleLa];
        
        UILabel *titleLa1 = [[UILabel alloc] initWithFrame:CGRectMake(14*SCALING_RATIO, 39*SCALING_RATIO, 305*SCALING_RATIO, 50*SCALING_RATIO)];
        titleLa1.font = kFontSize(13*SCALING_RATIO);
        titleLa1.textColor = HEXCOLOR(0x333333);
        titleLa1.numberOfLines = 2;
        
        NSString *titleS = @"1、您可向卖家说明您的付款账号，让卖家确认您的身份，以加快卖家的放行速度；";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleS];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6.0*SCALING_RATIO];//设置行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleS.length)];
        titleLa1.attributedText = attributedString;
        
        [mainView addSubview:titleLa1];
        NSString * ti = self.mo.myTime;
        if (ti) {
            self.timeCount = [ti integerValue];
            if (self.timeCount > 0) {
                ti = [NSString getMMSSFromSS:self.timeCount];
                self.titleLa2 = [[UILabel alloc] initWithFrame:CGRectMake(14*SCALING_RATIO, 95*SCALING_RATIO, 305*SCALING_RATIO, 50*SCALING_RATIO)];
                self.titleLa2.font = kFontSize(13*SCALING_RATIO);
                self.titleLa2.numberOfLines = 2;
                self.titleLa2.attributedText = [self stringToString:ti];
                [mainView addSubview:self.titleLa2];
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
    self.timeCount --;
    if (self.timeCount<0) {
        self.mo.myTime = @"0";
        [self stopTime];
        [self reloaData];
        self.titleLa2.attributedText = [self stringToString:@"00:00"];
    }else{
        NSString *s = [NSString getMMSSFromSS:self.timeCount];
        self.titleLa2.attributedText = [self stringToString:s];
        self.mo.myTime = [NSString stringWithFormat:@"%ld",self.timeCount];
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

-(NSMutableAttributedString*)stringToString:(NSString*)st{
    NSString *str = [NSString stringWithFormat:@"2、若卖方  %@  时间内未放行，您可以发起申诉， 一经核实，系统会自动放行此次交易。",st];
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                            value:HEXCOLOR(0x333333)
                            range:[str rangeOfString:str]];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                            value:HEXCOLOR(0xff9238)
                            range:[str rangeOfString:st]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6.0*SCALING_RATIO];//设置行间距
    [attrDescribeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, st.length)];
    return attrDescribeStr;
    
}

@end
