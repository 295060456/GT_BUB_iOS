//
//  AliyunQuery.m
//  AegisGood
//
//  Created by Terry.c on 19/09/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import "AliyunQuery.h"
#import <AliyunOSSiOS/OSSService.h>
#import "LoginModel.h"
@implementation AliyunQuery

+ (void)uploadImageToAlyun:(UIImage *)img
                     title:(NSString *)title
                completion:(void(^)(NSString *imgUrl))completion{
    
    //阿里云管理后台的AccessKeys获取key和secret
    id<OSSCredentialProvider>credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliYun_Key secretKey:AliYun_Secret];
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AliYun_Key secretKeyId:AliYun_Secret securityToken:AliYun_Token];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:PhotoEndPoint credentialProvider:credential];
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    //上传bucketName
    put.bucketName = @"linktest-tom";
    //上传文件名,支持@"MyImage/image"(虚拟文件夹路径)
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    NSString *path = [NSString stringWithFormat:@"appimge/ios_img/%@%@_%ld.jpg",title,userInfoModel.userinfo.userid,(long)[[NSDate date] timeIntervalSince1970]];
    put.objectKey = path;
    
    //上传的NSData数据
    NSData *data;
    if ([img isKindOfClass:[UIImage class]]) {
        data = UIImageJPEGRepresentation(img, 0.3);
    }
    else{
        data = nil;
    }
    put.uploadingData = data;
    
    //上传progress(可选操作)
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    //创建putTask(上传任务)
    OSSTask *putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            NSLog(@"upload object success!");
            
            //获取上传后的真实地址
            OSSTask * task = [client presignPublicURLWithBucketName:put.bucketName withObjectKey:put.objectKey];
            //            [client presignConstrainURLWithBucketName:put.bucketName withObjectKey:put.objectKey withExpirationInterval:3600];
            //真实地址
            NSString *url = task.result;
            
            NSLog(@"url:%@",url);
            completion(url);
        } else {
            completion(@"");
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        
        return nil;
    }];
    
    
}
@end
