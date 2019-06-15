//
//  YTSharednetManager.h
//  yitiangogo
//
//  Created by Tgs on 14-11-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kNeedNetLog   @"1"
typedef NS_ENUM (NSUInteger, RequestType) {
    All = 0 ,
    PayService,
    UpayService,
    ShareType,
    GetCookie,
    Default,
    LNService
};
typedef NS_ENUM (NSUInteger, managerAFNetworkStatus) {
    managerAFNetworkNotReachable = 0 ,//无网络连接
    managerAFNetworkReachableViaWWAN,//手机自带网络
    managerAFNetworkReachableViaWiFi,//手机wifi
    managerAFNetworkUnknown,//未知网络
    managerAFNetworkOutTime,//接口超时
    managerAFNetworkServiceError,//接口报错
};
typedef void(^AFNetStatusBlock)(managerAFNetworkStatus status);
@interface YTSharednetManager : NSObject
{
    
}
@property(nonatomic,assign)AFNetworkReachabilityStatus selectNetStatus;
@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;
@property(nonatomic,copy)NSString *netCookie;
@property(nonatomic,strong)AFNetStatusBlock statusBlock;

+(YTSharednetManager *)sharedNetManager;
-(void)postNetInfoWithUrl:(NSString *)urlPath_Header andType:(RequestType)type andWith:(NSDictionary *)paramters success:(void(^)(NSDictionary *dic))success

                     error:(void (^)(NSError *error))err;


-(void)getNetInfoWithUrl:(NSString *)urlPath andType:(RequestType)type andWith:(NSDictionary *)paramters andReturn:(void (^)(NSDictionary *dic))block;

-(void)getGETNetInfoWithUrl:(NSString *)urlPath_Header andType:(RequestType)type andWith:(NSDictionary *)paramters andReturn:(void (^)(NSDictionary *dic))block;

//设置网络监听
-(void)setAFNetStatusChangeBlock:(void(^)(managerAFNetworkStatus status))block;

//文件上传
-(void)requestAFNetWorkingByUrl:(NSString *)url
                     parameters:(id)parameters
                          files:(NSDictionary *) files
                        success:(void (^)(AFHTTPRequestOperation *operation, id data))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
