//
//  PostAppealCompleteVM.m
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAppealCompleteVM.h"
#import "PostAppealCompleteModel.h"
//#import "EventListAllMessage.h"
#import "EventListModel.h"


typedef NS_ENUM(NSUInteger,CharacterEnum){
    completeAppealSuccess = 0,
    completeAntiAppealSuccess,
    completeAppealFailure,
};


@implementation PostAppealCompleteVM
+ (void)getPostAppealCompleteDataWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    EventListAllMessage *messageModel = (EventListAllMessage *)requestParams;
    
    NSDictionary *params = @{
                             @"appealId": messageModel.param.appealId,
                             };
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];

    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealComplete]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         [SVProgressHUD dismiss];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             PostAppealCompleteModel *model = [PostAppealCompleteModel  mj_objectWithKeyValues:dic];
                                                            NSString *status = model.status;
                                                             if (status && status.length > 0) {
                                                                 NSInteger myEnum = [status integerValue];
                                                                 if (myEnum == 3 || myEnum == 6) {
                                                                     model.topImageName = [[self class] getTopImageName:completeAppealFailure];
                                                                 }else if (myEnum == 2 || myEnum == 5 ){
                                                                     LoginModel* modelUser = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                                                                     NSString* userid = modelUser.userinfo.userid;
                                                                     if ([userid isEqualToString:model.appellantId]) {
                                                                         model.topImageName = [PostAppealCompleteVM getTopImageName:completeAppealSuccess];
                                                                     }else{
                                                                         model.topImageName = [PostAppealCompleteVM getTopImageName:completeAntiAppealSuccess];
                                                                     }
                                                                 }else{
                                                                     model.topImageName = @"";
                                                                 }
                                                             }else{
                                                                 model.topImageName = @"";
                                                             }
                                                             
                                                             model.titelString = [NSString stringWithFormat:@"%@",messageModel.title];
                                                             model.orderIDSring = [NSString stringWithFormat:@"交易订单号:%@",model.orderNo];
                                                             model.contentString = [NSString stringWithFormat:@"%@",messageModel.content];
                                                            
                                                              model.buttonTitelSring = @"";
                                                             if ([model.reason isEqualToString:@"1_B_1_2"]) { // 卖家无收款信息
                                                                 LoginModel* modelUser = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                                                                 NSString* userid = modelUser.userinfo.userid;
                                                                 if ([userid isEqualToString:model.appellantId] && [model.type isEqualToString:@"2"]) { // 我是上诉人
                                                                     model.buttonTitelSring = @"前往修改";
                                                                 }else if ([userid isEqualToString:model.appelleeId] && [model.type isEqualToString:@"1"]){ //我是被上诉人
                                                                      model.buttonTitelSring = @"前往修改";
                                                                 }
                                                             }
                                                             success(model);
                                                         }else{
                                                             [SVProgressHUD dismiss];
                                                             [YKToastView showToastText:@"获取数据失败!"];
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                     }];
}


+(NSString*)getTopImageName:(NSInteger)item{
    switch (item) {
        case completeAppealSuccess: // 申诉成功
             return @"shensuchenggXi";
        case completeAntiAppealSuccess: // 被申诉成功
            return @"beishensuchenggongXi";
        case completeAppealFailure: // 申诉失败
            return @"shensushibaiXi";
        default:
            break;
    }
    return @"";
}

@end
