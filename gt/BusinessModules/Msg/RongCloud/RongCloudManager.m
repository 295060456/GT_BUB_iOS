//
//  RongCloudManager.m
//  OTC
//
//  Created by Dodgson on 1/17/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import "RongCloudManager.h"
#import "OTCConversionVC.h"
#import "LoginModel.h"
@interface RongCloudManager ()

@end

@implementation RongCloudManager

+ (void)load{
    [super load];
}

+ (void)logout{
    [[RCIM sharedRCIM] logout];
}

+ (void)updateNickName:(NSString *)nickName userId:(NSString *)userId{
    RCUserInfo *rcUser = [[RCUserInfo alloc] initWithUserId:userId name:nickName portrait:@""];
    [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:YES];
    [[RCIM sharedRCIM] setCurrentUserInfo:rcUser];
    [[RCIM sharedRCIM] refreshUserInfoCache:rcUser withUserId:userId];
}

+ (void)loginWith:(NSString *)token
          success:(void (^)(NSString *userId))successBlock
        userModel:(LoginModel *)userModel
            error:(void (^)(RCConnectErrorCode status))errorBlock
   tokenIncorrect:(void (^)(void))tokenIncorrectBlock{
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        RCUserInfo *rcUser = [[RCUserInfo alloc] initWithUserId:userId
                                                           name:userModel.userinfo.nickname
                                                       portrait:@""];
        [[RCIM sharedRCIM] setCurrentUserInfo:rcUser];
        
        [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:YES];
        
        [[RCIM sharedRCIM] refreshUserInfoCache:rcUser
                                     withUserId:userId];
        
        successBlock(userId);
    } error:^(RCConnectErrorCode status) {
        errorBlock(status);
    } tokenIncorrect:^{
        tokenIncorrectBlock();
    }];

}

+ (void)loginWith:(NSString *)token
          success:(void (^)(NSString *userId))successBlock
            error:(void (^)(RCConnectErrorCode status))errorBlock
   tokenIncorrect:(void (^)(void))tokenIncorrectBlock{
    
    [[RCIM sharedRCIM] connectWithToken:token
                                success:^(NSString *userId) {
        successBlock(userId);
    } error:^(RCConnectErrorCode status) {
        errorBlock(status);
    } tokenIncorrect:^{
        tokenIncorrectBlock();
    }];
}

+ (void)jumpNewSessionWithSessionId:(NSString *)sessionId
                       navigationVC:(UINavigationController *)navigationVC{
    
    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                                               targetId:sessionId];
    //设置聊天会话界面要显示的标题
//    chat.title = @"想显示的会话标题";
    //显示聊天会话界面
//    [chat setTitle:@"123"];
    [navigationVC pushViewController:chat animated:YES];
}

+ (void)jumpNewSessionWithSessionId:(NSString *)sessionId
                              title:(NSString *)title
                       navigationVC:(UINavigationController *)navigationVC{
    
//    if([sessionId isEqualToString:@"title"]){
//        NSArray *usersArr = @[sessionId];
//        NSDictionary *param = @{};
//        NSMutableString *users = @"".mutableCopy;
//        for (NSInteger i = 0; i < usersArr.count; i++) {
//            if(i == usersArr.count - 1){
//                [users appendString:[usersArr objectAtIndex:i]];
//            }else{
//                [users appendString:[usersArr objectAtIndex:i]];
//                [users appendString:@","];
//            }
//        }
//        param = [param vic_appendKey:@"userIds" value:users.copy];
//
//        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_FetchNickName] andType:All andWith:param success:^(NSDictionary *dic) {
//            LoginModel* model = [LoginModel mj_objectWithKeyValues:dic];
//            if ([NSString getDataSuccessed:dic]) {
//                for (NSDictionary *dict in model.userNickname) {
//                    NSString *nickName;
//                    if([[dict objectOrNilForKey:@"userId"] isEqualToString:sessionId]){
//                        nickName = [dict objectOrNilForKey:@"nickname"];
//                        break;
//                    }
//                    if(nickName.length > 0){
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            OTCConversionVC *conversationVC = [[OTCConversionVC alloc]init];
//                            conversationVC.conversationType =ConversationType_PRIVATE;
//                            //一般在这个数据模型里会有每一个联系人的UserId，姓名，然后title一般和用户名一样即可
//                            conversationVC.targetId = sessionId;
//                            conversationVC.userName = nickName;
//                            conversationVC.title = nickName;
//                            [navigationVC pushViewController:conversationVC animated:YES];
//                        });
//                    }else{
//                        OTCConversionVC *conversationVC = [[OTCConversionVC alloc]init];
//                        conversationVC.conversationType =ConversationType_PRIVATE;
//                        //一般在这个数据模型里会有每一个联系人的UserId，姓名，然后title一般和用户名一样即可
//                        conversationVC.targetId = sessionId;
//                        conversationVC.userName = nickName;
//                        conversationVC.title = nickName;
//                        [navigationVC pushViewController:conversationVC animated:YES];
//                    }
//                }
//
//
//            }
//            else{
//
//            }
//        } error:^(NSError *error) {
//
//        }];
//
//
//    }else{
//        OTCConversionVC *conversationVC = [[OTCConversionVC alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        //一般在这个数据模型里会有每一个联系人的UserId，姓名，然后title一般和用户名一样即可
//        conversationVC.targetId = sessionId;
//        conversationVC.userName = title;
//        conversationVC.title = title;
//        [navigationVC pushViewController:conversationVC animated:YES];
//    }
    
    OTCConversionVC *conversationVC = [[OTCConversionVC alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    //一般在这个数据模型里会有每一个联系人的UserId，姓名，然后title一般和用户名一样即可
    conversationVC.targetId = sessionId;
    conversationVC.userName = title;
    conversationVC.title = title;
    [navigationVC pushViewController:conversationVC animated:YES];
}
//+ (instancetype)shareInstance{
//    static RongCloudManager *shareInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        shareInstance = [[self alloc] init];
//    });
//    return shareInstance;
//
//
//}

@end
