//
//  ChatModel.h
//  gt
//
//  Created by cookie on 2018/12/28.
//  Copyright © 2018 GT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatModel : NSObject

@property(nonatomic, strong) NSString *chatUserId;
@property(nonatomic, strong) RCMessageContent *lastestMessage;


/*!
 会话中最后一条消息的发送者用户ID
 */
@property(nonatomic, copy) NSString *senderUserId;

/*!
 会话中最后一条消息的发送时间（Unix时间戳、毫秒）
 */
@property(nonatomic, assign) long long sentTime;

/*!
 会话中的未读消息数
 */
@property(nonatomic, assign) NSInteger unreadMessageCount;

/*!
 会话中最后一条消息的方向
 */
@property(nonatomic, assign) RCMessageDirection lastestMessageDirection;

/*!
 会话中最后一条消息的json Dictionary
 */
@property(nonatomic, strong) NSDictionary *jsonDict;

@end

NS_ASSUME_NONNULL_END
