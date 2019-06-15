//
//  YTSharednetManager.m
//  yitiangogo
//
//  Created by Tgs on 14-11-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "YTSharednetManager.h"
#import "LoginVC.h"

static YTSharednetManager *sharedManager = nil;
@implementation YTSharednetManager
@synthesize httpManager;
@synthesize statusBlock;


-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(YTSharednetManager *)sharedNetManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YTSharednetManager allocWithZone:NULL]init];
    });
    return sharedManager;
}

-(void)setGetTheadNetworkWithUrl:(NSMutableDictionary *)dictionary
                       andReturn:(void (^)(NSDictionary *dic))block{
    
    httpManager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)httpManager.responseSerializer).removesKeysWithNullValues = YES;
    
    RequestType type = [[dictionary objectForKey:@"userinfo"] intValue];
    
    httpManager.requestSerializer.timeoutInterval = 30;
    
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    WS(weakSelf);
    [httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        weakSelf.selectNetStatus = status;
        
        managerAFNetworkStatus ownStatus = managerAFNetworkNotReachable;
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:     // 无连线
                ownStatus = managerAFNetworkNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ownStatus = managerAFNetworkReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                ownStatus = managerAFNetworkReachableViaWiFi;
                break;
                
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                ownStatus = managerAFNetworkUnknown;
                break;
        }
        if (weakSelf.statusBlock) {
            
            weakSelf.statusBlock(ownStatus);
        }
    }];
    // 开始监听
    [httpManager.reachabilityManager startMonitoring];
    //    设置cookie
    if (type != GetCookie) {
        
        [httpManager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie")
                             forHTTPHeaderField:@"Cookie"];
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *postDic = [[NSDictionary alloc]initWithDictionary:[dictionary valueForKey:@"parameters"]];
    
    [httpManager GET:[dictionary valueForKey:@"url"]
          parameters:postDic
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
        NSData *data = [operation responseData];
                 
        [dataDic setValue:@"Success" forKey:@"info"];
                 
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
//        NSLog(@"%@",[operation responseString]);
        [dataDic setValue:resultDic forKey:@"result"];
                 
        if (block) {
            
            block(dataDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (type==PayService&&[operation responseData]!=nil) {
//            NSData *data = [operation responseData];
//            [dataDic setValue:@"Success" forKey:@"info"];
//            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            [dataDic setValue:resultDic forKey:@"result"];
//        }else{
//            
//        }
        if (weakSelf.selectNetStatus!=AFNetworkReachabilityStatusNotReachable) {
            managerAFNetworkStatus ownStatus = managerAFNetworkServiceError;
            
            if (weakSelf.statusBlock) {
                
                weakSelf.statusBlock(ownStatus);
            }
        }
        NSData *data = [operation responseData];
        if (data) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
            
            if ([[NSString isValueNSStringWith:[resultDic objectForKey:@"code"]] integerValue]==600&&resultDic!=nil) {
//                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [delegate getNetworkCookie];
            }
        }
        [dataDic setValue:@"Fail"
                   forKey:@"info"];
        
        [dataDic setValue:nil
                   forKey:@"result"];
        if (block) {
            block(dataDic);
        }
    }];
}


//Post请求
-(void)setPostReturnNetWorkWith:(NSDictionary *)dictionary
                      andReturn:(void (^)(NSDictionary *dic))block{
    //    AFNetWorking下载数据
    httpManager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)httpManager.responseSerializer).removesKeysWithNullValues = YES;
    
    RequestType type = [[dictionary objectForKey:@"userinfo"] intValue];
    
    httpManager.requestSerializer.timeoutInterval = 30;
    
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    WS(weakSelf);
    [httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        weakSelf.selectNetStatus = status;
        
        managerAFNetworkStatus ownStatus = managerAFNetworkNotReachable;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:     // 无连线
                ownStatus = managerAFNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ownStatus = managerAFNetworkReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                ownStatus = managerAFNetworkReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                ownStatus = managerAFNetworkUnknown;
                break;
        }
        if (weakSelf.statusBlock&&type!=Default) {
            
            weakSelf.statusBlock(ownStatus);
        }
    }];
    // 开始监听
    [httpManager.reachabilityManager startMonitoring];
//    设置cookie
    if (type != GetCookie) {
        
        [httpManager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie")
                             forHTTPHeaderField:@"Cookie"];
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *postDic = [[NSDictionary alloc]initWithDictionary:[dictionary valueForKey:@"parameters"]];
    
    [httpManager POST:[dictionary valueForKey:@"url"]
           parameters:postDic
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [operation responseData];
        
        [dataDic setValue:@"Success" forKey:@"info"];
        
        if (type == GetCookie) {
            
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:[dictionary valueForKey:@"url"]]];
            
            NSDictionary *Request = [[NSDictionary alloc]initWithDictionary:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
            
            SetUserDefaultKeyWithObject(@"mUserDefaultsCookie", [Request objectForKey:@"Cookie"]);
        }
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
        //        接口判断、数据处理、回调
//        lMenu_productApi_info

        if([kNeedNetLog isEqualToString:@"1"])NSLog(@"%@",[operation responseString]);


        [dataDic setValue:resultDic forKey:@"result"];
        if (block) {
            block(dataDic);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (weakSelf.selectNetStatus!=AFNetworkReachabilityStatusNotReachable&&type!=Default) {
            managerAFNetworkStatus ownStatus = managerAFNetworkServiceError;
            
            if (weakSelf.statusBlock) {
                weakSelf.statusBlock(ownStatus);
            }
        }
        NSData *data = [operation responseData];
        if (data) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
            
            if ([[NSString isValueNSStringWith:[resultDic objectForKey:@"code"]] integerValue] == 600 && resultDic!=nil) {
//                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [delegate getNetworkCookie];
            }
        }
        [dataDic setValue:@"Fail" forKey:@"info"];
        [dataDic setValue:nil forKey:@"result"];
        if (block) {
            block(dataDic);
        }
    }];
}
-(void)postNetInfoWithUrl:(NSString *)urlPath_Header
                  andType:(RequestType)type
                  andWith:(NSDictionary *)paramters
                  success:(void(^)(NSDictionary *dic))success
                    error:(void (^)(NSError *error))err{
    
    NSString *path = Nil;
    if (type == All) {
        
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;//URL_IP;
    }
    else if(type == LNService){
        
        path = LNURL_IP;
    }
    else if(type == Default){
        
        path = @"";
    }else{
        
        path = URL_IP;
    }
    
    NSString *titStr = [paramters mj_JSONString];
//    NSLog(@"requestObject: %@", titStr);
    NSData *postData = [titStr dataUsingEncoding:NSUTF8StringEncoding
                            allowLossyConversion:YES];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                                                                                parameters:nil
                                                                                     error:nil];
    NSLog(@"requestUrl....: %@", request);
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
//    NSLog(@"request\\\\: %@", request);
    kWeakSelf(self);
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"requestUrlPath: %@    responseObject: %@",urlPath_Header,responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]){
                
                NSDictionary * dic = (NSDictionary *)responseObject;
                NSString *codeS = dic[@"errcode"];
                if ([codeS isEqualToString:@"3"]) { // 要是出问题 把这个if 租掉即可
                    success(dic);
                    [weakself closeLoginSever];
                }else{
                    success(dic);
                }
            }
        } else {
            NSLog(@"error: %@, %@, %@", error, response, responseObject);
            err(error);
        }
    }] resume];
}

-(void)getGETNetInfoWithUrl:(NSString *)urlPath_Header
                    andType:(RequestType)type
                    andWith:(NSDictionary *)paramters
                  andReturn:(void (^)(NSDictionary *dic))block{
    
    NSNumber *index = [NSNumber numberWithInteger:type];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSString *path = Nil;
    
    if (type == All) {
        
        path = URL_IP;
    }
    else if(type == LNService){
        
        path = LNURL_IP;
    }else if(type == PayService){
        
//        path = URL_PAY_IP;
    }else if(type == UpayService){
        
//        path = URL_UPAY_IP;
    }else if(type == Default){
        
        path = @"";
    }else{
        
        path = URL_IP;
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                forKey:@"url"];
    
    [dataDic setObject:index
                forKey:@"userinfo"];
    
    if (paramters.allKeys.count > 0) {
        
        [dataDic setObject:paramters
                    forKey:@"parameters"];
    }
//    NSLog(@"%@",dataDic);
    [self setGetTheadNetworkWithUrl:dataDic
                          andReturn:^(NSDictionary *dic) {
        if (block) {
            block(dic);
        }
    }];
}

#pragma mark--通用网络接口 --Post
-(void)getNetInfoWithUrl:(NSString *)urlPath_Header
                 andType:(RequestType)type
                 andWith:(NSDictionary *)paramters
               andReturn:(void (^)(NSDictionary *dic))block{
    
    NSNumber *index = [NSNumber numberWithInteger:type];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSString *path;
    if (type == All) {
        path = URL_IP;
    }else if(type == LNService){
        path = LNURL_IP;
    }
    else if(type == Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                forKey:@"url"];
    
    [dataDic setObject:index
                forKey:@"userinfo"];
    
    if (paramters.allKeys.count>0) {
        
        [dataDic setObject:paramters
                    forKey:@"parameters"];
    }
    if([kNeedNetLog isEqualToString:@"1"])NSLog(@"wnagluo------>>%@",dataDic);
    
    [self setPostReturnNetWorkWith:dataDic
                         andReturn:^(NSDictionary *dic) {
        if (block) {
            block(dic);
        }
    }];
}

//设置网络监听
-(void)setAFNetStatusChangeBlock:(void(^)(managerAFNetworkStatus status))block{
    self.statusBlock = [block copy];
}
#pragma mark afnetworking请求，文件上传
-(void)requestAFNetWorkingByUrl:(NSString *)url
                     parameters:(id)parameters
                          files:(NSDictionary *) files
                        success:(void (^)(AFHTTPRequestOperation *operation, id data))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [self initAFNetWorkingByUrl:url
                     parameters:parameters
                           head:nil
                          files:files
                        success:success
                        failure:failure
                           type:1];
    
}

//type:1为Post；0为Get
-(void)initAFNetWorkingByUrl:(NSString *) url
                  parameters:(id)parameters
                        head:(NSDictionary *)headers
                       files:(NSDictionary *) files
                     success:(void (^)(AFHTTPRequestOperation *operation, id data))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        type:(NSInteger)type{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    
    manager.requestSerializer.timeoutInterval = 60;
    //    设置cookie
    [manager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie") forHTTPHeaderField:@"Cookie"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (headers) {
        
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    [manager.requestSerializer setValue:@"client/json" forHTTPHeaderField:@"Exception-With"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/png",@"multipart/form-data", nil];
    
    AFHTTPRequestOperation *result = Nil;
    
    if (type == 1) {
        
        if (files) {
            
            result =  [manager POST:url
                         parameters:params
          constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              
                [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    
                    [formData appendPartWithFileData:obj
                                                name:key
                                            fileName:[NSString stringWithFormat:@"%@.png",key]
                                            mimeType:@"image/png"];
                }];
            } success:success failure:failure ];
        }else{
            
            result = [manager POST:url
                        parameters:params
                           success:success
                           failure:failure];
        }
    }
    else{
        
        result =[manager GET:url
                  parameters:parameters
                     success:success
                     failure:failure];
    }
}

-(void)closeLoginSever{
    SetUserBoolKeyWithObject(kIsLogin, NO);
    DeleUserDefaultWithKey(kUserInfo);
    UserDefaultSynchronize;
    [self toLongVC];
}

-(void)toLongVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    [LoginVC pushFromVC:result requestParams:nil success:^(id data) {
    }];
}


@end
