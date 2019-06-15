//
//  MsgModel.h


NS_ASSUME_NONNULL_BEGIN
@interface MsgModelPage : NSObject
@property (nonatomic, copy) NSString *pageno;       //
@property (nonatomic, copy) NSString *pagesize;       //
@property (nonatomic, copy) NSString *sum;       //
@end

@interface MsgData : NSObject
@property (nonatomic,copy)NSString *sendNickName; //消息发送者昵称
@property (nonatomic,copy)NSString *content; //消息内容
@property (nonatomic,copy)NSString *createdTime; //
@property (nonatomic,copy)NSString *isNoRead; //
@property (nonatomic,copy)NSString *orderId; //

@property (nonatomic,copy)NSString *amount; //
@property (nonatomic,copy)NSString *status; //
@property (nonatomic,copy)NSString *sendUserId; //

@end

@interface MsgModel : NSObject
@property (nonatomic, copy) NSString *msg;       //
@property (nonatomic, copy) NSString *errcode;
@property (nonatomic,copy)NSArray *messageList;
@property (nonatomic,strong) MsgModelPage * page;
+ (NSDictionary *)objectClassInArray;
@end

NS_ASSUME_NONNULL_END
