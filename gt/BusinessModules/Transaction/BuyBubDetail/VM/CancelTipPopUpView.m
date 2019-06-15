//
//  CancelTipPopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "CancelTipPopUpView.h"
#define XHHTuanNumViewHight 270
#define XHHTuanNumViewWidth 306

@interface CancelTipPopUpView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) NSMutableArray* leftLabMutArr;

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *contentLabMutArr;
@property (nonatomic, strong) NSMutableArray *funcBtnMutArr;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *singleSureButton;

@property (nonatomic, strong) NSMutableArray *subBtnTitleContentMutArr;

@end

@implementation CancelTipPopUpView

- (id)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = COLOR_HEX(0x000000, .8);
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(disMissView)];
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    
    _contentViewHeigth = XHHTuanNumViewHight;
    
    [self addSubview:self.contentView];
    
    UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saftBtn.frame = CGRectMake(0, 0, self.contentView.width, 47);
    
    saftBtn.titleLabel.font = kFontSize(17);
    
    [saftBtn setTitleColor:HEXCOLOR(0x232630)
                  forState:UIControlStateNormal];
    
    [saftBtn setTitle:@"取消订单"
             forState:UIControlStateNormal];
    
    saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.contentView addSubview:saftBtn];
    
    _line1 = UILabel.new;
    
    [self.contentView addSubview:_line1];
    
    _line1.backgroundColor = HEXCOLOR(0xe8e9ed);
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.offset(48);
        make.height.equalTo(@3);
    }];
    
    [self layoutAccountPublic];
}

#pragma mark - lazyload

-(NSMutableArray *)subBtnTitleContentMutArr{
    
    if (!_subBtnTitleContentMutArr) {
        
        _subBtnTitleContentMutArr = NSMutableArray.array;
        
        [_subBtnTitleContentMutArr addObject:@"稍后再说"];
        
        [_subBtnTitleContentMutArr addObject:@"取消订单"];
    }
    
    return _subBtnTitleContentMutArr;
}

-(NSMutableArray *)contentLabMutArr{
    
    if (!_contentLabMutArr) {
        
        _contentLabMutArr = NSMutableArray.array;
    }
    
    return _contentLabMutArr;
}

-(NSMutableArray *)leftLabMutArr{
    
    if (!_leftLabMutArr) {
        
        _leftLabMutArr = NSMutableArray.array;
    }
    
    return _leftLabMutArr;
}

-(NSMutableArray *)funcBtnMutArr{
    
    if (!_funcBtnMutArr) {
        
        _funcBtnMutArr = NSMutableArray.array;
    }
    
    return _funcBtnMutArr;
}

-(UIView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        
        _contentView.layer.cornerRadius = 6;
        
        _contentView.layer.masksToBounds = YES;
        
        _contentView.userInteractionEnabled = YES;
        
        _contentView.backgroundColor = kWhiteColor;
    }
    
    return _contentView;
}

-(void)layoutAccountPublic{
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *contentLab = UILabel.new;//内容
        
//        contentLab.backgroundColor = kRedColor;
        
        [self.contentLabMutArr addObject:contentLab];
        
        [self.contentView addSubview:contentLab];

        [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(20);
            
            make.right.equalTo(self.contentView).offset(-20);
            
            make.top.equalTo(self.line1.mas_bottom).offset(20 +(42 + 14) * i);
        }];
    }
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.checkButton.tag =  EnumActionTag0;
    
//    self.checkButton.backgroundColor = KGreenColor;
    
    self.checkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.checkButton.titleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.checkButton];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(@20);
        
        UILabel* lab1 = self.contentLabMutArr[1];
        
        make.top.mas_equalTo(lab1.mas_bottom).offset(14);
        
        make.height.equalTo(@20);
    }];
    
    [self.checkButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(funAdsButtonClickItem:)]];
    
    self.checkButton.adjustsImageWhenHighlighted = NO;

    //子按钮 - 取消订单 & 稍后再说
    for (int i = 0; i < self.subBtnTitleContentMutArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+1;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(16);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6;
        button.layer.borderWidth = 1;
        
        [button setTitle:self.subBtnTitleContentMutArr[i]
                forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
//        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(funAdsButtonClickItem:)]];
        [self.contentView addSubview:button];
        
        [self.funcBtnMutArr addObject:button];
        //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    
    UIButton* btn0 = self.funcBtnMutArr.firstObject;
    
    [btn0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)]
                    forState:UIControlStateNormal];
    
    [btn0 setTitleColor:HEXCOLOR(0x4c7fff)
               forState:UIControlStateNormal];
    
    btn0.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;

    UIButton* btn1 = self.funcBtnMutArr.lastObject;
    
    [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x9b9b9b)]
                    forState:UIControlStateNormal];
    
    [btn1 setTitleColor:HEXCOLOR(0xf7f9fa)
               forState:UIControlStateNormal];
    
    [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)]
                    forState:UIControlStateSelected];
    
    [btn1 setTitleColor:HEXCOLOR(0xffffff)
               forState:UIControlStateSelected];
    
    btn1.layer.borderColor = kClearColor.CGColor;

    [self.funcBtnMutArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                    withFixedSpacing:12
                                         leadSpacing:24
                                         tailSpacing:24];

    [self.funcBtnMutArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-18);
        
        make.height.equalTo(@40);
    }];
    
    //////
    
    UILabel* lab_0 = self.contentLabMutArr[0];
    
    lab_0.numberOfLines = 0;
    
    UILabel* lab_1 = self.contentLabMutArr[1];
    
    lab_1.numberOfLines = 0;
    
    NSDictionary *style_00 = @{
                               @"font_00":[UIFont fontWithName:@"PingFangSC-Regular"
                                                          size:15],
                               @"textColor_00":RGBCOLOR(51, 51, 51)
                               };
    
    NSDictionary *style_01 = @{
                               @"font_01":[UIFont fontWithName:@"PingFangSC-Regular"
                                                          size:12],
                               @"textColor_01":RGBCOLOR(102, 102, 102)
                               };
    
    lab_0.attributedText = [@"<font_00><textColor_00>如已转账付款给卖家，请慎重取消订单，否则款项可能无法追回。</textColor_00></font_00>" attributedStringWithStyleBook:style_00];
    
    NSString *str_01 = [NSString stringWithFormat:@"<font_01><textColor_01>取消规则:当日累计取消%@笔，会限制当日买入功能。</textColor_01></font_01>",@"3"];
    
    lab_1.attributedText = [str_01 attributedStringWithStyleBook:style_01];
    
    [self.checkButton setTitle:@"我确认还没有付款"
                       forState:UIControlStateNormal];
    
    [self.checkButton setTitleColor:HEXCOLOR(0x4c7fff)
                           forState:UIControlStateNormal];
    
    [self.checkButton setTitleColor:HEXCOLOR(0x4c7fff)
                           forState:UIControlStateSelected];
    
    [self.checkButton setImage:[UIImage imageNamed:@"xc_ss_select_bg_d"]
                      forState:UIControlStateNormal];
    
    [self.checkButton setImage:[UIImage imageNamed:@"xc_ss_select_bg"]
                      forState:UIControlStateSelected];
    
    [self.checkButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                      imageTitleSpace:7];
    
    //    self.checkButton.selected = NO;
    UIButton* btner = self.funcBtnMutArr.lastObject;
    btner.selected = NO;
    btner.userInteractionEnabled = NO;
    //    SetUserBoolKeyWithObject(kIsBuyTip, YES);
    //    UserDefaultSynchronize;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)funAdsButtonClickItem:(UITapGestureRecognizer*)btn{
    EnumActionTag tag = btn.view.tag;
    switch (tag) {
        case EnumActionTag0:
            {
            NSString* btnTit = @"";
            UIButton* button = (UIButton*)[btn view] ;
            UIButton* funcBtn1 =self.funcBtnMutArr.lastObject;
            
            button.selected = !button.selected;
            if (button.selected) {
                //        for (UIButton *btn in self.btns) {
                //            btn.selected = NO;
                //        }
                btnTit = button.titleLabel.text;
                
                [button setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
                
                [button setImage:[UIImage imageNamed:@"xc_ss_select_bg"] forState:UIControlStateNormal];
                
                funcBtn1.selected = YES;
                funcBtn1.userInteractionEnabled = YES;
            } else {
                btnTit = @"";
                
                [button setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"xc_ss_select_bg_d"] forState:UIControlStateNormal];
                
                funcBtn1.selected = NO;
                funcBtn1.userInteractionEnabled = NO;
            }
            //        SetUserBoolKeyWithObject(kIsBuyTip, button.selected);
            //        UserDefaultSynchronize;
            }
            break;
        case EnumActionTag1:
        {
            [self disMissView];
        }
            break;
        case EnumActionTag2:
        {
            UIButton* funcBtn1 =self.funcBtnMutArr.lastObject;
            if (funcBtn1.selected
                &&funcBtn1.userInteractionEnabled) {
                [self disMissView];
                if (self.block) {
                    self.block(@(btn.view.tag));
                }
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)richElementsInViewWithModel:(nullable id)model{

    UILabel* lab_0 = self.contentLabMutArr[0];

    UILabel* lab_1 = self.contentLabMutArr[1];

    NSDictionary *style_00 = @{
                               @"font_00":[UIFont fontWithName:@"PingFangSC-Regular"
                                                          size:15],
                               @"textColor_00":RGBCOLOR(51, 51, 51)
                               };

    NSDictionary *style_01 = @{
                               @"font_01":[UIFont fontWithName:@"PingFangSC-Regular"
                                                          size:12],
                               @"textColor_01":RGBCOLOR(102, 102, 102)
                               };

    lab_0.attributedText = [@"<font_00><textColor_00>如已转账付款给卖家，请慎重取消订单，否则款项可能无法追回。</textColor_00></font_00>" attributedStringWithStyleBook:style_00];

    NSString *str_01 = [NSString stringWithFormat:@"<font_01><textColor_01>取消规则:当日累计取消%@笔，会限制当日买入功能。</textColor_01></font_01>",@"3"];

    lab_1.attributedText = [str_01 attributedStringWithStyleBook:style_01];

    [self.checkButton setTitle:@"我确认还没有付款" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    [self.checkButton setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateSelected];
    [self.checkButton setImage:[UIImage imageNamed:@"xc_ss_select_bg_d"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"xc_ss_select_bg"] forState:UIControlStateSelected];
    [self.checkButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:7];

//    self.checkButton.selected = NO;
    UIButton* btn1 =self.funcBtnMutArr.lastObject;
    btn1.selected = NO;
    btn1.userInteractionEnabled = NO;
//    SetUserBoolKeyWithObject(kIsBuyTip, YES);
//    UserDefaultSynchronize;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) return NO;

    return YES;
}

- (void)showInApplicationKeyWindow{
    
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    
    if (!view) return;
    
    [view addSubview:self];
    
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, _contentViewHeigth)];
    
    kWeakSelf(self);
    
    [UIView animateWithDuration:0.3
                     animations:^{

                         kStrongSelf(self);
                         
                         self.alpha = 1.0;
        
                         [self.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - self.contentViewHeigth)/2,XHHTuanNumViewWidth,self.contentViewHeigth)];
        
    }
                     completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    kWeakSelf(self);
    
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         kStrongSelf(self);
                         
                         self.alpha = 0.0;
                         
                         [self.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, self.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         
                         [self.contentView removeFromSuperview];
                         
                     }];
}

@end

