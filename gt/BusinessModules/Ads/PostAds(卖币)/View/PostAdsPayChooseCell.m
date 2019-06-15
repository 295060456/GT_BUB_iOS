//
//  PostAdsPayChooseCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/23.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAdsPayChooseCell.h"

@interface PostAdsPayChooseCell ()
@property(nonatomic, strong) UIView  *witeView;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *tipsLab;
@property(nonatomic, strong) UIImageView *btn;
@end

@implementation PostAdsPayChooseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.witeView = [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 0, MAINSCREEN_WIDTH- 30*SCALING_RATIO, 50*SCALING_RATIO)];
        [self.contentView addSubview:self.witeView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 10*SCALING_RATIO, 210*SCALING_RATIO, 30*SCALING_RATIO)];
        self.titleLab.textColor = HEXCOLOR(0x333333);
        self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALING_RATIO];
        [self.witeView addSubview:self.titleLab];
        
        self.tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(234*SCALING_RATIO, 16*SCALING_RATIO, 56*SCALING_RATIO, 18*SCALING_RATIO)];
        self.tipsLab.text = @"额度已满";
//        self.tipsLab.hidden = YES;
        self.tipsLab.textAlignment = NSTextAlignmentCenter;
        self.tipsLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12*SCALING_RATIO];
        self.tipsLab.textColor = HEXCOLOR(0xcccccc);
        [NSObject colourToLayerOfView:self.tipsLab
                           WithColour:HEXCOLOR(0xcccccc)
                       AndBorderWidth:0.5];
        [self.witeView addSubview:self.tipsLab];

        self.btn = [UIImageView new];
        self.btn.frame = CGRectMake(310*SCALING_RATIO, 15*SCALING_RATIO, 20*SCALING_RATIO, 20*SCALING_RATIO);
        self.btn.backgroundColor = HEXCOLOR(0xdddddd);
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = 10*SCALING_RATIO;
        [self.witeView addSubview:self.btn];

        
    }
    return self;
}

-(void)realCellDataWithModel:(AccountPaymentWayModel *)cellModel withChooseAr:(NSMutableArray*)chooseArr andShowBottomLien:(BOOL)show block:(DataBlock)block{
 
    NSString *titelS = cellModel.account;
    if ([cellModel.paymentWay isEqualToString:@"3"]) { // y
        titelS = [NSString stringWithFormat:@"%@ 尾号 %@",cellModel.accountOpenBank,[cellModel.accountBankCard substringFromIndex:cellModel.accountBankCard.length - 4]];
    }
    self.titleLab.text = titelS;
    if ([cellModel.limitstatus isEqualToString:@"1"]) {
        self.tipsLab.hidden = NO;
    }else{
        self.tipsLab.hidden = YES;
    }
    if ([chooseArr containsObject:cellModel]) {
        self.btn.image = kIMG(@"shensuchenggXi");
    }else{
        self.btn.image = kIMG(@"s");
    }
    if (show) {
        [self applyRoundCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) radius:6*SCALING_RATIO view:self.witeView andPathTyp:1];
    }else{
        [self applyRoundCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) radius:6*SCALING_RATIO view:self.witeView andPathTyp:2];
    }
}


- (void)applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius view:(UIView *) view andPathTyp:(NSInteger)type{
    CGRect rect;
    for (CAShapeLayer *layer in view.layer.sublayers){
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
             [layer removeFromSuperlayer];
        }
    }
    if (type == 0) { // 不要底线
        rect = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height+10);
    }else if (type == 1){ // 不要顶部
        rect = CGRectMake(0, -10, view.bounds.size.width, view.bounds.size.height+10);
    }else if (type == 2){ // 上下
        rect = CGRectMake(0, -2, view.bounds.size.width, view.bounds.size.height+4);
        radius =0;
    }else{rect = view.bounds; }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *temp = [CAShapeLayer layer];
    temp.lineWidth = 1.f;
    temp.fillColor = [UIColor clearColor].CGColor;
    temp.strokeColor = HEXCOLOR(0xe4e4e4).CGColor;
    temp.frame = view.bounds;
    temp.path = path.CGPath;
    [view.layer addSublayer:temp];
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
    mask.path = path.CGPath;
    view.layer.mask = mask;
    view.clipsToBounds=YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
