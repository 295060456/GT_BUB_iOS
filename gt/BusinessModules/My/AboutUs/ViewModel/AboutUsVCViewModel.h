//
//  AboutUsVCViewModel.h
//  gt
//
//  Created by bub chain on 17/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AboutUsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AboutUsVCViewModel : NSObject
@property (nonatomic, strong) RACCommand *versionUpdateRequest;
@property (nonatomic, strong) RACCommand *outLoginRequest;

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) AboutUsModel *model;

/**
 比较两个版本号的大小（2.0）
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion2:(NSString *)v1
                          to:(NSString *)v2;
@end

NS_ASSUME_NONNULL_END
