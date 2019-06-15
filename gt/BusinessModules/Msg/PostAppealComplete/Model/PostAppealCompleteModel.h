//
//  PostAppealCompleteModel.h
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger,AppealButtonType){
    custServiceType = 0 , // 联系客服
    examImageType,   // 查看凭证
    contentType,  // 修改账号
};



@interface PostAppealCompleteModel : NSObject
@property (nonatomic, copy) NSString * actionTime;
@property (nonatomic, copy) NSString *appealId;
@property (nonatomic, copy) NSString *appellantId;
@property (nonatomic, copy) NSString *appelleeId;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) NSString *errcode;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;


@property (nonatomic, strong) NSString *topImageName;
@property (nonatomic, strong) NSString *titelString;
@property (nonatomic, strong) NSString *orderIDSring;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) NSString *buttonTitelSring;

@end

NS_ASSUME_NONNULL_END
