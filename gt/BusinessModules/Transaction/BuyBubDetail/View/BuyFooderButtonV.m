//
//  BuyFooderButtonV.m
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyFooderButtonV.h"

@interface BuyFooderButtonV ()
@property (nonatomic ,copy) DataBlock bl;
@end


@implementation BuyFooderButtonV

-(instancetype)initWithActionBlock:(DataBlock)block{
    self = [super init];
    if (self) {
        self.bl = block;
        self.backgroundColor = kWhiteColor;
    } return self;
}

-(void)addButtonViewWith:(NSArray* _Nullable)ar{
    NSArray * ars = self.subviews;
    for (UIView *v in ars) {
        [v removeFromSuperview];
    }
    if (ar) {
        [self addView:ar];
    }
}

-(void)addView:(NSArray*)ar{
    NSInteger coun = ar.count;
    if (coun == 0) {
        return;
    }
    if (coun == 1) {
        UIView *v = [self noeButtom:YES withTitelS:ar[0]];
        [self addSubview:v];
    }else{ //
        UIView *v1 = [self noeButtom:NO withTitelS:ar[0]];
        [self addSubview:v1];
        if (coun == 2) {
            UIButton *bu = [self creatButtonWithTitle:ar[1] setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:4*SCALING_RATIO borderWidth:0 borderColor:0 action:@selector(buttomTapAction:)];
            bu.frame = CGRectMake(MAINSCREEN_WIDTH - 278*SCALING_RATIO - 15 *SCALING_RATIO, 7*SCALING_RATIO, 278*SCALING_RATIO, 42*SCALING_RATIO);
            [self addSubview:bu];
        }else{
            UIButton *bu = [self creatButtonWithTitle:ar[1] setTitleColor:HEXCOLOR(0x4c7fff) setImage:nil backgroundColor:kWhiteColor cornerRadius:4*SCALING_RATIO borderWidth:1 borderColor:HEXCOLOR(0x4c7fff) action:@selector(buttomTapAction:)];
            bu.frame = CGRectMake(83*SCALING_RATIO, 7*SCALING_RATIO, 108*SCALING_RATIO, 42*SCALING_RATIO);
            [self addSubview:bu];
            
            UIButton *bu1 = [self creatButtonWithTitle:ar[2] setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:4*SCALING_RATIO borderWidth:0 borderColor:0 action:@selector(buttomTapAction:)];
            bu1.frame = CGRectMake(MAINSCREEN_WIDTH - 154*SCALING_RATIO - 15 *SCALING_RATIO, 7*SCALING_RATIO, 154*SCALING_RATIO, 42*SCALING_RATIO);
            [self addSubview:bu1];
        }
    }
}

-(UIView*)noeButtom:(BOOL)noe withTitelS:(NSString*)t{
    
    UIView *tapV = [[UIView alloc] init];
    UIImageView *im = [[UIImageView alloc]init];
    UILabel *titleLa = [[UILabel alloc] init];
    if (noe) {
        tapV.frame = CGRectMake(MAINSCREEN_WIDTH/2-60*SCALING_RATIO, 0, 120*SCALING_RATIO, 60*SCALING_RATIO);
        im.frame = CGRectMake(18*SCALING_RATIO, 18*SCALING_RATIO, 23*SCALING_RATIO, 20*SCALING_RATIO);
        titleLa.frame = CGRectMake(46*SCALING_RATIO, 21*SCALING_RATIO, 120*SCALING_RATIO, 16*SCALING_RATIO);
        titleLa.font = kFontSize(15*SCALING_RATIO);
    }else{
        tapV.frame = CGRectMake(0, 0, 80*SCALING_RATIO, 55*SCALING_RATIO);
        im.frame = CGRectMake(29*SCALING_RATIO, 9*SCALING_RATIO, 23*SCALING_RATIO, 20*SCALING_RATIO);
        titleLa.frame = CGRectMake(18*SCALING_RATIO, 31*SCALING_RATIO, 60*SCALING_RATIO, 16*SCALING_RATIO);
        titleLa.font = kFontSize(12*SCALING_RATIO);
    }
    im.userInteractionEnabled = YES;
    [tapV addSubview:im];
    im.image = kIMG(@"contactSellerXi");
    titleLa.textColor = HEXCOLOR(0x4c7fff);
    titleLa.text = t;
    titleLa.userInteractionEnabled = YES;
    [tapV addSubview:titleLa];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactOtherSideS)];
    [tapV addGestureRecognizer:ta];
    return tapV;
}

-(void)buttomTapAction:(UIButton*)btn{
    if (self.bl) {
        self.bl(btn.titleLabel.text);
    }
}
-(void)contactOtherSideS{
    if (self.bl) {
        self.bl(@"lianXi");
    }
}

@end
