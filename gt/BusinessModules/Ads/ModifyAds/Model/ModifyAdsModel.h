//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModifyAdsModel : NSObject
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, copy) NSString*  msg;

@property (nonatomic, copy) NSString * ugOtcAdvertId;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * amountType;
@property (nonatomic, copy) NSString * limitMaxAmount;
@property (nonatomic, copy) NSString * limitMinAmount;
@property (nonatomic, copy) NSString * fixedAmount;
@property (nonatomic, copy) NSString * paymentWayIds;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * createdtime;

@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * paymentway;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * prompt;
@property (nonatomic, copy) NSString * autoReplyContent;

@property (nonatomic, copy) NSString*  isIdNumber;
@property (nonatomic, copy) NSString * isSeniorCertification;
@property (nonatomic, copy) NSString * isMerchantsTrade;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * balance;

@property (nonatomic, copy) NSString* usableFund;

@property (nonatomic, strong) UIColor *statusLabColor;

- (NSString *) getOccurAdsTypeName;
- (OccurAdsType) getOccurAdsType;
@end
