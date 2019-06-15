//
//  ChatViewController.h
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageLayout.h"
#import "ChatDatas.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController


//单聊 群聊
@property(nonatomic,assign)   ChatConversationType chatType;
//会话id
@property (nonatomic, strong) NSString    *sessionId;

//名字
@property (nonatomic, strong) NSString    *titleString;

@end

NS_ASSUME_NONNULL_END
