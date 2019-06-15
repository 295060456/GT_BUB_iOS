//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TransactorInfoData : NSObject
@property (nonatomic, copy) NSString *releaseTimeAverage;

@property (nonatomic, copy) NSString *isVip;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *successRate;
@property (nonatomic, copy) NSString *orderTotle;
@property (nonatomic, copy) NSString *isGuarantee;
@property (nonatomic, copy) NSString *isAuthentication;

@property (nonatomic, copy) NSString*  isSellerIdNumber;
@property (nonatomic, copy) NSString*  isSellerSeniorAuth;
- (NSString*) getPriorityImageName;
@end

@interface TransactorInfoModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) TransactorInfoData * merchantInfo;
@end
