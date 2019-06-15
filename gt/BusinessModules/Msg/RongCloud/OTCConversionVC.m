//
//  OTCConversionVC.m
//  OTC
//
//  Created by Dodgson on 2/15/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import "OTCConversionVC.h"

@interface OTCConversionVC ()<RCIMUserInfoDataSource>

@end

@implementation OTCConversionVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:self.targetId];//20000031   self.targetId

    if(userInfo){
        if(userInfo.name){
            [self setTitle:userInfo.name];
        }
//        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:self.targetId];
//        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:self.targetId];
        
//        //默认输入类型为语音,这里修改为默认显示加号区域
//        self.defaultInputType = RCChatSessionInputBarInputVoice;
        
//        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_SWITCH];
        
//        self.pluginBoardView;
//        *
//        升级说明：如果您之前使用了此属性，可以直接替换为chatSessionInputBarControl的pluginBoardView属性，行为和实现完全一致。
        
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
        
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:1];
    }
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:userId];
    
    completion(userInfo);
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    switch (status) {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT: {           // 被踢下线
            
            break;
        }
        default:
            break;
    }
}

@end
