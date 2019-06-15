//
//  AppealProgresssHeaderView.m
//  gt
//
//  Created by 鱼饼 on 2019/4/29.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealProgresssHeaderView.h"
#import "AppealProgressModel.h"


@interface AppealProgresssHeaderView ()
@property (nonatomic, copy) DataTypeBlock block;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)NSInteger timeCount;

@property(nonatomic, strong)UILabel *timeLable;

@end

@implementation AppealProgresssHeaderView


-(instancetype)initWithAppealProgressData:(id)data BlockSuccess:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 200);
        self.block = block;
        AppealProgressModel *model = data;
        UIImageView *im = [[UIImageView alloc] init];
        [self addSubview:im];
        im.image = kIMG(@"invalidNameXi");
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.size.mas_equalTo(CGSizeMake(37, 37));
            make.left.mas_equalTo(MAINSCREEN_WIDTH/2-37-15);
        }];
        
        UILabel *typeLa = [[UILabel alloc] init];
        [self addSubview:typeLa];
        typeLa.font = [UIFont systemFontOfSize:24];
        typeLa.textColor =  HEXCOLOR(0x666666);
        typeLa.text = model.titelS;
        [typeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(im.mas_right).offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(25);
        }];
        
        
        
        UILabel *contentLa = [[UILabel alloc] init];
        [self addSubview:contentLa];
        contentLa.numberOfLines = 0;
        contentLa.font = kFontSize(14);
        contentLa.textColor =  HEXCOLOR(0x666666);
//        contentLa.backgroundColor = kRedColor;
//        contentLa.textAlignment = NSTextAlignmentCenter;
        contentLa.text = model.appealContentS;
        float wi = MAINSCREEN_WIDTH - 60;
        float heith = [NSString textHitWithStirng:model.appealContentS font:14 widt:wi] + 10;
        [contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(im.mas_bottom).offset(15);
            make.left.mas_equalTo(30);
            make.width.mas_equalTo(wi);
            make.height.mas_equalTo(heith);
        }];
        
        float hi =  (55 + 15 + 5 )*SCALING_RATIO + heith;
        if (model.appeal) {
            NSArray *ar = model.appeal[@"data"];
            if (ar && ar.count > 0) {
                     UILabel  *examineImageButton = [[UILabel alloc] init];
                    examineImageButton.userInteractionEnabled = YES;
                    [self addSubview:examineImageButton];
                    examineImageButton.textColor = [YBGeneralColor themeColor];
                    examineImageButton.font = kFontSize(15*SCALING_RATIO);
                    examineImageButton.text = @"点击查看买家转账证明";
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(examineImageAction)];
                    [examineImageButton addGestureRecognizer:tap];
                    hi = hi + 5*SCALING_RATIO;
                    examineImageButton.frame = CGRectMake(SCALING_RATIO*30, hi, 165*SCALING_RATIO, 30*SCALING_RATIO);
                   hi = hi + 30*SCALING_RATIO;
            }
        }
        
        if ([self judgeCreatTimeLable:model]) {
            if (model.actionTime && model.actionTime.length>1) {
                NSInteger newtTi = [self getNowTimeAndC];
                NSInteger lastT = [model.actionTime integerValue];
                if (lastT > newtTi) {
                    [self creatTimeLAble:[NSString stringWithFormat:@"%ld",lastT-newtTi] andTop:hi];
                    hi = hi + 100*SCALING_RATIO;
                }
            }
        }
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, hi + 10 * SCALING_RATIO);
    } return self;
}

-(NSInteger)getNowTimeAndC{ // 获取当前时间
    time_t t;
    t = time(NULL);
    NSInteger timeS = time(&t);
    return timeS;
}

-(BOOL)judgeCreatTimeLable:(AppealProgressModel*)model{
    BOOL bol = NO;
    
    if (!model.isAppealer) {//我是被申诉人时
        //            //仲裁中,,指已经发起了反申诉
        if ([model.status isEqualToString:@"4"]) {
           
        } else{
            if ([model.reason isEqualToString:@"2_B_1_5"]) {//已付款，但未在时间内点击确认付款
                
            }else if ([model.reason isEqualToString:@"1_B_1_2"] ){//卖家责任超时
               bol = YES;
                //                [self initCutDown]; 、、倒计时
            } else if ([model.reason isEqualToString:@"0_B_1_2"]){ //已付款 申诉 选择其他原因 ---- 倒计时
                bol = YES;
                //                [self initCutDown]; 、、倒计时
            }else if ([model.reason isEqualToString:@"1_S_1_2"]){//买家被申诉,,未付款却点击了"已付款"
               
            }else { // 其他
            }
        }
    } else {//我是申诉人
        
    }
    return bol;
}

-(void)creatTimeLAble:(NSString*)sec andTop:(float)top{
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2- 150*SCALING_RATIO, top + 20 *SCALING_RATIO, 300*SCALING_RATIO, 54*SCALING_RATIO)];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.timeLable.textColor = HEXCOLOR(0xff9238);
    self.timeLable.font = kFontSize(40*SCALING_RATIO);
    [self addSubview:self.timeLable];
    
    if (sec && sec.length > 0) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    [self distoryTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) timerAction
{
    self.timeCount--;
    NSString *title = [NSString timeWithSecond:self.timeCount];
    self.timeLable.text = title;

    if(self.timeCount < 0)
    {
        [self distoryTimer];
        self.timeLable.text = @"00:00";
    }
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)examineImageAction{
    if (self.block) {
        self.block(0, nil);
    }
}

@end
