//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostAdsSubDataItem : NSObject

@property (nonatomic, strong) NSString * sid;
@property (nonatomic, strong) NSString * iid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * tit;
@property (nonatomic, strong) NSString * subtit;
@property (nonatomic, strong) NSString * attachtit;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * title;

@end

@interface PostAdsSubData : NSObject

@property (nonatomic, strong) NSArray * arr;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;

+(NSDictionary *)objectClassInArray;

@end

@interface PostAdsData : NSObject

@property (nonatomic, strong) NSArray * b;

+(NSDictionary *)objectClassInArray;

@end

@interface PostAdsResult : NSObject

@property (nonatomic, strong) PostAdsData * data;
@property (nonatomic, copy) NSString*  code;
@property (nonatomic, copy) NSString*  info;

@end

@interface PostAdsModel : NSObject

@property (nonatomic, copy) NSString * ugOtcAdvertId;
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * optionPrice;
@property (nonatomic, copy) NSString * prompt;
@property (nonatomic, copy) NSString * paymentWay;
@property (nonatomic, copy) NSString * number;

//@property (nonatomic, strong) PostAdsResult * result;

@end

@interface QueryUserPropertyModel: NSObject

@property(nonatomic,copy) NSString *errcode;//返回码：1、成功；3；未登录；9、系统异常
@property(nonatomic,copy) NSString *msg;//返回信息
@property(nonatomic,copy) NSString *usableFund;//可用资产
@property(nonatomic,copy) NSString *frozenFund;//冻结资产
@property(nonatomic,copy) NSString *amount;//总资产
@property(nonatomic,copy) NSString *convertRmb;//折合人民币
@property(nonatomic,copy) NSString *todaysaleablebalance;//今日可卖余额

@end

@interface PostAdvertisingModel :NSObject
/*
 返回信息    msg    String
 固额金额    price    String
 限额范围    optionPrice    String
 限时范围    prompt    String
 收款方式    paymentWay    String    
 */
@property(nonatomic,copy) NSString *errcode;
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,copy) NSString *number;
@property(nonatomic,copy) NSString *optionPrice;
@property(nonatomic,copy) NSString *paymentWay;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *prompt;

@end


