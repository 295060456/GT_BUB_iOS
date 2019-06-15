//
//  AppealProgressModel.h
//  gt
//
//  Created by 鱼饼 on 2019/4/29.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OrderDetailModel.h"

typedef NS_ENUM(NSUInteger,AppealProgressType){
    progressExamImageType = 0,   // 查看凭证
    progressContactSellers  , // 联系卖家
    progressContactBuyer,  // 联系买家
    progressGotoSellerAppeal, //去申诉
    progressCancelAppeal,  // 取消申诉
    progressReleaseBUB,  // 放行BUB
    progressContactOrder,  // 取消订单
    progressZZToAppeal, //我已转账,我要申诉
    progressNotReceived, // 未收到汇款
    progressQXFAppeal //您已发起反申诉，点击取消

};


NS_ASSUME_NONNULL_BEGIN

@interface AppealProgressModel : OrderDetailModel
//
@property (nonatomic, copy) NSDictionary *appeal;
@property (nonatomic, copy) NSString *appealReason;
@property (nonatomic, copy) NSString *appealType;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, assign) BOOL isBuy; //是买家

@property (nonatomic, assign) AppealProgressType buttomActionType; //

@property (nonatomic, strong) NSString *titelS; //

@property (nonatomic, assign) BOOL isAppealer; // w我是申诉人

@property (nonatomic, strong) NSString *buttomTitelS; //

@property (nonatomic, strong) NSString *appealContentS; //


@property (nonatomic, strong) NSString *actionTime; //

@end

NS_ASSUME_NONNULL_END
