//
//  BuyBubDetailBuyView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger,BuyTapType){
    BuyTapTypeToOrthApp  = 0 , // 跳转 到其他APP  1 跳微信 2 支付宝
    BuyTapTypeContactOther, // 联系对方
    BuyTapTypeTimeReloadDa, // 所有刷新数据  （倒计时结束）
    BuyTapTypeCancelOrders,// 取消订单
    BuyTapTypeToAppeal,// 去申诉
    BuyTapTypeSellReleaseOrders, // 卖家确认收款，放行订单
    BuyTapTypeSeeMyaSsets, // 查看我的资产";
    BuyTapTypeSeeToConsumption, // 现在去消费;
    BuyTapTypeCloseAppeal, // 取消申诉
    BuyTapTypeBuyRelease, // 买家确认已付款
};


NS_ASSUME_NONNULL_BEGIN

@interface BuyBubDetailBuyView : UIView
-(instancetype)initWithFrame:(CGRect)frame actionBlock:(DataTypeBlock)block;
-(void)reloadTableViewDataWith:(nullable id)data andHeaderTitleAr:( nullable NSArray*)ar; // 刷新数据
@end

NS_ASSUME_NONNULL_END
