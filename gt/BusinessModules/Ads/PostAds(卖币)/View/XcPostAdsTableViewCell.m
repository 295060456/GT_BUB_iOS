//
//  XcPostAdsTableViewCell.m
//  gt
//
//  Created by XiaoCheng on 28/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsTableViewCell.h"
#import "HomeModel.h"

#define XC_COLOR_A  RGBCOLOR(221, 221, 221)//灰色
#define XC_COLOR_B  RGBCOLOR(76, 127, 255)//蓝色
#define XC_COLOR_C  RGBCOLOR(51, 51, 51)//黑色

@interface XcPostAdsTableViewCell()
@property (nonatomic, strong) UIButton *zfb,*wx,*yhk;
@property (nonatomic, strong) UIButton *currentBtn;
@end

@implementation XcPostAdsTableViewCell
#pragma mark    ---固额-买家单笔固额交易---
- (void) setPrice:(NSString *)price{
    if (_price) {return;}
    _price = price;
    if (HandleStringIsNull(price)) {
        NSArray *list = [price componentsSeparatedByString:@","];
        CGFloat left = 20.0f;
        CGFloat top = 5.0f;
        CGFloat x = left;
        CGFloat y = 5.0f;
        CGFloat gap = 10.0f;
        CGFloat h = XcPostAdsTableViewCell_GE_HEIGHT-top*2;
        CGFloat w = (self.contentView.mj_w-left*2-gap*3)/4;
        
        for (int i=0; i<list.count; i++) {
            if ((x+w)>self.contentView.mj_w) {
                x = left;
                y += (top*2)*floor(i/4)+h*floor(i/4);
            }
            UIButton*btn = [self creatButton:CGRectMake(x, y, w, h) price:list[i]];
            x = btn.right + gap;
            
            if ((!HandleStringIsNull(self.fixedAmount) && i==0) || [[btn titleForState:UIControlStateNormal] isEqualToString:self.fixedAmount]) {
                btn.selected = YES;
                self.currentBtn = btn;
                setButtonBorderColor(btn);
                if (self.block) {
                    self.block([btn titleForState:UIControlStateNormal]);
                }
            }
        }
    }
}

- (UIButton *) creatButton:(CGRect) frame price:(NSString*) price{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setTitle:price forState:UIControlStateNormal];
    [btn setTitleColor:XC_COLOR_C forState:UIControlStateNormal];
    [btn setTitleColor:XC_COLOR_B forState:UIControlStateSelected];
    [btn.titleLabel setFont:kFontSize(15)];
    [btn.layer setBorderWidth:.5];
    setButtonBorderColor(btn);
    [btn.layer setCornerRadius:4];
    [btn.layer setMasksToBounds:YES];
    [self.contentView addSubview:btn];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (!btn.selected) {
            btn.selected = !btn.selected;
            setButtonBorderColor(btn);
            @strongify(self)
            if (self.currentBtn) {
                self.currentBtn.selected = NO;
                setButtonBorderColor(self.currentBtn);
                self.currentBtn = nil;
            }
            
            if (btn.selected) {
                self.currentBtn = btn;
            }
            
            if (self.block) {
                self.block([btn titleForState:UIControlStateNormal]);
            }
        }
    }];
    return btn;
}

#pragma mark    ---我的收款方式---
- (void) setDatas:(NSArray *)datas{
    if (_datas) {return;}
    _datas = datas;
    if (datas.count>0) {
        CGFloat left = 20.0f;
        
        CGFloat x = left;
        CGFloat gap = 39.0f;
        CGFloat h = 28.0f;
        CGFloat top = self.contentView.mj_h-h-22;
        CGFloat w = (self.contentView.mj_w-left*2-gap*2)/3;

        for (int i=0; i<datas.count; i++) {
            NSDictionary*dic = datas[i];
            
            UIButton*btn;
            NSString *type = dic[@"type"];
            switch (type.integerValue) {
                case 1:{
                    btn = [self creatPayButton:CGRectMake(x, top, w, h) price:dic[@"btnTitle"] img:dic[@"iconImage"]];
                    self.wx = btn;
                    break;}
                case 2:{
                    btn = [self creatPayButton:CGRectMake(x, top, w, h) price:dic[@"btnTitle"] img:dic[@"iconImage"]];
                    self.zfb = btn;
                    break;}
                case 3:{
                    btn = [self creatPayButton:CGRectMake(x, top, w, h) price:dic[@"btnTitle"] img:dic[@"iconImage"]];
                    self.yhk = btn;
                    break;}
                default:
                    break;
            }
    
            x = btn.right + gap;
            btn.tag = i;
            for (AccountPaymentWayModel *miniModel in (self.type==1?singLeton.chooseModelAr1:singLeton.chooseModelAr2)) {
                if ([miniModel.paymentWay isEqualToString:type]) {
                    btn.selected = YES;
                    setButtonBorderColor(btn);
                }
            }
        }
    }
}

- (UIButton *) creatPayButton:(CGRect) frame price:(NSString*) price img:(NSString *) imgName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setTitle:price forState:UIControlStateNormal];
    [btn setTitleColor:XC_COLOR_C forState:UIControlStateNormal];
    [btn setTitleColor:XC_COLOR_B forState:UIControlStateSelected];
    [btn setImage:kIMG(imgName) forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(3, -10, 3, 0)];    
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn.titleLabel setFont:kFontSize(12)];
    [btn.layer setBorderWidth:.5];
    [btn.layer setBorderColor:XC_COLOR_A.CGColor];
    [btn.layer setCornerRadius:4];
    [btn.layer setMasksToBounds:YES];
    [self.contentView addSubview:btn];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        NSDictionary *dic = self.datas[btn.tag];
        NSArray *cardIDs = dic[@"data"];
        
        if (btn.selected) {//点击选择，想取消操作
            if ((self.type==TransactionAmountTypeLimit?singLeton.chooseModelAr1:singLeton.chooseModelAr2).count>1) {//有多个付款账户
                btn.selected = NO;
                setButtonBorderColor(btn);
                AccountPaymentWayModel *miniModel11;
                for (AccountPaymentWayModel *miniModel in (self.type==1?singLeton.chooseModelAr1:singLeton.chooseModelAr2)) {
                    if ([miniModel.paymentWay isEqualToString:getPaymentWayType(self.zfb,self.wx,self.yhk,btn)]) {
                        miniModel11 = miniModel;break;
                    }
                }
                
                [(self.type==TransactionAmountTypeLimit?singLeton.chooseModelAr1:singLeton.chooseModelAr2) removeObject:miniModel11];
            }else{//当前选择的付款方式只有一种
                if (self.datas.count>1) {//如何返回数据有多种付款方式，弹框
                    self.block(@(1));
                }else{//如何返回数据只有一种付款方式，不做任何操作
                    
                }
            }
        }else{//点击未选择，想选择操作
            if (cardIDs.count>1) {//有多张卡时，弹框
                self.block(@(1));
            }else{//只有一张卡，直接显示添加
                btn.selected = YES;
                setButtonBorderColor(btn);
                [(self.type==TransactionAmountTypeLimit?singLeton.chooseModelAr1:singLeton.chooseModelAr2) addObject:cardIDs.firstObject];
            }
        }
    }];
    return btn;
}

void setButtonBorderColor(UIButton *btn){
    [btn.layer setBorderColor:btn.selected?XC_COLOR_B.CGColor:XC_COLOR_A.CGColor];
    [btn.layer setBorderWidth:btn.selected?1:.5];
}

NSString* getPaymentWayType(UIButton *zfb,
                       UIButton *wx,
                       UIButton *yhk,
                       UIButton *btn){
    NSString *paymentWay;
    if ([btn isEqual:zfb]) {
        paymentWay = @"2";
    }else if ([btn isEqual:wx]){
        paymentWay = @"1";
    }else if ([btn isEqual:yhk]){
        paymentWay = @"3";
    }
    return paymentWay;
}

- (void) reloadDataView{
    if (self.zfb) {
        self.zfb.selected = NO;setButtonBorderColor(self.zfb);
    }if(self.wx){
        self.wx.selected = NO;setButtonBorderColor(self.wx);
    }if(self.yhk){
        self.yhk.selected = NO;setButtonBorderColor(self.yhk);
    }
    
    for (AccountPaymentWayModel *miniModel in (self.type==1?singLeton.chooseModelAr1:singLeton.chooseModelAr2)) {
        switch (miniModel.paymentWay.integerValue) {
            case 1:
                self.wx.selected = YES;
                setButtonBorderColor(self.wx);
                break;
            case 2:
                self.zfb.selected = YES;
                setButtonBorderColor(self.zfb);
                break;
            case 3:
                self.yhk.selected = YES;
                setButtonBorderColor(self.yhk);
                break;
            default:
                break;
        }
    }
}

@end
