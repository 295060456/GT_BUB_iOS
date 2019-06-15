//
//  XcPostAdsViewModel.m
//  gt
//
//  Created by XiaoCheng on 28/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsViewModel.h"
#import "YTSharednetManager.h"

@implementation XcPostAdsViewModel
#define DATAERRORSTR  @"数据加载失败，请重试"
/**
 查询用户资产
 */
- (RACCommand *) getUserAssertRequest{
    if (!_getUserAssertRequest) {
                @weakify(self)
        _getUserAssertRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_UserAssert]
                                                                 andType:All
                                                                 andWith:@{}
                                                                 success:^(NSDictionary *dic) {
                                                                     QueryUserPropertyModel *queryUserPropertyModel = [QueryUserPropertyModel mj_objectWithKeyValues:dic];
                                                                     if ([NSString getDataSuccessed:dic]) {
                                                                         @strongify(self)
                                                                         self.queryUserPropertyModel = queryUserPropertyModel;
                                                                         [subscriber sendNext:nil];
                                                                         [subscriber sendCompleted];
                                                                     }
                                                                     else{
                                                                         [subscriber sendError:nil];
                                                                     }
                                                                 } error:^(NSError *error) {
                                                                     [subscriber sendError:nil];
                                                                 }];
                return nil;
            }];
            return signal;
        }];
    }
    return _getUserAssertRequest;
}


/**
 获取广告限制
 */
- (RACCommand *) getPostAdsRequest{
    if (!_getPostAdsRequest) {
        @weakify(self)
        _getPostAdsRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PostAdsCheck]
                                                                 andType:All
                                                                 andWith:@{}
                                                                 success:^(NSDictionary *dic) {
                                                                     PostAdvertisingModel *postAdvertisingModel = [PostAdvertisingModel mj_objectWithKeyValues:dic];
                                                                     if ([NSString getDataSuccessed:dic]) {
                                                                         @strongify(self)
                                                                         self.adsModel = postAdvertisingModel;
                                                                         [subscriber sendNext:nil];
                                                                         [subscriber sendCompleted];
                                                                     }
                                                                     else{
                                                                         [subscriber sendError:nil];
                                                                     }
                                                                 } error:^(NSError *error) {
                                                                    [subscriber sendError:nil];
                                                                 }];
                return nil;
            }];
            return signal;
        }];
    }
    return _getPostAdsRequest;
}


/**
 获取收款方式
 */
- (RACCommand *) getMyAccTypeRequest{
    if (!_getMyAccTypeRequest) {
        @weakify(self)
        _getMyAccTypeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString* input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PayMentAccountList]
                                                                  andType:All
                                                                  andWith:@{}
                                                                  success:^(NSDictionary *dic) {
                                                                      AccountListModel *accountListModel = [AccountListModel mj_objectWithKeyValues:dic];
                                                                      NSMutableArray *dataMutArr= NSMutableArray.array;
                                                                      // 修改数据完毕以后，装数据
                                                                      for (int i = 0; i < accountListModel.paymentWay.count; i++) {
                                                                          AccountPaymentWayModel *accountPaymentWayModel = accountListModel.paymentWay[i];
                                                                          [dataMutArr addObject:accountPaymentWayModel];
                                                                      }
                                                                      if ([NSString getDataSuccessed:dic]) {
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayCellInPostAdsRefresh
                                                                                                                              object:nil];
                                                                          @strongify(self)
                                                                          if (((NSArray*)dataMutArr).count == 0) {
                                                                              [subscriber sendError:nil];
                                                                          }else{
                                                                              AccountPaymentWaySuperModel *models = [AccountPaymentWaySuperModel new];
                                                                              [models maxDataArr:dataMutArr cardID:self.requestParams.paymentWayIds type:self.currentPageType];
                                                                              self.myAccs = models.maxDataArr;
                                                                              [subscriber sendNext:nil];
                                                                              [subscriber sendCompleted];
                                                                          }
                                                                      }
                                                                      else{
                                                                          [subscriber sendError:nil];
                                                                      }
                                                                  } error:^(NSError *error) {
                                                                      [subscriber sendError:nil];
                                                                  }];
                
                
                return nil;
            }];
            return signal;
        }];
    }
    return _getMyAccTypeRequest;
}


/**
 商家发布广告 & 商家广告修改
 */
- (RACCommand *) sendAdsRequest{
    if (!_sendAdsRequest) {
        @weakify(self)
        _sendAdsRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:input];
                [parameter setObject:@"1" forKey:@"price"];
                [parameter setObject:@"BUB" forKey:@"coinId"];
                [parameter setObject:@"人民币" forKey:@"coinType"];
                [parameter setObject:@"" forKey:@"autoReplyContent"];
                [parameter setXcObject:self.requestParams.ugOtcAdvertId forKey:@"advertId"];//修改广告的id
                [parameter setObject:@"2" forKey:@"type"];
                
                [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:self.requestParams?ApiType_ModifyAds:ApiType_PostAds]
                                                                 andType:All
                                                                 andWith:parameter
                                                                 success:^(NSDictionary *dic) {
                                                                     PostAdsModel *postAdsModel = [PostAdsModel mj_objectWithKeyValues:dic];
                                                                     [SVProgressHUD dismiss];
                                                                     if ([NSString getDataSuccessed:dic]) {
                                                                         NSString *str = self.requestParams?@"修改广告成功":@"发布广告成功";
                                                                         Toast(str);
                                                                         [subscriber sendNext:postAdsModel];
                                                                         [subscriber sendCompleted];
                                                                     }
                                                                     else{
                                                                         [YKToastView showToastText:postAdsModel.msg];
                                                                         [subscriber sendError:nil];
                                                                     }
                                                                 } error:^(NSError *error) {
                                                                     Toast(DATAERRORSTR);
                                                                     [SVProgressHUD dismiss];
                                                                     [YKToastView showToastText:error.description];
                                                                     [subscriber sendError:error];
                                                                 }];
                return nil;
            }];
            return signal;
        }];
    }
    return _sendAdsRequest;
}
@end
