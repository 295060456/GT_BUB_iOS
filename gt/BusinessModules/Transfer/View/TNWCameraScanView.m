//
//  TNWCameraScanView.m
//  OTC
//
//  Created by David on 2018/11/28.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "TNWCameraScanView.h"
@interface TNWCameraScanView() {
    NSTimer *timer;
    CGRect scanRect;
}
@property (nonatomic,assign)CGFloat sceenHeight;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic, assign)CGFloat scanTime;
@end


@implementation TNWCameraScanView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    // 清空背景色，否则为黑 s
    _sceenHeight =self.frame.size.height;
    _height = 200;
    // 宽高200的正方形 _lineWidth = 2;
    // 扫描框4个脚的宽度
    _lineColor = [UIColor greenColor];
    // 扫描框4个脚的颜色
    _scanTime = 3;
    //扫描线的时间间隔设置
    [self scanLineMove];
    //定时，多少秒扫描线刷新一次
    timer = [NSTimer scheduledTimerWithTimeInterval:_scanTime target:self selector:@selector(scanLineMove) userInfo:nil repeats:YES];
        
    } return self;
    
}
- (void)scanLineMove{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH-_height)/2, (_sceenHeight-_height)/2, _height, 1)];
        line.backgroundColor = [UIColor greenColor]; [self addSubview:line];
    WS(weakSelf);
        [UIView animateWithDuration:_scanTime animations:^{
        line.frame = CGRectMake((MAINSCREEN_WIDTH-weakSelf.height)/2, (weakSelf.sceenHeight+weakSelf.height)/2, weakSelf.height, 0.5); } completion:^(BOOL finished) {
        [line removeFromSuperview];
        
    }];
        
}
-(void)drawRect:(CGRect)rect{
    CGFloat bottomHeight = (_sceenHeight-_height)/2;
    CGFloat leftWidth = (MAINSCREEN_WIDTH-_height)/2;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
        //设置4个方向的灰度值，透明度为0.5，可自行调整。
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
    CGContextFillRect(ctx, CGRectMake(0, 0, MAINSCREEN_WIDTH, bottomHeight));
    CGContextStrokePath(ctx);
    CGContextFillRect(ctx, CGRectMake(0,bottomHeight, leftWidth, _height));
    CGContextStrokePath(ctx);
    CGContextFillRect(ctx, CGRectMake((MAINSCREEN_WIDTH+_height)/2, bottomHeight, leftWidth, _height));
    CGContextStrokePath(ctx);
    CGContextFillRect(ctx, CGRectMake(0,(_sceenHeight+_height)/2, MAINSCREEN_WIDTH, bottomHeight));
    CGContextStrokePath(ctx);
        //扫描框4个脚的设置
    CGContextSetLineWidth(ctx, _lineWidth); CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
        //左上角
    CGContextMoveToPoint(ctx, leftWidth, bottomHeight+30); CGContextAddLineToPoint(ctx, leftWidth, bottomHeight); CGContextAddLineToPoint(ctx, leftWidth+30, bottomHeight); CGContextStrokePath(ctx);
        //右上角
    CGContextMoveToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2-30, bottomHeight);
    CGContextAddLineToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2, bottomHeight);
    CGContextAddLineToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2, bottomHeight+30);
    CGContextStrokePath(ctx);
        //左下角
    CGContextMoveToPoint(ctx, leftWidth, (_sceenHeight+_height)/2-30);
    CGContextAddLineToPoint(ctx, leftWidth, (_sceenHeight+_height)/2);
    CGContextAddLineToPoint(ctx, leftWidth+30, (_sceenHeight+_height)/2); CGContextStrokePath(ctx);
        //右下角
    CGContextMoveToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2-30, (_sceenHeight+_height)/2); CGContextAddLineToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2, (_sceenHeight+_height)/2);
    CGContextAddLineToPoint(ctx, (MAINSCREEN_WIDTH+_height)/2, (_sceenHeight+_height)/2-30);
    CGContextStrokePath(ctx);
        //设置扫描框4个边的颜色和线框。
        //CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        // CGContextSet_lineWidth(ctx, 1);
        // CGContextAddRect(ctx, CGRectMake(leftWidth, bottomHeight, height, height));
        // CGContextStrokePath(ctx);
        scanRect = CGRectMake(leftWidth, bottomHeight, _height, _height);
        
    }
- (void)dealloc{
            //清除计时器
    [timer invalidate]; timer = nil;
    
}
@end
