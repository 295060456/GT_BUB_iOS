//
//  PostAppealComleteView.m
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAppealComleteView.h"


@interface PostAppealComleteView ()
@property (nonatomic, copy) DataTypeBlock block;
@property (nonatomic, strong) PostAppealCompleteModel *model;
@property (nonatomic, strong) UIImageView *topImageV;
@property (nonatomic, strong) UILabel *titelLable;
@property (nonatomic, strong) UILabel *orderIDLable;
@property (nonatomic ,strong) UILabel *contentStringLable;
@property (nonatomic, strong) UILabel *examineImageButton;
@property (nonatomic, strong) UIButton *contentButton;

@end

@implementation PostAppealComleteView


-(instancetype)initWithBlockSuccess:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -VicNavigationHeight,MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = kWhiteColor;
        self.block = block;
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, VicNavigationHeight, MAINSCREEN_WIDTH, 5.0*SCALING_RATIO)];
        lineV.backgroundColor = kTableViewBackgroundColor;
        [self addSubview:lineV];
        self.topImageV = [[UIImageView alloc] init];
//        self.topImageV.frame = CGRectMake(MAINSCREEN_WIDTH/2-36*SCALING_RATIO, CGRectGetMaxY(lineV.frame)+32*SCALING_RATIO, 72*SCALING_RATIO, 72*SCALING_RATIO);
        [self addSubview:self.topImageV];
        [self.topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineV).offset(32);
            make.left.equalTo(self).offset(MAINSCREEN_WIDTH/2-36);
            make.width.height.mas_equalTo(72);
        }];
        
//        self.titelLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.topImageV.frame)+18*SCALING_RATIO, MAINSCREEN_WIDTH-20, 33*SCALING_RATIO)];
        self.titelLable = [[UILabel alloc] init];
        [self addSubview:self.titelLable];
//        self.titelLable.backgroundColor = kRedColor;
        self.titelLable.font = [UIFont systemFontOfSize:22*SCALING_RATIO];
        self.titelLable.textColor =  HEXCOLOR(0x333333);
        self.titelLable.textAlignment = NSTextAlignmentCenter;
        [self.titelLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(VicNavigationHeight+127);
            make.left.equalTo(self).with.offset(20);
            make.right.equalTo(self).with.offset(-20);
            make.height.mas_equalTo(33);
        }];
     
        
        UIButton *copyBu = [self creatButtonWithTitle:nil setTitleColor:nil setImage:kIMG(@"copy_blue_rightup") backgroundColor:nil cornerRadius:0 borderWidth:0 borderColor:nil action:@selector(copyAction)];
        [self addSubview:copyBu];
        [copyBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(VicNavigationHeight+167);
             make.right.equalTo(self).with.offset(-15);
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(15);
        }];
        
        
//        self.orderIDLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titelLable.frame)+11*SCALING_RATIO, MAINSCREEN_WIDTH-20, 33*SCALING_RATIO)];
        self.orderIDLable = [[UILabel alloc] init];
        [self addSubview:self.orderIDLable];
        self.orderIDLable.font = [UIFont systemFontOfSize:17*SCALING_RATIO];
        self.orderIDLable.textColor = HEXCOLOR(0x333333);
        self.orderIDLable.textAlignment = NSTextAlignmentCenter;
        [self.orderIDLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(VicNavigationHeight+167);
            make.left.equalTo(self).with.offset(15);
            make.right.equalTo(copyBu.mas_left).with.offset(-8);
            make.height.mas_equalTo(25);
        }];
        
        self.contentStringLable = [[UILabel alloc] init];
        self.contentStringLable.font = [UIFont systemFontOfSize:14*SCALING_RATIO];
        self.contentStringLable.textColor = HEXCOLOR(0x333333);
        self.contentStringLable.numberOfLines = 0;
        self.contentStringLable.text = @"";
        [self addSubview:self.contentStringLable];
//
        self.examineImageButton = [[UILabel alloc] init];
        self.examineImageButton.userInteractionEnabled = YES;
        [self addSubview:self.examineImageButton];
        self.examineImageButton.textColor = [YBGeneralColor themeColor];
        self.examineImageButton.font = kFontSize(15*SCALING_RATIO);
        self.examineImageButton.text = @"点击查看买家转账证明";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(examineImageAction)];
        [self.examineImageButton addGestureRecognizer:tap];
//
        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentButton.adjustsImageWhenHighlighted = NO;
        self.contentButton.adjustsImageWhenHighlighted = NO;
        self.contentButton.titleLabel.font =
        [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
        self.contentButton.layer.masksToBounds = YES;
        self.contentButton.layer.cornerRadius = 4;
        self.contentButton.backgroundColor = HEXCOLOR(0x4c7fff);
        [self.contentButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.contentButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentButton addTarget:self action:@selector(contentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.contentButton];
//
        UIButton *bottomBu = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:bottomBu];
        [bottomBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.mas_bottom).offset(-26);
        }];
        [bottomBu addTarget:self action:@selector(customerService) forControlEvents:UIControlEventTouchUpInside];
        [bottomBu setAttributedTitle:[NSString attributedStringWithString:@"有任何问题" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(14*SCALING_RATIO) subString:@"联系客服" subStringColor:[YBGeneralColor themeColor] subStringFont:kFontSize(14) ] forState:UIControlStateNormal];
        
    } return self;
}


-(void)layoutView:(PostAppealCompleteModel*)model{
    self.model = model;
    self.topImageV.image = [UIImage imageNamed:self.model.topImageName];
    self.titelLable.text = self.model.titelString;
    self.orderIDLable.text = self.model.orderIDSring;
    
    float wi = MAINSCREEN_WIDTH-92*SCALING_RATIO;
    float heith = [NSString textHitWithStirng:self.model.contentString font:14*SCALING_RATIO widt:wi] + 2 *SCALING_RATIO;
    self.contentStringLable.frame = CGRectMake(SCALING_RATIO*46, CGRectGetMaxY(self.orderIDLable.frame)+18*SCALING_RATIO, wi, heith);
    self.contentStringLable.text =self.model.contentString;
    
    
    if (model.data && model.data.count > 0) {
        self.examineImageButton.hidden = NO;
        self.examineImageButton.frame = CGRectMake(SCALING_RATIO*46, CGRectGetMaxY(self.contentStringLable.frame)+5*SCALING_RATIO, 165*SCALING_RATIO, 30*SCALING_RATIO);
    }else{
        self.examineImageButton.hidden = YES;
    }
    
    if (model.buttonTitelSring && model.buttonTitelSring.length > 2) {
        self.contentButton.hidden = NO;
        self.contentButton.frame = CGRectMake(SCALING_RATIO*20, CGRectGetMaxY(self.contentStringLable.frame)+73*SCALING_RATIO, MAINSCREEN_WIDTH-40*SCALING_RATIO, 42*SCALING_RATIO);
        [self.contentButton setTitle:model.buttonTitelSring forState:UIControlStateNormal];
    }else{
        self.contentButton.hidden = YES;
    }
}



-(void)copyAction{

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

    pasteboard.string = self.model.orderNo;

    if (pasteboard.string.length > 0) {

        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}


-(void)examineImageAction{
    if (self.block) {
        self.block(examImageType, self.model);
    }
}


-(void)contentButtonClick{
    if (self.block) {
        self.block(contentType, self.model);
    }
}

-(void)customerService{
    if (self.block) {
        self.block(custServiceType, self.model);
    }
}


@end
