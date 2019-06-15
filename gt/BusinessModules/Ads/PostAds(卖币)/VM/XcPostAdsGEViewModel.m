//
//  XcPostAdsGEViewModel.m
//  gt
//
//  Created by XiaoCheng on 03/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsGEViewModel.h"

@implementation XcPostAdsGEViewModel
@synthesize mslJudge = mslJudgeG;
@synthesize requestParams = requestParamsG;

- (void) setRequestParams:(ModifyAdsModel *)requestParams1{
    requestParamsG = requestParams1;
    if (requestParams1) {
        self.currentPageType = TransactionAmountTypeFixed;
        self.sellNumberString = requestParams1.number;
        self.minuteString = requestParams1.prompt;
        self.fixedAmount  = requestParams1.fixedAmount;
    }
}

- (RACSignal *) mslJudge{
    if (!mslJudgeG) {
        @weakify(self)
        mslJudgeG = [RACSignal combineLatest:@[RACObserve(self, sellNumberString),
                                               RACObserve(self, queryUserPropertyModel),
                                               RACObserve(self, fixedAmount)]
                                      reduce:^(NSString *str1,
                                               QueryUserPropertyModel *model4,
                                               NSString *fixed){
                                          @strongify(self)
                                          UIColor *acolor = RGBCOLOR(255, 37, 37);//警告
                                          UIColor *bcolor = RGBCOLOR(140, 150, 165);//正常
                                          if (!HandleStringIsNull(str1)){
                                              self.tips2Color = bcolor;
                                              return [NSString stringWithFormat:@"今日可卖余额%@BUB",model4.todaysaleablebalance];
                                          }else if (!HandleStringIsNull(model4.todaysaleablebalance) || model4.todaysaleablebalance.floatValue<=0) {
                                              self.tips2Color = acolor;
                                              return @"*您今日可卖余额不足";
                                          }else if (!HandleStringIsNull(fixed)){
                                              self.tips2Color = acolor;
                                              return @"*请选择买家单笔固额";
                                          }else if (![NSString judgeiphoneNumberInt:str1]){
                                              self.tips2Color = acolor;
                                              return @"*请输入合法的数量";
                                          }else if (model4.todaysaleablebalance.floatValue < str1.integerValue){
                                              self.tips2Color = acolor;
                                              return @"*卖出数量不得超过今日可卖余额";
                                          }else{
                                              int a = str1.intValue%fixed.intValue;
                                              if (a != 0) {
                                                  self.tips2Color = acolor;
                                                  return [NSString stringWithFormat:@"*必须是%@的整数倍",fixed];
                                              }else{
                                                  self.tips2Color = bcolor;
                                                  return [NSString stringWithFormat:@"今日可卖余额%@BUB",model4.todaysaleablebalance];
                                              }
                                          }
                                          
                                          
                                          return @"";
                                      }];
    }
    
    
    return mslJudgeG;
}

@end
