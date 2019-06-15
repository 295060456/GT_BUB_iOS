//
//  UbuXCNetworking.h
//  gt
//
//  Created by bub chain on 17/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AboutUsModel.h"

#define UbuXCNetworkingObj  [UbuXCNetworking instanceUbuXCNetworking]

NS_ASSUME_NONNULL_BEGIN

@interface UbuXCNetworking : NSObject


/**
 获取单例

 @return 实例对象
 */
+(instancetype) instanceUbuXCNetworking;

/**
 获取app版本号

 @param parameter 参数
 @param succeedBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)getVersionInfo:(NSDictionary *) parameter
               succeed:(void(^)(AboutUsModel *result))succeedBlock
                failed:(void(^) (NSError *error)) failedBlock;
@end

NS_ASSUME_NONNULL_END
