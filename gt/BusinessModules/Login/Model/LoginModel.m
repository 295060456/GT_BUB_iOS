//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "LoginModel.h"

#define kIdentityAuthTypeNone @"0"
#define kIdentityAuthTypeHandling @"1"
#define kIdentityAuthTypeRefuse @"2"
#define kIdentityAuthTypeFinished @"3"

#define kSeniorAuthTypeFinished  @"1"
#define kSeniorAuthTypeUndone    @"2"
@implementation LoginData
- (NSDictionary *) getSeniorAuthTypeName:(SeniorAuthType)type {
    NSDictionary* title = [NSDictionary dictionary];
    SeniorAuthType useType = type;
    switch (useType) {
        case SeniorAuthTypeFinished:
            title = @{@"认证成功":@"user_auth_finished"};
            break;
        case SeniorAuthTypeUndone:
            title = @{@"去认证":@"user_auth_none"};
            break;
        default:
            break;
    }
    return title;
}

- (SeniorAuthType) getSeniorAuthType:(NSString*)num{
    SeniorAuthType type = SeniorAuthTypeUndone;
    NSString *tag = num;//self.valiidnumber;
    if ([tag isEqualToString:kSeniorAuthTypeFinished])
    {
        type = SeniorAuthTypeFinished;
    }
    else if ([tag isEqualToString:kSeniorAuthTypeUndone]){
        type = SeniorAuthTypeUndone;
    }
    return type;
}

- (NSDictionary *) getIdentityAuthTypeName:(IdentityAuthType)type {
    NSDictionary* title = [NSDictionary dictionary];
    IdentityAuthType useType = type;
    switch (useType) {
        case IdentityAuthTypeHandling:
            title = @{@"审核中":@"user_auth_handling"};
            break;
        case IdentityAuthTypeRefuse:
            title = @{@"审核未通过":@"user_auth_refuse"};
            break;
        case IdentityAuthTypeFinished:
            title = @{@"认证成功":@"user_auth_finished"};
            break;
        case IdentityAuthTypeNone:
            title = @{@"去认证":@"user_auth_none"};
            break;
        default:
            break;
    }
    return title;
}

- (IdentityAuthType) getIdentityAuthType:(NSString*)num{
    IdentityAuthType type = IdentityAuthTypeNone;
    NSString *tag = num;//self.valiidnumber;
    if ([tag isEqualToString:kIdentityAuthTypeHandling])
    {
        type = IdentityAuthTypeHandling;
    }
    else if ([tag isEqualToString:kIdentityAuthTypeRefuse]){
        type = IdentityAuthTypeRefuse;
    }
    else if ([tag isEqualToString:kIdentityAuthTypeFinished]){
        type = IdentityAuthTypeFinished;
    }
    else
    {
        type = IdentityAuthTypeNone;
    }
    return type;
}

- (void) setUsername:(NSString *)username{
    _username = HandleStringNull(username);
}

- (void) setUserid:(NSString *)userid{
    _userid = HandleStringNull(userid);
}

@end

@implementation LoginModel

@end
