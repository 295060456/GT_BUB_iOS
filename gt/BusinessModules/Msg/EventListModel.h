//
//  EventListModel.h


NS_ASSUME_NONNULL_BEGIN
@interface EventListTypeModel : NSObject
@property (nonatomic, copy) NSString *orderId;       //
@property (nonatomic, copy) NSString *otcOrderId;       //
@property (nonatomic, copy) NSString *pageType;       //
@property (nonatomic, copy) NSString *appealId;
@end
@interface EventListPageModel : NSObject
@property (nonatomic, copy) NSString *pageno;       //
@property (nonatomic, copy) NSString *pagesize;       //
@property (nonatomic, copy) NSString *sum;       //
@end

@interface EventListAllMessage : NSObject
@property (nonatomic, strong)EventListTypeModel*  param;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *messageId;       //
@property (nonatomic, copy) NSString *content;       //
@property (nonatomic, copy) NSString *type;       //
@property (nonatomic, copy) NSString *createdTime;       //
@end

@interface EventListModel : NSObject
@property (nonatomic, copy) NSString *msg;       //
@property (nonatomic, copy) NSString *errcode;
@property (nonatomic, copy) NSArray *allMessage;       //
@property (nonatomic, strong) EventListPageModel *page;       //
+(NSDictionary *)objectClassInArray;
@end

NS_ASSUME_NONNULL_END

