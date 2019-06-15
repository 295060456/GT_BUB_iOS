//
//  AboutUsVCViewModel.m
//  gt
//
//  Created by bub chain on 17/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AboutUsVCViewModel.h"
#import "UbuXCNetworking.h"
#import "LoginVM.h"

@implementation AboutUsVCViewModel

- (NSArray *) listData{
    return @[@{@"title":@"最新版本",@"version":XcodeAppVersion,@"newVersion":self.model.version ? self.model.version : XcodeAppVersion},
             @{@"title":@"币友用户协议"},
             @{@"title":@"退出登录"}];
}

- (RACCommand *) versionUpdateRequest{
    if (!_versionUpdateRequest) {
        @weakify(self)
        _versionUpdateRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [UbuXCNetworkingObj getVersionInfo:@{}
                                           succeed:^(AboutUsModel * _Nonnull result) {
                                               if (result) {
                                                   @strongify(self)
                                                   if (result.errcode && result.errcode.intValue == 1) {
                                                       self.model = result;
                                                       }
                                                   }
                                               
                                               [subscriber sendNext:result];
                                               [subscriber sendCompleted]; 
                                           } failed:^(NSError * _Nonnull error) {
                                               [subscriber sendError:error];
                                           }];
                
                return nil;
            }];
            return signal;
        }];
    }
    return _versionUpdateRequest;
}

- (RACCommand *) outLoginRequest{
    if (!_outLoginRequest) {
        _outLoginRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[[LoginVM alloc] init] network_getLoginOutWithRequestParams:@1
                                                                     success:^(id model) {
                                                                         [subscriber sendNext:model];
                                                                         [subscriber sendCompleted];
                                                                     }
                                                                      failed:^(id model){
                                                                          [subscriber sendError:nil];
                                                                      }
                                                                       error:^(id model){
                                                                           [subscriber sendError:nil];
                                                                       }];
                return nil;
            }];
            return signal;
        }];
    }
    return _outLoginRequest;
}

/**
 比较两个版本号的大小（2.0）
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion2:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最大的，进行循环比较
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        // 字段有值，取值；字段无值，置0。
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本号相等
    return 0;
}

@end
