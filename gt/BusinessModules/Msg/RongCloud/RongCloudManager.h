//
//  RongCloudManager.h
//  OTC
//
//  Created by Dodgson on 1/17/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "LoginModel.h"


@interface RongCloudManager : NSObject

+ (void)updateNickName:(NSString *)nickName userId:(NSString *)userId;


+ (void)logout;

+ (void)loginWith:(NSString *)token
          success:(void (^)(NSString *userId))successBlock
            error:(void (^)(RCConnectErrorCode status))errorBlock
   tokenIncorrect:(void (^)(void))tokenIncorrectBlock;

+ (void)loginWith:(NSString *)token
          success:(void (^)(NSString *userId))successBlock
        userModel:(LoginModel *)userModel
            error:(void (^)(RCConnectErrorCode status))errorBlock
   tokenIncorrect:(void (^)(void))tokenIncorrectBlock;


//+ (void)jumpNewSessionWithSessionId:(NSString *)sessionId navigationVC:(UINavigationController *)navigationVC;

+ (void)jumpNewSessionWithSessionId:(NSString *)sessionId title:(NSString *)title navigationVC:(UINavigationController *)navigationVC;


@end
