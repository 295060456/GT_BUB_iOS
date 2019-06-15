//
//  XcSecuritySettingsVM.m
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcSecuritySettingsVM.h"
#import "LoginVM.h"

@implementation XcSecuritySettingsVM

- (NSArray *) listData{
    if (!_listData) {
        _listData = [NSArray arrayWithObjects:  
                     @"资金密码",
                     @"确认密码", nil];
    }
    return _listData;
}

- (BOOL) pwIsEqual{
    if ([self.pw isEqualToString:self.nPw]) {
        if (self.pw.length<6) {
            Toast(@"请输入大于等于6位的密码");
            return NO;
        }
        return YES;
    }else{
        Toast(@"请输入相同的密码");
        return NO;
    }
}

- (RACCommand *) submitRequest{
    if (!_submitRequest) {
        @weakify(self)
        _submitRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [SVProgressHUD showWithStatus:LoadMsg maskType:SVProgressHUDMaskTypeNone];
                [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SettingFundPW]
                                                                 andType:All
                                                                 andWith:@{@"pwd":[NSString MD5WithString:self.pw  isLowercase:YES]}
                                                                 success:^(NSDictionary *dic) {
                                                                     NSString *msg = dic[@"msg"];
                                                                     NSString *errcode = dic[@"errcode"];
                                                                     if (HandleStringIsNull(msg)) {
                                                                         Toast(msg);
                                                                     }
                                                                     if ([errcode isEqualToString:@"1"]) {
                                                                         [subscriber sendNext:dic];
                                                                         [subscriber sendCompleted];
                                                                     }else{
                                                                         [subscriber sendError:nil];
                                                                         [SVProgressHUD dismiss];
                                                                     }
                                                                     
                                                                 } error:^(NSError *error) {
                                                                     [SVProgressHUD dismiss];
                                                                     [subscriber sendError:error];
                                                                 }];
                
                return nil;
            }];
            return signal;
        }];
    }
    return _submitRequest;
}

- (RACCommand *) getUserInfoRequest{
    if (!_getUserInfoRequest) {
        _getUserInfoRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [SVProgressHUD showWithStatus:LoadMsg maskType:SVProgressHUDMaskTypeNone];
                [LoginVM.new network_inSecuritySettingCheckUserInfoWithRequestParams:@{}
                                                                             success:^(id data, id data2) {
                                                                                 [SVProgressHUD dismiss];
                                                                                 [subscriber sendNext:nil];
                                                                                 [subscriber sendCompleted];
                                                                             } failed:^(id data) {
                                                                                 [SVProgressHUD dismiss];
                                                                                 [subscriber sendError:nil];
                                                                             } error:^(id data) {
                                                                                 [SVProgressHUD dismiss];
                                                                                 [subscriber sendError:nil];
                                                                             }];
                
                return nil;
            }];
            return signal;
        }];
    }
    return _getUserInfoRequest;
}


- (RACSignal *) submitBtnEnabled{
    if (!_submitBtnEnabled) {
        _submitBtnEnabled = [RACSignal combineLatest:@[RACObserve(self, pw), RACObserve(self, nPw)]
                                              reduce:^(NSString *_pw, NSString *_npw){
                                                  return @(_pw && _pw.length>0 && _npw && _npw.length>0);
                                              }];
    }
    
    
    return _submitBtnEnabled;
}

@end
