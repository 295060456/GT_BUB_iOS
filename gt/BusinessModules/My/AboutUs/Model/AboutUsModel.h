//
//  ModifyLoginRequestModel.h
//  gt
//
//  Created by GT on 2019/1/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AboutUsData : NSObject
@property (nonatomic, copy) NSString * versionId;
@property (nonatomic, copy) NSString * about;
@property (nonatomic, copy) NSString * contact;
@end

@interface AboutUsModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString * err_code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) AboutUsData * versioninfo;
@property (nonatomic, copy) NSString *weiXin;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *rongCloudId;
@property (nonatomic, copy) NSString *rongCloudName;

//XC
@property (nonatomic, copy) NSString *errcode;//err_code为1表示应用有新版本可升级，对应会返回url,如果是0则表示不需要升级
@property (nonatomic, copy) NSString *changelog;//更新日志
@property (nonatomic, copy) NSString *type;//0非强制升级，1强制升级
@property (nonatomic, copy) NSString *version;//版本号
@property (nonatomic, copy) NSString *url;//下载URL
@property (nonatomic, copy) NSArray *changelogList;

@end

NS_ASSUME_NONNULL_END
