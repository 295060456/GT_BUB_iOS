//
//  BuyDetailQRFooterV.m
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailQRFooterV.h"

@interface BuyDetailQRFooterV ()
@property (nonatomic, copy)   DataBlock block;
@property (nonatomic ,assign) NSInteger payFC;
@end

@implementation BuyDetailQRFooterV

-(instancetype)initWithTitleString:(NSString*)payType andPayCode:(NSString*)payCode andQRUrlString:(NSString*)urlS actionBlock:(DataBlock)block{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 252*SCALING_RATIO);
        self.backgroundColor = kWhiteColor;
        self.block = block;
        UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 15*SCALING_RATIO, 200*SCALING_RATIO, 20*SCALING_RATIO)];
        titleLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*SCALING_RATIO];
        titleLa.textColor = HEXCOLOR(0x333333);
        titleLa.text = [NSString stringWithFormat:@"使用%@向以下账号汇款",payType];
        [self addSubview:titleLa];
        
        UILabel *titleLa1 = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 230*SCALING_RATIO, 15*SCALING_RATIO, 200*SCALING_RATIO, 20*SCALING_RATIO)];
        titleLa1.textColor = HEXCOLOR(0x333333);
        titleLa1.textAlignment = NSTextAlignmentRight;
        
        NSString *timeString = [NSString stringWithFormat:@"付款参考号：%@",payCode];
        NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeString];
        [timeAttrString addAttributes:@{NSFontAttributeName:kFontSize(14*SCALING_RATIO)} range:NSMakeRange(0, 6)];
        [timeAttrString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x9a9a9a) range:NSMakeRange(0, 6)];
        titleLa1.attributedText = timeAttrString;
        titleLa1.font = kFontSize(14*SCALING_RATIO);
        [self addSubview:titleLa1];
        
        UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame = CGRectMake(MAINSCREEN_WIDTH - 28*SCALING_RATIO, 18*SCALING_RATIO, 13*SCALING_RATIO, 15*SCALING_RATIO);
        [bu setImage:kIMG(@"copy_blue_rightup") forState:(UIControlStateNormal)];
        [self addSubview:bu];
        [[bu rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = payCode;
            if (pasteboard.string.length > 0) {
                [YKToastView showToastText:[NSString stringWithFormat:@" ”%@“ 复制成功",payCode]];
            }
        }];
        UIView *granViews = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 50*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 149*SCALING_RATIO)];
        granViews.backgroundColor = HEXCOLOR(0xf6f7f9);
        [self addSubview:granViews];
        granViews.layer.cornerRadius = 8*SCALING_RATIO;
        
        UIImageView *qrImage = [[UIImageView alloc] initWithFrame:CGRectMake(114*SCALING_RATIO, 21*SCALING_RATIO, 108*SCALING_RATIO, 108*SCALING_RATIO)];
        qrImage.backgroundColor = kWhiteColor;
        [granViews addSubview:qrImage];
        qrImage.image = [SGQRCodeObtain generateQRCodeWithData:urlS
                                                          size:108*SCALING_RATIO];
        if ([payType isEqualToString:@"支付宝"]) {
            self.payFC = 2;
        }else if ([payType isEqualToString:@"微信"]){
            self.payFC = 1;
        }
        UIButton *tap = [self creatButtonWithTitle:[NSString stringWithFormat:@"跳转至%@App付款",payType] setTitleColor:kWhiteColor setImage:nil backgroundColor:HEXCOLOR(0x4c7fff) cornerRadius:6 borderWidth:0 borderColor:nil action:@selector(putAction)];
        tap.frame = CGRectMake(30*SCALING_RATIO, 210*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 40*SCALING_RATIO);
        tap.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15*SCALING_RATIO];
        [self addSubview:tap];
    } return self;
}

-(void)putAction{
    if (self.block) {
        self.block(@(self.payFC)); // 1 weix  2 zfb  3 ka
    }
}
@end
