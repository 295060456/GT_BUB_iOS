//
//  Buy_PaymentPopUpView.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_PaymentPopUpView.h"

@interface Buy_PaymentPopUpView (){
    
}

@property(nonatomic,strong)UIButton *whiteBtn;

@property(nonatomic,strong)JXButton *contactBtn;

@end

@implementation Buy_PaymentPopUpView

-(instancetype)initWithOrderDetailStyle:(OrderDetailStyle)orderDetailStyle{
    
    if (self = [super init]) {
        
        [self initViewWithOrderDetailStyle:orderDetailStyle];
    }
    
    return self;
}

-(void)initViewWithOrderDetailStyle:(OrderDetailStyle)style{
    
    switch (style) {
            //买家界面状态
        case OrderDetail_complainWithConfirm_Buyer:{//联系卖家&&取消订单&&点击确认付款
            
            [self ContactSellerBtn:OrderDetail_complainWithCancelOrder_Buyer];
            
            [self blueBtn:@"点击确认付款"];
            
            [self whiteBtn:@"取消订单"];
            
            [self.blueBtn addTarget:self
                             action:@selector(havePaidBtnClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteBtn addTarget:self
                              action:@selector(cancelOrderBtnClickEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case OrderDetail_complainWithoutCancelOrder_Buyer:{//联系卖家&&我要申诉
            
            [self ContactSellerBtn:OrderDetail_complainWithoutCancelOrder_Buyer];
            
            [self bigBtnWithTitle:@"我要申诉"];
        }
            break;
        case OrderDetail_complainWithCancelOrder_Buyer:{//联系卖家&&取消订单&&我要申诉
            
            [self ContactSellerBtn:OrderDetail_complainWithCancelOrder_Buyer];
            
            [self blueBtn:@"我要申诉"];
            
            [self whiteBtn:@"取消订单"];
            
            self.blueBtn.backgroundColor = RGBCOLOR(155, 155, 155);
            
            //            self.blueBtn.userInteractionEnabled = NO;
            
            [self.blueBtn addTarget:self
                             action:@selector(wannaComplainBtnClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteBtn addTarget:self
                              action:@selector(cancelOrderBtnClickEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case OrderDetail_onlyContactSeller_Buyer:{//联系卖家（只有一个按键）
            
            [self ContactSellerBtn:OrderDetail_onlyContactSeller_Buyer];
            
        }
            break;
        case OrderDetail_showMyCapitalAndConsumeNow_Buyer:{//联系卖家&&查看我的资产&&现在去消费
            
            [self ContactSellerBtn:OrderDetail_showMyCapitalAndConsumeNow_Buyer];
            
            [self blueBtn:@"现在去消费"];
            
            [self whiteBtn:@"查看我的资产"];
            
            [self.blueBtn addTarget:self
                             action:@selector(nowToConsumeBtnClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteBtn addTarget:self
                              action:@selector(showMyPropertyBtnClickEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case OrderDetail_havePaid_Buyer:{// 联系卖家&&取消订单&&我已付款
            
            [self ContactSellerBtn:OrderDetail_havePaid_Buyer];//V
            
            [self blueBtn:@"我已付款"];
            
            [self whiteBtn:@"取消订单"];
            
            [self.blueBtn addTarget:self
                             action:@selector(havePaidBtnClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteBtn addTarget:self
                              action:@selector(cancelOrderBtnClickEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case OrderDetail_cancelComplain_Buyer:{//联系卖家&&取消申诉
            
            [self ContactSellerBtn:OrderDetail_cancelComplain_Buyer];//V
            
            [self bigBtnWithTitle:@"取消申诉"];
        }
            break;
            
            //卖家界面状态
        case OrderDetail_onlyContactBuyer_Seller:{//联系买家
            
            [self ContactBuyerBtn:OrderDetail_onlyContactBuyer_Seller];//V
            
        }
            break;
        case OrderDetail_complainWithoutCancelOrder_Seller:{//联系买家&&我要申诉
            
            [self ContactBuyerBtn:OrderDetail_complainWithoutCancelOrder_Seller];//V
            
            [self complain:OrderDetail_complainWithoutCancelOrder_Seller];
        }
            break;
        case OrderDetail_complainWithConfirm_Seller:{//联系买家&&我要申诉&&确认已收款，放行
            
            [self ContactBuyerBtn:OrderDetail_complainWithConfirm_Seller];//V
            
            [self complain:OrderDetail_complainWithConfirm_Seller];
            
            [self.blueBtn addTarget:self
                             action:@selector(confirmHaveGatheredBtnClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteBtn addTarget:self
                              action:@selector(wannaComplainBtnClickEvent:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case OrderDetail_cancelComplain_Seller:{//联系买家&&取消申诉
            
            [self ContactBuyerBtn:OrderDetail_cancelComplain_Seller];//V
            
            [self complain:OrderDetail_cancelComplain_Seller];
            
        }
            break;
        default:
            break;
    }
}

//我要申诉/取消申诉
-(void)complain:(OrderDetailStyle)OrderDetailStyle{
    
    if (OrderDetailStyle == OrderDetail_complainWithoutCancelOrder_Seller) {//联系买家&&我要申诉
        
        [self bigBtnWithTitle:@"我要申诉"];//V
        
    }else if (OrderDetailStyle == OrderDetail_complainWithConfirm_Seller){//联系买家&&我要申诉&&确认已收款，放行
        
        [self blueBtn:@"放行"];//?
        
        [self whiteBtn:@"我要申诉"];//?
        
    }else if (OrderDetailStyle == OrderDetail_cancelComplain_Seller){//联系买家&&取消申诉
        
        [self bigBtnWithTitle:@"取消申诉"];//
    }
}

-(void)ContactBuyerBtn:(OrderDetailStyle)OrderDetailStyle{
    
    if (OrderDetailStyle == OrderDetail_onlyContactBuyer_Seller) {
        
        UIButton *btn = UIButton.new;
        
        [btn addTarget:self
                action:@selector(contactBuyerBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:@"联系买家"
             forState:UIControlStateNormal];
        
        [btn setTitleColor:RGBCOLOR(76, 127, 255)
                  forState:UIControlStateNormal];
        
        [btn setImage:kIMG(@"contactSellerXi")
             forState:UIControlStateNormal];
        
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
        }];
    }else{
        
        self.contactBtn = JXButton.new;
        
        [self.contactBtn addTarget:self
                            action:@selector(contactBuyerBtnClickEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.contactBtn setTitle:@"联系买家"
                         forState:UIControlStateNormal];
        
        [self.contactBtn setImage:kIMG(@"contactSellerXi")
                         forState:UIControlStateNormal];
        
        [self.contactBtn setTitleColor:RGBCOLOR(76, 127, 255)
                              forState:UIControlStateNormal];
        
        [self addSubview:self.contactBtn];
        
        [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            
            make.left.equalTo(self).offset(18);
            
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 8 + 5, MAINSCREEN_WIDTH / 8));
        }];
    }
}

-(void)ContactSellerBtn:(OrderDetailStyle)OrderDetailStyle{
    
    if (OrderDetailStyle == OrderDetail_onlyContactSeller_Buyer) {
        
        UIButton *btn = UIButton.new;
        
        [btn setTitle:@"联系卖家"
             forState:UIControlStateNormal];
        
        [btn setImage:kIMG(@"contactSellerXi")
             forState:UIControlStateNormal];
        
        [btn setTitleColor:RGBCOLOR(76, 127, 255)
                  forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(contactSellerBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
        }];
    }else{
        
        self.contactBtn = JXButton.new;
        
        [self.contactBtn setTitle:@"联系卖家"
                         forState:UIControlStateNormal];
        
        [self.contactBtn setImage:kIMG(@"contactSellerXi")
                         forState:UIControlStateNormal];
        
        [self.contactBtn setTitleColor:RGBCOLOR(76, 127, 255)
                              forState:UIControlStateNormal];
        
        [self.contactBtn addTarget:self
                            action:@selector(contactSellerBtnClickEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.contactBtn];
        
        [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            
            make.left.equalTo(self).offset(18);
            
            make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 8 + 5, MAINSCREEN_WIDTH / 8));
        }];
    }
}

-(void)bigBtnWithTitle:(NSString *)titleStr{
    
    //我要申诉
    UIButton *btn = UIButton.new;
    
    if ([titleStr isEqualToString:@"我要申诉"]) {
        
        [NSObject colourToLayerOfView:btn
                           WithColour:RGBCOLOR(76, 127, 255)
                       AndBorderWidth:1];
        
        [btn setTitleColor:RGBCOLOR(76, 127, 255)
                  forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(wannaComplainBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([titleStr isEqualToString:@"取消申诉"]){
        
        [btn setBackgroundColor:RGBCOLOR(76, 127, 255)];
        
        [btn addTarget:self
                action:@selector(cancelComplainBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
    }else if ([titleStr isEqualToString:@"确认付款"]){
        
        [btn setBackgroundColor:RGBCOLOR(76, 127, 255)];
        
        [btn addTarget:self
                action:@selector(havePaidBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
    }
    
    [NSObject cornerCutToCircleWithView:btn
                        AndCornerRadius:4];
    
    [btn setTitle:titleStr
         forState:UIControlStateNormal];
    
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.contactBtn);
        
        make.right.equalTo(self).offset(-14);
        
        make.left.equalTo(self.contactBtn.mas_right);
    }];
}

-(void)blueBtn:(NSString *)titleStr{
    
    self.blueBtn = UIButton.new;
    
    [self.blueBtn setTitle:titleStr
                  forState:UIControlStateNormal];
    
    self.blueBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                   size:15];
    
    [NSObject cornerCutToCircleWithView:self.blueBtn
                        AndCornerRadius:4];
    
    [self.blueBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    
    [self addSubview:self.blueBtn];
    
    [self.blueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.contactBtn);
        
        make.width.mas_equalTo(MAINSCREEN_WIDTH / 3.5);
        
        make.right.equalTo(self).offset(-15);
    }];
}

-(void)whiteBtn:(NSString *)titleStr{
    
    self.whiteBtn = UIButton.new;
    
    [self.whiteBtn setTitle:titleStr
                   forState:UIControlStateNormal];
    
    [self.whiteBtn setTitleColor:RGBCOLOR(76, 127, 255)
                        forState:UIControlStateNormal];
    
    self.whiteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                    size:15];
    
    [NSObject cornerCutToCircleWithView:self.whiteBtn
                        AndCornerRadius:4];
    
    [NSObject colourToLayerOfView:self.whiteBtn
                       WithColour:RGBCOLOR(76, 127, 255)
                   AndBorderWidth:0.5f];
    
    [self addSubview:self.whiteBtn];
    
    [self.whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(MAINSCREEN_WIDTH / 3.5);
        
        make.top.bottom.equalTo(self.contactBtn);
        
        make.right.equalTo(self.blueBtn.mas_left).offset(-15);
    }];
}

#pragma mark - 我已付款点击事件
-(void)havePaidBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"我已付款");
    
    self.clickEventBlock(ClickEvent_havePaid);
}

#pragma mark - 确认已收款,放行 点击事件
-(void)confirmHaveGatheredBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"确认已收款,放行");
    
    self.clickEventBlock(ClickEvent_confirm);
}

#pragma mark - 联系卖家点击事件
-(void)contactSellerBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"联系卖家");
    
    self.clickEventBlock(ClickEvent_contactSeller);
}

#pragma mark - 联系买家点击事件
-(void)contactBuyerBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"联系买家");
    
    self.clickEventBlock(ClickEvent_contactBuyer);
}

#pragma mark - 取消订单点击事件
-(void)cancelOrderBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"取消订单");
    
    self.clickEventBlock(ClickEvent_cancelOrder);
}

#pragma mark - 现在去消费点击事件
-(void)nowToConsumeBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"现在去消费");
    
    self.clickEventBlock(ClickEvent_nowToConsume);
}

#pragma mark - 我要投诉点击事件
-(void)wannaComplainBtnClickEvent:(UIButton *)sender{
    
    //是否弹到交易完成界面这个信号是网络请求返回
    //暂时征用下入口
    
    NSLog(@"我要投诉");
    
    self.clickEventBlock(ClickEvent_wannaComplain);
}

#pragma mark - 查看我的资产点击事件
-(void)showMyPropertyBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"查看我的资产");
    
    self.clickEventBlock(ClickEvent_showMyProperty);
}

#pragma mark - 取消申诉点击事件
-(void)cancelComplainBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"取消申诉");
    
    self.clickEventBlock(ClickEvent_cancelComplain);
}

//#pragma mark - blueBtn点击事件


//弹窗关键代码 [self showInView:[UIApplication sharedApplication].keyWindow]
- (void)showInApplicationKeyWindow{
    
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    
    if (!view) return;
    
    [view addSubview:self];
    
    kWeakSelf(self);
    
    if (isiPhoneX_series) {//iphoneX
        
        [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT + 34, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             kStrongSelf(self);
                             
                             self.alpha = 1.0;
                             
                             [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - 34 - MAINSCREEN_HEIGHT / 13, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
                             
                         } completion:nil];
    }else{
        
        [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             kStrongSelf(self);
                             
                             self.alpha = 1.0;
                             
                             [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - MAINSCREEN_HEIGHT / 13, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
                             
                         } completion:nil];
    }
}

-(void)disappear{
    
    kWeakSelf(self);
    
    if (isiPhoneX_series) {//iphoneX
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             kStrongSelf(self);
                             
                             self.alpha = .0f;
                             
                             [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT + 34, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
                             
                         } completion:nil];
    }else{
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             kStrongSelf(self);
                             
                             self.alpha = .0f;
                             
                             [self setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT / 13)];
                             
                         } completion:nil];
    }
    
}

@end

