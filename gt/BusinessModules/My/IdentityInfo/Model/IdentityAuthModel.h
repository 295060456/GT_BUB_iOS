//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityAuthData : NSObject
@property (nonatomic, copy) NSString*  amountType;
@property (nonatomic, copy) NSString*  paymentway;
@property (nonatomic, copy) NSString*  createdtime;

@property (nonatomic, copy) NSString*  orderAllNumber;
@property (nonatomic, copy) NSString*  orderTotle;
@property (nonatomic, copy) NSString*  fixedAmount;
@property (nonatomic, copy) NSString*  ugOtcAdvertId;

@property (nonatomic, copy) NSString*  userId;

@property (nonatomic, copy) NSString*  price;
@property (nonatomic, copy) NSString*  nickName;
@property (nonatomic, copy) NSString*  successRate;
@property (nonatomic, copy) NSString* limitMinAmount;
@property (nonatomic, copy) NSString* limitMaxAmount;
@property (nonatomic, copy) NSString*  number;
@property (nonatomic, copy) NSString*  userName;
@property (nonatomic, copy) NSString*  isVip;


@end


@interface IdentityAuthModel : NSObject
@property (nonatomic, copy) NSString*  contact;
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, strong) NSArray * advert;
+(NSDictionary *)objectClassInArray;
@end
