//
//  Buy_PaymentPopUpView.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,OrderDetailStyle){
    //买家界面状态
    OrderDetail_complainWithoutCancelOrder_Buyer = 0,//联系卖家&&我要申诉
    OrderDetail_complainWithCancelOrder_Buyer,//联系卖家&&取消订单&&我要申诉//
    OrderDetail_onlyContactSeller_Buyer,//联系卖家
    OrderDetail_showMyCapitalAndConsumeNow_Buyer,//联系卖家&&查看我的资产&&现在去消费//
    OrderDetail_havePaid_Buyer,// 联系卖家&&取消订单&&我已付款//
    OrderDetail_cancelComplain_Buyer,//联系卖家&&取消申诉
    OrderDetail_complainWithConfirm_Buyer,//联系卖家&&点击确认付款
    
    //卖家界面状态
    OrderDetail_onlyContactBuyer_Seller,//联系买家
    OrderDetail_complainWithoutCancelOrder_Seller,//联系买家&&我要申诉
    OrderDetail_complainWithConfirm_Seller,//联系买家&&我要申诉&&确认已收款，放行//
    OrderDetail_cancelComplain_Seller//联系买家&&取消申诉
};

typedef NS_ENUM(NSUInteger,ClickEvent){

    ClickEvent_contactSeller = 0,//联系卖家//
    ClickEvent_cancelOrder,//取消订单//
    ClickEvent_havePaid,//我已付款//
    ClickEvent_nowToConsume,//现在去消费//
    ClickEvent_wannaComplain,//我想投诉//
    ClickEvent_cancelComplain,//取消申诉//
    ClickEvent_showMyProperty,//查看我的资产
    ClickEvent_contactBuyer,//联系买家//
    ClickEvent_confirm//确认收款放行//
    
};

NS_ASSUME_NONNULL_BEGIN

@interface Buy_PaymentPopUpView : UIView

@property(nonatomic,copy)void(^clickEventBlock)(ClickEvent);

@property(nonatomic,strong)UIButton *blueBtn;

-(instancetype)initWithOrderDetailStyle:(OrderDetailStyle)orderDetailStyle;

- (void)showInApplicationKeyWindow;

-(void)disappear;

@end

NS_ASSUME_NONNULL_END
