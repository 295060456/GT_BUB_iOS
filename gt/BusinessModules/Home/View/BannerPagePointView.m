//
//  BannerPageView.m
//  gt
//
//  Created by 鱼饼 on 2019/6/12.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BannerPagePointView.h"

#define kSlace ([[UIScreen mainScreen] bounds].size.width)/375.0f
#define pointWi (5.0*kSlace) // 点点的大小 // 间隔就是点点大小
#define choosePointWi (7.0*kSlace) // 选中点的大小

@interface BannerPagePointView ()
@property (nonatomic ,strong) UIColor *pointColor;
@property (nonatomic ,assign) PositionType position;
@property (nonatomic ,strong) NSMutableArray *pointArrary;
@property (nonatomic ,strong) UIView *maxPointView;
@end


@implementation BannerPagePointView
-(instancetype)initWithFrame:(CGRect)frame andPosition:(PositionType)position andPointColor:(UIColor*)pointColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointColor = pointColor;
        self.position = position;
    } return self;
}

-(UIView*)maxPointView{
    if (_maxPointView == nil) {
        _maxPointView = [[UIView alloc] init];
        _maxPointView.backgroundColor = self.pointColor;
        _maxPointView.layer.cornerRadius = pointWi/2.0f;
        [self addSubview:self.maxPointView];
    } return _maxPointView;
}

-(NSMutableArray*)pointArrary{
    if (_pointArrary == nil) {
        _pointArrary = [NSMutableArray array];
    } return _pointArrary;
}

-(void)setPointCount:(NSInteger)pointCount{
    if (self.pointArrary.count>0) {
        for (UIView *v in self.pointArrary) {
            [v removeFromSuperview];
        }
        [self.pointArrary removeAllObjects];
    }
    float wi = self.bounds.size.width;
    float allwi = pointWi *2* pointCount;
    for (NSInteger i=0 ; i< pointCount; i ++) {
        float x = pointWi *2*i;
        if (self.position == PositionCenter) {
            x = (wi - allwi)/2 + x;
        }else if (self.position == PositionRight){
            x= wi - (pointWi*2 *(pointCount-i));
        }
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(x, self.bounds.size.height/2-pointWi/2, pointWi, pointWi)];
        itemView.layer.cornerRadius = pointWi/2.0f;
        itemView.backgroundColor = self.pointColor;
        [self addSubview:itemView];
        [self.pointArrary addObject:itemView];
        if (i == 0) {
            self.maxPointView.frame = CGRectMake(x-(choosePointWi - pointWi)/2, self.bounds.size.height/2-pointWi/2, choosePointWi, pointWi);
        }
    }
}

-(void)setChoosePointCount:(NSInteger)choosePointCount{
    NSInteger coun = self.pointArrary.count;
    if (choosePointCount > coun-1) {
        choosePointCount = coun-1;
    }
    if (choosePointCount < 0 || self.pointArrary.count == 0 ) return;
    UIView *v = self.pointArrary[choosePointCount];
    self.maxPointView.center = v.center;
}

@end
