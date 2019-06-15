//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoginData : NSObject
@property (nonatomic, copy) NSString * idCardFont;
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSString * istrpwd;
@property (nonatomic, copy) NSString * isPaymentWay;
@property (nonatomic, copy) NSString * valigooglesecret;
@property (nonatomic, copy) NSString * valiidnumber;//是否实名认证 : 0-未审核，1-待审核，2-审核未通过，3-审核通过
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * safeverifyswitch;
@property (nonatomic, copy) NSString * googlesecret;

@property (nonatomic, copy) NSString * useravator;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * userType;
@property (nonatomic, copy) NSString *idnumber;
@property (nonatomic, copy) NSString *idNumberAmount;
@property (nonatomic, copy) NSString *isIdNumber;
@property (nonatomic, copy) NSString *isSeniorCertification;
@property (nonatomic, copy) NSString *seniorCertificationAmount;

- (NSDictionary *) getIdentityAuthTypeName:(IdentityAuthType)type;
- (IdentityAuthType) getIdentityAuthType:(NSString*)num;

- (NSDictionary *) getSeniorAuthTypeName:(SeniorAuthType)type;
- (SeniorAuthType) getSeniorAuthType:(NSString*)num;
@end


@interface LoginModel : NSObject
@property (nonatomic, copy) NSArray *userNickname;
@property (nonatomic, copy) NSString*  servertime;
@property (nonatomic, copy) NSString*  loginname;
@property (nonatomic, strong) LoginData * userinfo;
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  userid;
@property (nonatomic, copy) NSString *rongyunToken;
@property (nonatomic, copy) NSString *rytoken;
@end
