//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionSubPageData : NSObject
@property (nonatomic, copy) NSString * pageno;
@property (nonatomic, copy) NSString * pagesize;
@property (nonatomic, copy) NSString * sum;
@end

@interface TransactionData : NSObject
@property (nonatomic, copy) NSString*  autoReplyContent;//下单自动回复
@property (nonatomic, copy) NSString*  amountType;//金额类型 : 1、限额 2、固额
@property (nonatomic, copy) NSString*  paymentway;//支付方式 : 1、微信 2、支付宝 3、银行卡
@property (nonatomic, copy) NSString*  createdtime;//创建时间

@property (nonatomic, copy) NSString*  orderAllNumber;//交易量
@property (nonatomic, copy) NSString*  orderTotle;//交易次数
@property (nonatomic, copy) NSString*  fixedAmount;//固额数量
@property (nonatomic, copy) NSString*  ugOtcAdvertId;//广告ID

@property (nonatomic, copy) NSString*  userId;//用户ID

@property (nonatomic, copy) NSString*  price;//价钱
@property (nonatomic, copy) NSString*  nickName;//商家昵称
@property (nonatomic, copy) NSString*  successRate;//成功率
@property (nonatomic, copy) NSString*  limitMinAmount;//限额最小
@property (nonatomic, copy) NSString*  limitMaxAmount;//限额最大
@property (nonatomic, copy) NSString*  number;//数量
@property (nonatomic, copy) NSString*  prompt;//付款期限: 单位:秒
@property (nonatomic, copy) NSString*  username;//用户名
@property (nonatomic, copy) NSString*  isVip;//商家是否为VIP:1-是 2-否

@property (nonatomic, copy) NSString*  balance;//库存
@property (nonatomic, copy) NSString*  isSellerIdNumber;//商家是否实名认证:1-是 2-否
@property (nonatomic, copy) NSString*  isSellerSeniorAuth;//商家是否高级认证: 1-是 2-否

@property (nonatomic, copy) NSString*  isSeniorCertification; // 是否需要高级认证
@property (nonatomic, copy) NSString*  isIdNumber;//商家是否高级认证: 1-是 2-否


- (NSString*) getPriorityImageName;
- (NSString*) getRateName;
- (NSString*) getPaymentwayName;
- (NSString *) getTransactionAmountTypeName;
- (BOOL) isBuyAvailable;
- (TransactionAmountType)getTransactionAmountType;

@end


@interface TransactionModel : NSObject
@property (nonatomic, strong) TransactionSubPageData* page;
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, copy) NSArray * advert;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * optionPrice;
+(NSDictionary *)objectClassInArray;
@end
