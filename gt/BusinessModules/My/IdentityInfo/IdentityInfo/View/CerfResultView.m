//
//  CerfResultView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/21.
//  Copyright © 2019 GT. All rights reserved.
//

#import "CerfResultView.h"

@interface CerfResultView ()
@property (nonatomic ,copy) DataBlock block;
@property (nonatomic ,assign) CerfResultViewType myType;
@end

@implementation CerfResultView



-(instancetype)initWithType:(CerfResultViewType)type block:(DataBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
        self.myType = type;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UIView *witV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 291*SCALING_RATIO, 308*SCALING_RATIO)];
        witV.layer.cornerRadius = 6*SCALING_RATIO;
        witV.backgroundColor = kWhiteColor;
        [self addSubview:witV];
        witV.center = self.center;
        
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 291*SCALING_RATIO, 140*SCALING_RATIO)];
        [witV addSubview:im];
        NSString *imS = @"invalidNameFileX";
        NSString *titleS = @"实名认证失败";
        NSString *detalS = @"上传照片不清晰或者上传照片错误";
        if (type == ResultViewSuccess) {
            imS = @"invalidNameSXi";
            titleS = @"实名认证成功";
            detalS = @"系统已经成功审核您的实名认证信息";
        }else if (type == ResultViewTomeOut){
            imS = @"invalidNameCSX";
            titleS = @"系统审核超时";
            detalS = @"系统审核超时，请重新提交审核";
        }
        im.image = kIMG(imS);
        
        UILabel *noticeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 161*SCALING_RATIO, 291*SCALING_RATIO, 21*SCALING_RATIO)];
        [witV addSubview:noticeLable];
        noticeLable.textColor = HEXCOLOR(0x394050);
        noticeLable.textAlignment = NSTextAlignmentCenter;
        noticeLable.font = [UIFont systemFontOfSize:20*SCALING_RATIO];
        noticeLable.text = titleS;
        
        UILabel *noticeLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 199*SCALING_RATIO, 291*SCALING_RATIO, 14*SCALING_RATIO)];
        [witV addSubview:noticeLable1];
        noticeLable1.textColor = HEXCOLOR(0x394050);
        noticeLable1.textAlignment = NSTextAlignmentCenter;
        noticeLable1.font = [UIFont systemFontOfSize:14*SCALING_RATIO];
        noticeLable1.text = detalS;
        UIButton *bu = [self creatButtonWithTitle:@"确定" setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:6 borderWidth:0 borderColor:nil action:@selector(suerAction)];
        [witV addSubview:bu];
        bu.frame = CGRectMake(20*SCALING_RATIO, 243*SCALING_RATIO, 251*SCALING_RATIO, 40*SCALING_RATIO);
        
    } return self;
}

-(void)suerAction{
    if (self.myType == ResultViewSuccess) {
        if (self.block) {
            self.block(@1);
        }
    }
    [self removeFromSuperview];
}

@end
