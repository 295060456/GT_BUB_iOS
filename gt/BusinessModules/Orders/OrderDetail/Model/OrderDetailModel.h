//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailData : NSObject

@property (nonatomic, copy) NSString * restTime;    //（实际和接口文档均无）
@property (nonatomic, copy) NSString *paymentWayId;       // 付款方式ID
@property (nonatomic, copy) NSString *paymentWay;       // 收款方式:1、微信;2、支付宝;3、银行卡
@property (nonatomic, copy) NSString *name;       // 收款人
@property (nonatomic, copy) NSString *account;       // 收款账号
@property (nonatomic, copy) NSString *QRCode;       // 收款二维码
@property (nonatomic, copy) NSString *accountOpenBank;       // 开户银行
@property (nonatomic, copy) NSString *accountOpenBranch;       // 开户支行
@property (nonatomic, copy) NSString *accountBankCard;       // 银行账号
@property (nonatomic, copy) NSString *status; // 收款方式状态1-启用 2-停用  （实际返回有,但是接口文档没有）//1、未付款 2、已付款 3、已完成 4、已取消 5、已关闭(自动) 6、申诉中

@end

@interface OrderDetailModel : NSObject

//原先他们写的
//@property (nonatomic, copy) NSString*  errcode;
//@property (nonatomic, copy) NSString*  msg;

@property (nonatomic, copy) NSString *brokerage;       //手续费
@property (nonatomic, copy) NSString *status;       //订单状态
@property (nonatomic, copy) NSString *orderType;
//@property (nonatomic, copy) NSString *createdTime;       //订单创建时间
//@property (nonatomic, copy) NSString *paymentNumber;       //订单创建时间
//@property (nonatomic, copy) NSString *prompt;       //付款期限
//@property (nonatomic, copy) NSString *buyUserId;       //买家ID
//@property (nonatomic, copy) NSString *orderNo;       //订单号
@property (nonatomic, copy) NSString *price;       //单价
@property (nonatomic, copy) NSString *number;       //成交数量
@property (nonatomic, copy) NSString *isEvaluation;       //订单是否评价
//@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *txHash;
@property (nonatomic, copy) NSString *orderSellIsVip;
@property (nonatomic, copy) NSString *sellerName;
@property (nonatomic, copy) NSString *buyerName;
@property (nonatomic, copy) NSString * restTime;
@property (nonatomic, copy) NSString *appealId;
//@property (nonatomic, copy) NSString *sellUserId;       //卖家ID
@property (nonatomic, copy) NSString *advertId;       //广告ID
@property (nonatomic, copy) NSString *otcOrderId;       //订单ID
@property (nonatomic, copy) NSString *modifyTime;       //订单修改时间
@property (nonatomic, copy) NSString *paymentTime;       //订单付款时间(买)
@property (nonatomic, copy) NSString *finishTime;       //订单完成时间
@property (nonatomic, copy) NSString *confirmTime;       //订单确定时间(卖)
@property (nonatomic, copy) NSString *closeTime;       //订单关闭时间
@property (nonatomic, copy) NSString *paymentWayString; //orderlist distribute
//@property (nonatomic, copy) NSArray *paymentWay;       //detail订单关闭时间
@property (nonatomic, copy) NSString*  isSellerIdNumber;
@property (nonatomic, copy) NSString*  isSellerSeniorAuth;

//我自己写的,和原先冲突则屏蔽原先的
@property(nonatomic,copy)NSString *errcode;//返回码// 1-成功，2-请求参数类错误，3-未登录，9-系统异常，10-未设置支付密码，11-普通用户额度不够，12-实名认证用户额度不够，13-高级认证用户额度不够
@property(nonatomic,copy)NSString *msg;//返回的消息//
@property(nonatomic,copy)NSString *orderId;//订单ID//
@property(nonatomic,copy)NSString *orderNo;//订单号//
@property(nonatomic,copy)NSString *orderAmount;//订单金额//
@property(nonatomic,copy)NSString *orderPrice;//订单单价//
@property(nonatomic,copy)NSString *orderNumber;//订单数量//
@property(nonatomic,copy)NSString *buyUserId;//买家ID//
@property(nonatomic,copy)NSString *sellUserId;//卖家ID//
@property(nonatomic,copy)NSString *rongyunToken;//卖家token//
@property(nonatomic,copy)NSString *createdTime;//订单创建时间//
@property(nonatomic,copy)NSString *prompt;//付款期限 单位:秒//
@property(nonatomic,copy)NSString *paymentNumber;//付款参考号//
@property(nonatomic,strong)OrderDetailData *paymentWay;//收款方式信息//

+(NSDictionary *)objectClassInArray;
- (NSString*) getPriorityImageName;
- (NSString *) getTransactionOrderTypeFooterSubTitle;
- (NSString *) getTransactionOrderTypeImageName;//
- (NSString *) getTransactionOrderTypeSubTitle;
- (NSString *) getTransactionOrderTypeTitle;//
- (OrderType) getTransactionOrderType;//
- (NSString *) getOccurOrderTypeTitle;//
- (OccurOrderType) getOccurOrderType;
- (UserType) getUserType;

-(NSArray*)getPaywayAppendingDicArr;
-(NSString*)getPaywayAppendingString;
-(NSArray*)getPayways;


@end
