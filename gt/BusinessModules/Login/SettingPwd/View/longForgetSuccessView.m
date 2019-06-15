//
//  longForgetSuccessView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "longForgetSuccessView.h"

@interface longForgetSuccessView ()
@property (nonatomic, copy) DataTypeBlock block;
@property (nonatomic, assign) SuccessViewType myType;
@end


@implementation longForgetSuccessView

-(instancetype)initFogetGetPwViewWith:(SuccessViewType)type Bolck:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
        self.myType = type;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH,MAINSCREEN_HEIGHT);
        self.backgroundColor = COLOR_HEX(0x000000, 0.5);
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 291*SCALING_RATIO, 288*SCALING_RATIO)];
        [self addSubview:headerView];
        headerView.layer.cornerRadius = 8*SCALING_RATIO;
        headerView.backgroundColor = kWhiteColor;
        headerView.center = self.center;
        
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(103 *SCALING_RATIO ,20*SCALING_RATIO , 86*SCALING_RATIO, 76*SCALING_RATIO)];
        //        im.backgroundColor = kRedColor;
        im.image = kIMG(@"okSuccess");
        [headerView addSubview:im];
        
        
        UILabel *headerLa = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALING_RATIO, 104*SCALING_RATIO, 271*SCALING_RATIO, 23*SCALING_RATIO)];
        headerLa.backgroundColor = kWhiteColor;
        headerLa.textColor = HEXCOLOR(0x394050);
        headerLa.font = kFontSize(22);
        headerLa.textAlignment = NSTextAlignmentCenter;
        if (self.myType == successApplication) {
            headerLa.text = @"申请提交成功！";
        }else if (self.myType == successRegistered){
            headerLa.text = @"注册成功！";
        }
        
        [headerView addSubview:headerLa];
        
        
        UILabel *qx = [[UILabel alloc] initWithFrame:CGRectMake(17*SCALING_RATIO , 144*SCALING_RATIO, 262*SCALING_RATIO, 44*SCALING_RATIO)];
        qx.textColor = HEXCOLOR(0x394050);
        qx.numberOfLines = 0;
        qx.font = kFontSize(15);
        if (self.myType == successApplication) {
            qx.text = @"币友将会在7个工作日内审核完成，并将结果传送至您的信箱，请耐心等候。";
        }else if (self.myType == successRegistered){
            qx.text = @"币友建议绑定Google两步验证让您的账号更加安全。";
        }
        
        [headerView addSubview:qx];
        
        if (self.myType == successApplication) {
            UIButton *bu = [self creatButtonWithTitle:@"返回首页" setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:8 borderWidth:0 borderColor:nil action:@selector(bacAction)];
            [self addSubview:bu];
            bu.frame = CGRectMake(20*SCALING_RATIO , 223*SCALING_RATIO, 251*SCALING_RATIO, 40*SCALING_RATIO);
            [headerView addSubview:bu];
        }else if (self.myType == successRegistered){
            
            UIButton *bu1 = [self creatButtonWithTitle:@"暂不绑定" setTitleColor:HEXCOLOR(0x4c7fff) setImage:nil backgroundColor:nil cornerRadius:8 borderWidth:1 borderColor:HEXCOLOR(0x4c7fff) action:@selector(noBindingAction)];
            [self addSubview:bu1];
            bu1.frame = CGRectMake(20*SCALING_RATIO , 224*SCALING_RATIO, 118*SCALING_RATIO, 40*SCALING_RATIO);
            [headerView addSubview:bu1];
            
            
            UIButton *bu2 = [self creatButtonWithTitle:@"立即绑定" setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:8 borderWidth:0 borderColor:nil action:@selector(toBindingAction)];
            [self addSubview:bu2];
            bu2.frame = CGRectMake(153*SCALING_RATIO , 224*SCALING_RATIO, 118*SCALING_RATIO, 40*SCALING_RATIO);
            [headerView addSubview:bu2];
        }
        self.alpha = 0.1;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
    } return self;
}

-(void)bacAction{
    if (self.block) {
        self.block(1, nil);
    }
    [self removeSelf];
}

-(void)noBindingAction{
    if (self.block) {
        self.block(2, nil);
    }
    [self removeSelf];
}

-(void)toBindingAction{
    if (self.block) {
        self.block(3, nil);
    }
//    [self removeSelf];
}

-(void)removeSelf{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
