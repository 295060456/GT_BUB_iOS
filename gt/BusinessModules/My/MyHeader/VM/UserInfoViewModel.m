//
//  UserInfoViewModel.m
//  gt
//
//  Created by XiaoCheng on 10/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "UserInfoViewModel.h"

@implementation UserInfoViewModel
- (RACCommand *) verificationPWRequest{
    if (!_verificationPWRequest) {
        @weakify(self)
        _verificationPWRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [SVProgressHUD showWithStatus:@"验证中"];@strongify(self)
                [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_YanZlongPW]
                                                                  andType:All
                                                                  andWith:@{@"password":[NSString MD5WithString:self.pwText isLowercase:YES]}
                                                                  success:^(NSDictionary *dic) {
                                                                      NSString *ty = dic[@"errcode"];
                                                                      if ([ty isEqualToString:@"1"]) {
                                                                          [subscriber sendNext:nil];
                                                                          [subscriber sendCompleted];
                                                                      }else if ([ty isEqualToString:@"4"]){
                                                                          [subscriber sendNext:@"4"];
                                                                          [subscriber sendCompleted];
                                                                      }else{
                                                                          Toast(dic[@"msg"]);
                                                                          [subscriber sendError:nil];
                                                                      }
                                                                      [SVProgressHUD dismiss];
                                                                  } error:^(NSError *error) {
                                                                      [SVProgressHUD dismiss];
                                                                      [YKToastView showToastText:error.description];
                                                                      [subscriber sendError:error];
                                                                  }];
                return nil;
            }];
            return signal;
        }];
    }
    return _verificationPWRequest;
}

- (RACSignal *) nextSignal{
    if (!_nextSignal) {
        _nextSignal = [RACSignal combineLatest:@[RACObserve(self, pwText)] reduce:^(NSString *pw){
            return @(HandleStringIsNull(pw) && pw.length>=6);
        }];
    }
    return _nextSignal;
}

#pragma mark  ---输入新手机号页面
- (RACCommand *) verificationPhoneRequest{
    if (!_verificationPhoneRequest) {
        _verificationPhoneRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [SVProgressHUD showWithStatus:@"发送中"];
                NSString *str = [NSString stringWithFormat:@"%@|%@",self.areaCode,self.phoneNum];
                str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
                [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SendMessageAuthenticationCode]
                                                                  andType:All
                                                                  andWith:@{@"msgType":@"2",@"cellPhone":str}
                                                                  success:^(NSDictionary *dic) {
                                                                      [SVProgressHUD dismiss];
                                                                      if ([NSString getDataSuccessed:dic]) {
                                                                          [subscriber sendNext:nil];
                                                                          [subscriber sendCompleted];
                                                                      }else{
                                                                          [subscriber sendError:nil];
                                                                      }
                                                                  } error:^(NSError *error) {
                                                                      [subscriber sendError:nil];
                                                                      [SVProgressHUD dismiss];
                                                                      [YKToastView showToastText:error.description];
                                                                  }];
                return nil;
            }];
            return signal;
        }];
    }
    return _verificationPhoneRequest;
}
- (RACSignal *) verificationSignal{
    if (!_verificationSignal) {
        _verificationSignal = [RACSignal combineLatest:@[RACObserve(self, phoneNum)] reduce:^(NSString *phoneNum){
            return @(HandleStringIsNull(phoneNum) && phoneNum.length>=6);
        }];
    }
    return _verificationSignal;
}
@end
