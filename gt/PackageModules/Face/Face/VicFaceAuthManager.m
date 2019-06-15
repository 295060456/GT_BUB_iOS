//
//  VicFaceAuthManager.m
//  OTC
//
//  Created by Dodgson on 2019/1/12.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import "VicFaceAuthManager.h"
#import "NSDictionary+VicExt.h"
#import "NSData+VicBase64.h"
#import "AFAppDotNetAPIClient.h"

#define Face_APIKey @"tE_0VaLE7dG858ECwTtSqBiJ5zane8Jw"
#define Face_APISecret @"XHOUbkSRWuNtvlDy_KBWXSWMj4CUd668"

@implementation VicFaceAuthManager

+ (void)authIdentityCardWithImage:(UIImage *)image
                         legality:(BOOL)legality
                successCompletion:(void(^)(id data))successCompletion
                  errorCompletion:(void(^)(NSError *error))errorcompletion{
    NSDictionary *param = @{};
    param = [param vic_appendKey:@"api_key" value:Face_APIKey];
    param = [param vic_appendKey:@"api_secret" value:Face_APISecret];
    param = [param vic_appendKey:@"image_base64" value:[UIImageJPEGRepresentation(image, 0.3) base64EncodedString]];
    param = [param vic_appendKey:@"legality" value:@(legality)];
    
    NSString *domain = @"https://api-cn.faceplusplus.com/cardpp/v1/ocridcard";
    
    [[AFAppDotNetAPIClient sharedClient] POST:domain parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id response;
        if([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]){
            response = responseObject;
        }else{
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,response];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        if(response){
            successCompletion(response);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,error];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        errorcompletion(error);
    }];
}

+ (void)faceRecognitionWithImage:(UIImage *)image
                        landmark:(VicLandmark)landmark
                      attributes:(NSString *)attributes
                   calculate_all:(BOOL)calculate_all
                  face_rectangle:(CGRect)face_rectangle
               successCompletion:(void(^)(id data))successCompletion
                 errorCompletion:(void(^)(NSError *error))errorcompletion{
    NSDictionary *param = @{};
    param = [param vic_appendKey:@"api_key" value:Face_APIKey];
    param = [param vic_appendKey:@"api_secret" value:Face_APISecret];
    param = [param vic_appendKey:@"image_base64" value:[UIImageJPEGRepresentation(image, 0.3) base64EncodedString]];
    param = [param vic_appendKey:@"return_landmark" value:@(landmark)];
    param = [param vic_appendKey:@"return_attributes" value:attributes];
#ifdef RELEASE
    param = [param vic_appendKey:@"calculate_all" value:@(calculate_all)];
#endif
    
    if(face_rectangle.size.width > 0 && face_rectangle.size.height > 0){
        NSString *top = [NSString stringWithFormat:@"%.2f",face_rectangle.origin.y];
        NSString *left = [NSString stringWithFormat:@"%.2f",face_rectangle.origin.x];
        NSString *width = [NSString stringWithFormat:@"%.2f",face_rectangle.size.width];
        NSString *height = [NSString stringWithFormat:@"%.2f",face_rectangle.size.height];
        NSString *rectangle = [NSString stringWithFormat:@"%@,%@,%@,%@",top,left,width,height];
        param = [param vic_appendKey:@"face_rectangle" value:rectangle];
    }
    
    NSString *domain = @"https://api-cn.faceplusplus.com/facepp/v3/detect";
    
    [[AFAppDotNetAPIClient sharedClient] POST:domain parameters:param  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id response;
        if([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]){
            response = responseObject;
        }else{
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,response];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        if(response){
            successCompletion(response);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,error];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        errorcompletion(error);
    }];
}

+ (void)compareFaceWithFirstFaceURL:(NSString *)firstFaceURL
                     firstFaceToken:(NSString *)firstFaceToken
                     firstRectangle:(CGRect)firstRectangle
                  successCompletion:(void(^)(id data))successCompletion
                    errorCompletion:(void(^)(NSError *error))errorcompletion{
    NSDictionary *param = @{};
    param = [param vic_appendKey:@"api_key" value:Face_APIKey];
    param = [param vic_appendKey:@"api_secret" value:Face_APISecret];
    
    if(firstFaceToken.length > 0){
        param = [param vic_appendKey:@"face_token1" value:firstFaceToken];
    }
    if (firstFaceURL){
        param = [param vic_appendKey:@"image_url2" value:firstFaceURL];
    }
    
    
    
    if(firstRectangle.size.width > 0 && firstRectangle.size.height > 0 && firstFaceURL){
        NSString *top = [NSString stringWithFormat:@"%.2f",firstRectangle.origin.y];
        NSString *left = [NSString stringWithFormat:@"%.2f",firstRectangle.origin.x];
        NSString *width = [NSString stringWithFormat:@"%.2f",firstRectangle.size.width];
        NSString *height = [NSString stringWithFormat:@"%.2f",firstRectangle.size.height];
        NSString *rectangle = [NSString stringWithFormat:@"%@,%@,%@,%@",top,left,width,height];
        param = [param vic_appendKey:@"face_rectangle1" value:rectangle];
    }
    
    
    NSString *domain = @"https://api-cn.faceplusplus.com/facepp/v3/compare";
    
    [[AFAppDotNetAPIClient sharedClient] POST:domain parameters:param  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id response;
        if([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]){
            response = responseObject;
        }else{
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,response];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        if(response){
            successCompletion(response);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,error];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        errorcompletion(error);
    }];
}

+ (void)compareFaceWithFirstFaceImage:(UIImage *)firstFaceImage
                       firstFaceToken:(NSString *)firstFaceToken
                      secondFaceImage:(UIImage *)secondFaceImage
                      secondFaceToken:(NSString *)secondFaceToken
                       firstRectangle:(CGRect)firstRectangle
                      secondRectangle:(CGRect)secondRectangle
                    successCompletion:(void(^)(id data))successCompletion
                      errorCompletion:(void(^)(NSError *error))errorcompletion{
    NSDictionary *param = @{};
    param = [param vic_appendKey:@"api_key" value:Face_APIKey];
    param = [param vic_appendKey:@"api_secret" value:Face_APISecret];
    
    if(firstFaceToken.length > 0){
        param = [param vic_appendKey:@"face_token1" value:firstFaceToken];
    }else if (firstFaceImage){
        param = [param vic_appendKey:@"image_base64_1" value:[UIImageJPEGRepresentation(firstFaceImage, 0.3) base64EncodedString]];
    }
    
    if(secondFaceToken.length > 0){
        param = [param vic_appendKey:@"face_token2" value:secondFaceToken];
    }else if (secondFaceImage){
        param = [param vic_appendKey:@"image_base64_2" value:[UIImageJPEGRepresentation(secondFaceImage, 0.3) base64EncodedString]];
    }
    
    
    if(firstRectangle.size.width > 0 && firstRectangle.size.height > 0 && firstFaceImage){
        NSString *top = [NSString stringWithFormat:@"%.2f",firstRectangle.origin.y];
        NSString *left = [NSString stringWithFormat:@"%.2f",firstRectangle.origin.x];
        NSString *width = [NSString stringWithFormat:@"%.2f",firstRectangle.size.width];
        NSString *height = [NSString stringWithFormat:@"%.2f",firstRectangle.size.height];
        NSString *rectangle = [NSString stringWithFormat:@"%@,%@,%@,%@",top,left,width,height];
        param = [param vic_appendKey:@"face_rectangle1" value:rectangle];
    }
    
    if(secondRectangle.size.width > 0 && secondRectangle.size.height > 0 && secondFaceImage){
        NSString *top = [NSString stringWithFormat:@"%.2f",secondRectangle.origin.y];
        NSString *left = [NSString stringWithFormat:@"%.2f",secondRectangle.origin.x];
        NSString *width = [NSString stringWithFormat:@"%.2f",secondRectangle.size.width];
        NSString *height = [NSString stringWithFormat:@"%.2f",secondRectangle.size.height];
        NSString *rectangle = [NSString stringWithFormat:@"%@,%@,%@,%@",top,left,width,height];
        param = [param vic_appendKey:@"face_rectangle2" value:rectangle];
    }
    
    NSString *domain = @"https://api-cn.faceplusplus.com/facepp/v3/compare";
    
    [[AFAppDotNetAPIClient sharedClient] POST:domain parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id response;
        if([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]){
            response = responseObject;
        }else{
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,response];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        if(response){
            successCompletion(response);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSString *string = [NSString stringWithFormat:@"\n<*******************************************> 协议请求路径:\n%@\n协议请求方式:\n%@\n协议请求参数:\n%@\n协议请求结果:\n%@\n",domain,@"POST",param,error];
        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:@"%@",string] UTF8String]);
#endif
        errorcompletion(error);
    }];
}

@end
