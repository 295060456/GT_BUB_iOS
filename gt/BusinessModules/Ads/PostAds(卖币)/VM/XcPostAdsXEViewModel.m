//
//  XcPostAdsXEViewModel.m
//  gt
//
//  Created by XiaoCheng on 03/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsXEViewModel.h"

@implementation XcPostAdsXEViewModel
@synthesize requestParams = requestParamsX;

- (void) setRequestParams:(ModifyAdsModel *)requestParams1{
    requestParamsX = requestParams1;
    if (requestParams1) {
        self.currentPageType = TransactionAmountTypeLimit;
        self.priceLowString = requestParams1.limitMinAmount;
        self.priceHighString = requestParams1.limitMaxAmount;
        self.sellNumberString = requestParams1.number;
        self.minuteString = requestParams1.prompt;
    }
}

- (RACSignal *) jyeJudgeText{
    if (!_jyeJudgeText) {
        _jyeJudgeText = [RACSignal combineLatest:@[RACObserve(self, priceLowString),
                                                   RACObserve(self, priceHighString),
                                                   RACObserve(self, adsModel),
                                                   RACObserve(self, queryUserPropertyModel),
                                                   RACObserve(self, sellNumberString)]
                                          reduce:^(NSString *str1,
                                                   NSString *str2,
                                                   PostAdvertisingModel *model3,
                                                   QueryUserPropertyModel *model4,
                                                   NSString*sell){
                                              
                                              NSArray *optionPrices = [model3.optionPrice componentsSeparatedByString:@","];
                                              NSInteger low = 0;//最低
                                              NSInteger high = 0;//最高
                                              NSInteger todaysaleablebalance = model4.todaysaleablebalance.integerValue;//今日可卖余额
                                              NSInteger usableFund = model4.usableFund.integerValue;//可用资产
                                              if (optionPrices.count==2) {
                                                  low = ((NSString*)optionPrices.firstObject).integerValue;
                                                  high = ((NSString*)optionPrices.lastObject).integerValue;
                                              }
                                              
                                              if (HandleStringIsNull(str1)) {
                                                  if (![NSString judgeiphoneNumberInt:str1]){
                                                      return @"*请输入合法的最低金额";
                                                  }else if (str1.integerValue>0 && str1.intValue<low && low != 0){
                                                      return [NSString stringWithFormat:@"*最小限额不可小于%zdBUB",low];
                                                  }else if (str1.integerValue>high){
                                                      return [NSString stringWithFormat:@"*最大限额不可大于%zdBUB",high];
                                                  }else if (str1.integerValue>usableFund){
                                                      return @"*您当前可用余额不足";
                                                  }else if (str1.integerValue>todaysaleablebalance){
                                                      return @"*您今日可卖余额不足";
                                                  }else if (!HandleStringIsNull(str2)){
                                                      return @"*请输入最大限额";
                                                  }else if (HandleStringIsNull(sell) && sell.integerValue>=low && sell.integerValue<str1.integerValue){
                                                      return @"*最小限额不得超过卖出数量";
                                                  }
                                              }
                                              if (HandleStringIsNull(str2)) {
                                                  if (![NSString judgeiphoneNumberInt:str2]){
                                                      return @"*请输入合法的最高金额";
                                                  }else if (str2.integerValue>0 &&str2.intValue>high && high != 0){
                                                      return [NSString stringWithFormat:@"*最大限额不可大于%zdBUB",high];
                                                  }else if (str2.integerValue<low){
                                                      return [NSString stringWithFormat:@"*最大限额不可小于%zdBUB",low];
                                                  }else if (str2.intValue<str1.integerValue){
                                                      return @"*最大限额不得低于最小限额";
                                                  } else if (str2.integerValue>usableFund){
                                                      return @"*您当前可用余额不足";
                                                  }else if (str2.integerValue>todaysaleablebalance){
                                                      return @"*您今日可卖余额不足";
                                                  }else if (!HandleStringIsNull(str1)){
                                                      return @"*请输入最小限额";
                                                  }
                                              }
                                              return @"";
                                          }];
    }
    
    
    return _jyeJudgeText;
}

- (RACSignal *) mslJudge{
    if (!_mslJudge) {
        @weakify(self)
        _mslJudge = [RACSignal combineLatest:@[RACObserve(self, sellNumberString),
                                               RACObserve(self, priceLowString),
                                               RACObserve(self, priceHighString),
                                               RACObserve(self, queryUserPropertyModel)]
                                      reduce:^(NSString *str1,
                                               NSString *low,
                                               NSString *high,
                                               QueryUserPropertyModel *model4){
                                          @strongify(self)
                                          UIColor *acolor = RGBCOLOR(255, 37, 37);//警告
                                          UIColor *bcolor = RGBCOLOR(140, 150, 165);//正常
                                          if (!HandleStringIsNull(model4.todaysaleablebalance) || model4.todaysaleablebalance.floatValue<=0) {
                                              self.tips2Color = acolor;
                                              return @"*您今日可卖余额不足";
                                          }else if (!HandleStringIsNull(str1)){
                                              self.tips2Color = bcolor;
                                              return [NSString stringWithFormat:@"今日可卖余额%@BUB",model4.todaysaleablebalance];
                                          }else if (![NSString judgeiphoneNumberInt:str1]){
                                              self.tips2Color = acolor;
                                              return @"*请输入合法的数量";
                                          }else if (str1.integerValue < low.integerValue){
                                              self.tips2Color = acolor;
                                              return @"*卖出数量不得小于单笔最小限额";
                                          }else if (model4.todaysaleablebalance.floatValue < str1.integerValue){
                                              self.tips2Color = acolor;
                                              return @"*卖出数量不得超过今日可卖余额";
                                          }else{
                                              self.tips2Color = bcolor;
                                              return [NSString stringWithFormat:@"今日可卖余额%@BUB",model4.todaysaleablebalance];
                                          }
                                          
                                          return @"";
                                      }];
    }
    
    
    return _mslJudge;
}

- (RACSignal *) timeJudge{
    if (!_timeJudge) {
        @weakify(self)
        _timeJudge = [RACSignal combineLatest:@[RACObserve(self, minuteString),
                                                RACObserve(self, adsModel)]
                                       reduce:^(NSString *minute,
                                                PostAdvertisingModel *model){
                                           NSArray *minuteList = [model.prompt componentsSeparatedByString:@","];
                                           NSInteger maxMinute = 0;
                                           NSInteger minMinute = 0;
                                           if (minuteList && minuteList.count==2) {
                                               maxMinute  = ((NSString*)minuteList.lastObject).integerValue;
                                               minMinute  = ((NSString*)minuteList.firstObject).integerValue;
                                           }
                                           @strongify(self)
                                           self.tips3Color = RGBCOLOR(255, 37, 37);
                                           if (maxMinute == 0 && minMinute==0) return @"";
                                           if (!HandleStringIsNull(minute)){
                                               self.tips3Color = RGBCOLOR(140, 150, 165);
                                               return [NSString stringWithFormat:@"收款期限不能低于%zd分钟",minMinute];}
                                           if (![NSString judgeiphoneNumberInt:minute]) return @"*请输入合法的时间";
                                           if (minute.integerValue<minMinute) return [NSString stringWithFormat:@"*不得小于%zd分钟",minMinute];
                                           if (minute.integerValue>maxMinute) return [NSString stringWithFormat:@"*不得大于%zd分钟",maxMinute];
                                           return @"";
                                       }];
    }
    
    
    return _timeJudge;
}

- (void) upBuyerAstrict:(UIButton *) btn1
                       :(UIImageView*) img1
                       :(UIButton *) btn2
                       :(UIImageView*) img2
                       :(BOOL) select1{
    if (select1) {
        btn1.selected = !btn1.selected;
        img1.image = btn1.selected ? kIMG(@"xc_ss_select_bg") : nil;
        if (btn2.selected) {
            btn2.selected = NO;
            img2.image = nil;
        }
    }else{
        btn2.selected = !btn2.selected;
        img2.image = btn2.selected ? kIMG(@"xc_ss_select_bg") : nil;
        if (btn1.selected) {
            btn1.selected = NO;
            img1.image = nil;
        }
    }
}
@end
