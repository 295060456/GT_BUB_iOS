//
//  BuyBubDetailTimeCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyBubDetailTimeCell.h"
#import "BuyBubDetailModel.h"

@interface BuyBubDetailTimeCell ()
@property (nonatomic, strong) UILabel  *la2;
@property (nonatomic ,assign) NSInteger time;
@property (nonatomic ,copy)   DataBlock block;
@property (nonatomic ,strong) NSTimer *myTime;
@property (nonatomic ,strong) BuyBubDetailModel* mo;
@end


@implementation BuyBubDetailTimeCell

+(instancetype)cellWith:(UITableView*)tabelView{
    BuyBubDetailTimeCell *cell = (BuyBubDetailTimeCell *)[tabelView dequeueReusableCellWithIdentifier:@"BuyBubDetailTimeCell"];
    if (!cell) {
        cell = [[BuyBubDetailTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuyBubDetailTimeCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 10*SCALING_RATIO)];
        lin1.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:lin1];
        
        
        UILabel *la1 = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 10*SCALING_RATIO, 200*SCALING_RATIO, 40*SCALING_RATIO)];
        la1.textColor = HEXCOLOR(0x333333);
        la1.font = kFontSize(13*SCALING_RATIO);
        la1.text = @"请在付款期限内向卖方转账";
        [self.contentView addSubview:la1];
        
        
        
        self.la2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 115*SCALING_RATIO, 10*SCALING_RATIO, 100*SCALING_RATIO, 40*SCALING_RATIO)];
        self.la2.textColor = HEXCOLOR(0xff9238);
        self.la2.textAlignment = NSTextAlignmentRight;
        self.la2.font = kFontSize(15*SCALING_RATIO);
        [self.contentView addSubview:self.la2];
        
        UIView *lin2 = [[UIView alloc] initWithFrame:CGRectMake(0, 50*SCALING_RATIO, MAINSCREEN_WIDTH, 10*SCALING_RATIO)];
        lin2.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:lin2];
    }
    return self;
}

-(void)timeReloadWeithTimeModel:(id)mo actionBlock:(DataBlock)block{
    self.block = block;
    self.mo = mo;
    NSString *ti = self.mo.myTime;
    if (ti) {
        self.time = [ti integerValue];
        if (self.time > 0) {
            self.la2.text = [NSString getMMSSFromSS:self.time];
            [self starTime];
        }else{
            self.la2.text = @"00:00";
        }
    }else{
        self.la2.text = @"";
    }
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
    self.time --;
    if (self.time<0) {
        self.mo.myTime = @"0";
        [self stopTime];
        [self reloaData];
        self.la2.text = @"00:00";
    }else{
        self.la2.text = [NSString getMMSSFromSS:self.time];
        self.mo.myTime = [NSString stringWithFormat:@"%ld",self.time];
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
