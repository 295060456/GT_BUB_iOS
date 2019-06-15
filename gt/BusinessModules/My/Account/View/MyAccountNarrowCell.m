//
//  MyAccountNarrowCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import "MyAccountNarrowCell.h"
#import "PaymentAccountModel.h"


@interface MyAccountNarrowCell (){
    UIView *_YV;
}
@property (nonatomic, strong) UIImageView * cellImgView;
@property (nonatomic, strong) UILabel * cellTittleLb;
@property (nonatomic, strong) UILabel * cellContentLb;
@property (nonatomic, strong) UIButton * tapImgView;
@property (nonatomic, strong) PaymentAccountData *model;
@property (nonatomic, strong) UIView *bgW;

@end


@implementation MyAccountNarrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
         self.contentView.clipsToBounds = YES;
        self.bgW = [[UIView alloc] initWithFrame:CGRectMake(20.1*SCALING_RATIO, 0, MAINSCREEN_WIDTH - 40.2*SCALING_RATIO, 20*SCALING_RATIO)];
        self.bgW.backgroundColor = kWhiteColor;
        [self.contentView addSubview:self.bgW];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 15*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 33*SCALING_RATIO)];
        bgView.tag = 134261;
        [self.contentView addSubview:bgView];
        UIView *mainV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 33*SCALING_RATIO)];
        mainV.backgroundColor = kWhiteColor;
        mainV.tag = 134260;
        [bgView addSubview:mainV];
        bgView.layer.shadowColor = HEXCOLOR(0x27272727).CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0, -4*SCALING_RATIO);
        bgView.layer.shadowOpacity = 0.08;
        bgView.layer.cornerRadius = 8*SCALING_RATIO;
        [bgView.layer setShouldRasterize:YES];
        [bgView.layer setRasterizationScale:[UIScreen mainScreen].scale];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:mainV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8*SCALING_RATIO, 8*SCALING_RATIO)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = mainV.bounds;
        maskLayer.path = maskPath.CGPath;
        mainV.layer.mask = maskLayer;

//        [mainV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(1);
//            make.left.mas_equalTo(20);
//            make.right.mas_equalTo(-20);
//            make.height.mas_equalTo(65);
//        }];
        self.cellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 15*SCALING_RATIO,  14*SCALING_RATIO, 14*SCALING_RATIO)];
        [mainV addSubview:self.cellImgView];
//        [self.cellImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(mainV).offset(15);
//            make.left.mas_equalTo(mainV).offset(15);
//            make.height.with.mas_equalTo(14);
//        }];
        self.cellTittleLb = [[UILabel alloc] initWithFrame:CGRectMake(35*SCALING_RATIO, 15*SCALING_RATIO,  55*SCALING_RATIO, 14*SCALING_RATIO)];
        self.cellTittleLb.textColor = HEXCOLOR(0x333333);
        self.cellTittleLb.font = kFontSize(13*SCALING_RATIO);
        [mainV addSubview:self.cellTittleLb];
        self.cellContentLb = [[UILabel alloc] initWithFrame:CGRectMake(100*SCALING_RATIO, 18*SCALING_RATIO,  200*SCALING_RATIO, 13*SCALING_RATIO)];
        self.cellContentLb.textColor = HEXCOLOR(0x8c96a5);
        self.cellContentLb.font = kFontSize(12*SCALING_RATIO);
        [mainV addSubview:self.cellContentLb];
        
        _YV = [[UIView alloc] initWithFrame:CGRectMake(305*SCALING_RATIO, 12*SCALING_RATIO,  20*SCALING_RATIO, 20*SCALING_RATIO)];
        _YV.layer.masksToBounds = YES;
        _YV.layer.cornerRadius = 10 * SCALING_RATIO;
        _YV.backgroundColor = HEXCOLOR(0xdddddd);
        [mainV addSubview:_YV];
        
        self.tapImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tapImgView.frame = CGRectMake(295*SCALING_RATIO, 2*SCALING_RATIO,  40*SCALING_RATIO, 40*SCALING_RATIO);
        [mainV addSubview:self.tapImgView];
        [self.tapImgView addTarget:self action:@selector(chooseAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}


-(void)reloadCellDataWith:(id)model andEdit:(BOOL)isEdit showBG:(BOOL)show{
    self.model = model;
    
    NSInteger ty = [self.model.paymentWay integerValue];
    NSString *titleS = @"";
    NSString *imageS = @"";
    if (ty == 1) {
        titleS = @"微信";
        imageS = @"xiWeixiRan";
    }else if (ty == 2 ){
        titleS = @"支付宝";
        imageS = @"xizhifuBaoRan";
    }else if (ty == 3){
        titleS = self.model.accountOpenBank;
        imageS = @"icon_bank";
    }
    self.cellTittleLb.text = [NSString stringWithFormat:@"%@",titleS];
    self.cellImgView.image = kIMG(imageS);
    if ([self.model.onedaylimit isEqualToString:@"*null*"] || self.model.onedaylimit == nil || self.model.onedaylimit.length < 1) {
        self.cellContentLb.text = @"此卡暂未设置收款上限";
    }else{
        self.cellContentLb.text = [NSString stringWithFormat:@"收款上限 %@",self.model.onedaylimit];
    }
   
    if (isEdit) {
        self.tapImgView.hidden = NO;
        _YV.hidden = NO;
        if (self.model.editChooseCell) {
            [self.tapImgView setImage:kIMG(@"invalidNameX") forState:(UIControlStateNormal)];
        }else{
            [self.tapImgView setImage:kIMG(@"idNameX") forState:(UIControlStateNormal)];
        }
    }else{
        self.tapImgView.hidden = YES;
        _YV.hidden = YES;
    }
    if (show) {
        self.bgW.hidden = NO;
    }else{
        self.bgW.hidden = YES;
    }
}

-(void)chooseAction{
    if (self.delegate) {
        [self.delegate myAccountNarrowCellActin:self.tapImgView andModel:self.model];
    }
}

-(void)watchImageBuAction{
    if (self.delegate) {
        [self.delegate viewBigPictureModel:self.model];
    }
}

@end
