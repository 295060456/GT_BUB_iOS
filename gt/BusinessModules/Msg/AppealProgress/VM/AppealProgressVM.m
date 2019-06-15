//
//  AppealProgressVM.m
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealProgressVM.h"
#import "AppealProgressModel.h"
#import "PostAppealCompleteModel.h"

@implementation AppealProgressVM

+ (void)getPostAppealCompleteDataWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    NSDictionary *params = @{
                             @"orderId": requestParams
                             };
    
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionOrderDetail]
                                                      andType:All
                                                      andWith:params
                                                      success:^(NSDictionary *dic) {
//                                                          kStrongSelf(self);
//                                                          NSLog(@"dic = %@",dic);
                                                         AppealProgressModel *mo = [AppealProgressModel mj_objectWithKeyValues:dic];
                                                        
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              NSString *appealID = mo.appealId? mo.appealId:@"123";
                                                              NSDictionary *par = @{
                                                                                       @"appealId": appealID,
                                                                                       };
                                                              [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealComplete] andType:All andWith:par success:^(NSDictionary *dics) {
                                                                  
                                                                   NSLog(@"dic = %@",dics);
                                                                   PostAppealCompleteModel *appealModel = [PostAppealCompleteModel  mj_objectWithKeyValues:dics];
                                                                  
                                                                  
                                                                  LoginModel* modelUser = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                                                                  NSString* userid = modelUser.userinfo.userid;
                                                                
                                                                  if ([userid isEqualToString:appealModel.appellantId]) {
                                                                     // 我是申诉人
                                                                      mo.isAppealer = YES;
                                                                      mo.titelS = @"申诉中";
                                                                      mo.appealContentS = @"币友团队将会在7个工作日内审核完成，并将结果传送至您的信箱，请耐心等候，谢谢！";
                                                                  }else{
                                                                      // 我是被申诉人
                                                                      mo.isAppealer = NO;
                                                                      mo.titelS = @"被申诉中";
                                                                      mo.appealContentS = [AppealProgressVM toAppealReasonWithSrting:appealModel.reason];
                                                                  }
                                                                  mo.status = appealModel.status;
                                                                  mo.appealReason = [AppealProgressVM appealReasonWithSrting:appealModel.reason];
                                                                  mo.reason = appealModel.reason;
                                                                  mo.appealType = [AppealProgressVM typeToSring:[NSString stringWithFormat:@"%@",appealModel.status]];
                                                                  mo.actionTime = appealModel.actionTime;
                                                                 success(mo);
                                                              } error:^(NSError *error) {
                                                                   [YKToastView showToastText:mo.msg];
                                                              }];
//                                                              err(error);
//                                                              [YKToastView showToastText:error.description];
                                                          }
                                                          else{
                                                              failed(mo);
                                                              [YKToastView showToastText:mo.msg];
                                                          }
                                                      } error:^(NSError *error) {
                                                          err(error);
                                                          [YKToastView showToastText:error.description];
                                                      }];
}



+(NSString*)appealReasonWithSrting:(NSString*)string{
    NSString *typeS = @"";
    if ([string isEqualToString:@"0_B_1_5"]) {
        typeS = @"其他原因";
    }else if ([string isEqualToString:@"1_B_1_5"]){
        typeS = @"卖家提供错误付款信息";
    }else if ([string isEqualToString:@"2_B_1_5"]){
        typeS = @"已付款，但未在时间内点击确认付款";
    }else if ([string isEqualToString:@"0_B_1_2"]){
        typeS = @"";
    }else if ([string isEqualToString:@"1_B_1_2"]){
        typeS = @"付款后卖方不放行BUB";
    }else if ([string isEqualToString:@"0_S_1_2"]){
        typeS = @"其他原因";
    }else if ([string isEqualToString:@"1_S_1_2"]){
        typeS = @"买方未付款却标记已付款";
    }
    return typeS;
    
}



+(NSString*)toAppealReasonWithSrting:(NSString*)string{
    NSString *typeS = @"";
    if ([string isEqualToString:@"2_B_1_5"]) {//已付款，但未在时间内点击确认付款
        typeS = @"买家申诉有付款，却未点击已付款，请核实是否有收到汇款，如果有收到请放行BUB。";
    }else if ([string isEqualToString:@"1_B_1_2"] || [string isEqualToString:@"0_B_1_2"]){//卖家责任超时 //已付款 申诉 选择其他原因 ---- 倒计时
        typeS = @"\t\t您被买方申诉长时间未放行订单，请您尽快确认是否收到汇款，并且在确认收到后放行订单。\n\t\t如您未在以下时间内回复，此订单将由BUB运营人员审核，可能会强制放行此次订单。";
    }else if ([string isEqualToString:@"1_S_1_2"]){//买家被申诉,,未付款却点击了"已付款"
        typeS = @"买家申诉有付款，却未点击已付款，请核实是否有收到汇款，如果有收到请放行BUB。";
    }else { // 其他
        typeS=@"您正在被申诉";
    }
    return typeS;
}

+(NSString*)typeToSring:(NSString*)string{
    NSString *typeS = @"申诉中";
    if ([string isEqualToString:@"2"]) {
        typeS = @"申诉通过";
    }else if ([string isEqualToString:@"3"]){
         typeS = @"申诉不通过";
    }else if ([string isEqualToString:@"4"]){
        typeS = @"仲裁";
    }else if ([string isEqualToString:@"5"]){
        typeS = @"仲裁通过";
    }else if ([string isEqualToString:@"6"]){
        typeS = @"仲裁不通过";
    }else if ([string isEqualToString:@"7"]){
        typeS = @"申诉取消";
    }
    return typeS;
}


//progressContactSellers  , // 联系卖家
//progressContactBuyer,  // 联系买家
//progressCancelAppeal,  // 取消申诉
//progressContactOrder,  // 取消订单
//progressReleaseBUB,  // 放行BUB
////     progressContactBuyer,  // 去
//progressInitiateCounterclaim,  // 发起反申诉
// 按钮类型



@end
