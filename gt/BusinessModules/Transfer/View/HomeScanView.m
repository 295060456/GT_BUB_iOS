//
//  HomeScanView.m
//  OTC
//
//  Created by David on 2018/11/24.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "HomeScanView.h"
#import "HomeModel.h"
@implementation HomeScanView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"HomeScanView" owner:self options:nil] lastObject];
    if (self)
    {
        self.frame = frame;
         UserAssertModel *userAssertModel = [UserAssertModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserAssert)];
        if (userAssertModel.amount != 0) {
            _titleLab.text = @"扫码转账";
            [_noMoneyLab removeFromSuperview];
            [_ifLab removeFromSuperview];
            [_useHelpBtn removeFromSuperview];
            [_buyABBtn removeFromSuperview];
            [_leftImageV setImage: [UIImage imageNamed:@"icon_scanPage"]];
            [_rightImageV setImage:[UIImage imageNamed:@"icon_transPage"]];

        }else{
            _titleLab.text = @"首次说明";
            [_haveInfoLab removeFromSuperview];
            [_confirmBtn removeFromSuperview];
        }
        _dontShowBtn.selected = NO;
        
    }
    return self;
    
}
- (IBAction)confirmClick:(id)sender {
    if (self.scanBlock) {
        [self removeFromSuperview];
        self.scanBlock();
    }
}
- (IBAction)dontShowAgain:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:kIsScanTip];
}
- (IBAction)helpClick:(id)sender {
    if (self.helpBlock) {
        [self removeFromSuperview];
        self.helpBlock();
    }
}
- (IBAction)BuyAB:(id)sender {
    if (self.buyBlock) {
        [self removeFromSuperview];
        self.buyBlock();
    }
}
- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        [self removeFromSuperview];
        self.cancelBlock();
    }
}

@end
