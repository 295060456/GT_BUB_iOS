//
//  BuyHeaderView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyHeaderView.h"
#import "BuyHeaderItemView.h"

@interface BuyHeaderView ()
@property  (nonatomic ,strong) NSMutableArray *viewArr;
@end

@implementation BuyHeaderView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 75*SCALING_RATIO);
        self.viewArr  = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            BuyHeaderItemView *v = [[BuyHeaderItemView alloc] initWithFrame:CGRectMake(5*SCALING_RATIO + 90*SCALING_RATIO*i, 15*SCALING_RATIO, 90*SCALING_RATIO, 45*SCALING_RATIO) withType:i WithString:@"" andBool: i == 3? YES:NO];
            if (i== 0) {
                v.isChooseView = YES;
            }else{
                 v.isChooseView = NO;
            }
            v.hidden = YES;
            [self addSubview:v];
            [self.viewArr addObject:v];
        }
        UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(0, 65*SCALING_RATIO, MAINSCREEN_WIDTH, 10*SCALING_RATIO)];
        linV.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self addSubview:linV];
    } return self;
}

-(void)chooseItem:(NSInteger)chooseItem andTitelAR:(NSArray*)ar{
    for ( int i = 0 ; i< self.viewArr.count; i++) {
        BuyHeaderItemView *v = self.viewArr[i];
        v.hidden = NO;
        if (ar) {
            v.buttomLa.text = ar[i];
        }
        if (i> chooseItem-1 ) {
            v.isChooseView = NO;
        }else{
            v.isChooseView = YES;
        }
    }
}


@end
