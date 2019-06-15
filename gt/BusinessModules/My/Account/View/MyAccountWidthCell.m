//
//  MyAccountWidthCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import "MyAccountWidthCell.h"
#import "PaymentAccountModel.h"


@interface MyAccountWidthCell ()
@property (nonatomic, strong) UILabel * accountNumberLb;
@property (nonatomic, strong) UILabel * cellNameLb;
@property (nonatomic, strong) UILabel * cellOpenBranchLb;
@property (nonatomic, strong) UIButton * watchImageBu;
@end

@implementation MyAccountWidthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIView *bgV = [self.contentView viewWithTag:134261];
        bgV.frame = CGRectMake(20*SCALING_RATIO, 15*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 117*SCALING_RATIO);
        UIView *mainV = [self.contentView viewWithTag:134260];
        mainV.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 117*SCALING_RATIO);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:mainV.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8*SCALING_RATIO, 8*SCALING_RATIO)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = mainV.bounds;
        maskLayer.path = maskPath.CGPath;
        mainV.layer.mask = maskLayer;
        self.accountNumberLb = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 48*SCALING_RATIO,  MAINSCREEN_WIDTH - 40*SCALING_RATIO - 30*SCALING_RATIO, 20*SCALING_RATIO)];
        self.accountNumberLb.textColor = HEXCOLOR(0x333333);
        self.accountNumberLb.font = kFontSize(20*SCALING_RATIO);
        [mainV addSubview:self.accountNumberLb];
        UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(0, 84*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 1)];
        linV.backgroundColor = HEXCOLOR(0xf5f5f5);
        [mainV addSubview:linV];
        self.cellNameLb = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 95*SCALING_RATIO,  100 * SCALING_RATIO, 13*SCALING_RATIO)];
        self.cellNameLb.textColor = HEXCOLOR(0x8c96a5);
        self.cellNameLb.font = kFontSize(12*SCALING_RATIO);
        [mainV addSubview:self.cellNameLb];
        self.cellOpenBranchLb = [[UILabel alloc] init];
        self.cellOpenBranchLb.textColor = HEXCOLOR(0x8c96a5);
        self.cellOpenBranchLb.textAlignment = NSTextAlignmentRight;
        self.cellOpenBranchLb.font = kFontSize(12*SCALING_RATIO);
        self.cellOpenBranchLb.userInteractionEnabled = YES;
        [mainV addSubview:self.cellOpenBranchLb];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(watchImageBuAction)];
        [self.cellOpenBranchLb addGestureRecognizer:ta];
        self.watchImageBu = [UIButton buttonWithType:UIButtonTypeCustom];
        self.watchImageBu.frame = CGRectMake(309*SCALING_RATIO, 94*SCALING_RATIO,  11*SCALING_RATIO, 13*SCALING_RATIO);
        [mainV addSubview:self.watchImageBu];
        [self.watchImageBu setImage:kIMG(@"xipigImage") forState:(UIControlStateNormal)];
        [self.watchImageBu addTarget:self action:@selector(watchImageBuAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}


-(void)reloadCellDataWith:(id)model andEdit:(BOOL)isEdit showBG:(BOOL)show{
    [super reloadCellDataWith:model andEdit:isEdit showBG:show];
    PaymentAccountData *mo = model;
    
    self.cellNameLb.text = [NSString stringWithFormat:@"%@",mo.name];
    
    if ([mo.paymentWay integerValue] != 3) {
        self.accountNumberLb.text = [NSString stringWithFormat:@"%@",mo.account];
        self.watchImageBu.hidden = NO;
        self.cellOpenBranchLb.frame = CGRectMake(MAINSCREEN_WIDTH - 40*SCALING_RATIO - 215*SCALING_RATIO -13*SCALING_RATIO, 95*SCALING_RATIO,  200 * SCALING_RATIO, 13*SCALING_RATIO);
        self.cellOpenBranchLb.text = @"收款二维码";
    }else{
        self.accountNumberLb.text = [NSString stringWithFormat:@"%@",mo.accountBankCard];
        self.watchImageBu.hidden = YES;
        self.cellOpenBranchLb.frame = CGRectMake(MAINSCREEN_WIDTH - 40*SCALING_RATIO - 215*SCALING_RATIO, 95*SCALING_RATIO,  200 * SCALING_RATIO, 13*SCALING_RATIO);
        self.cellOpenBranchLb.text = [NSString stringWithFormat:@"%@",mo.accountOpenBranch];
    }
}

-(void)watchImageBuAction{
    if (self.watchImageBu.hidden) {
        return;
    }
    [super watchImageBuAction];
}

@end

