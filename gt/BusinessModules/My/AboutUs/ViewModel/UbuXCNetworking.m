//
//  UbuXCNetworking.m
//  gt
//
//  Created by bub chain on 17/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "UbuXCNetworking.h"

@implementation UbuXCNetworking

+(instancetype) instanceUbuXCNetworking
{
    static UbuXCNetworking *sing = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        sing = [[UbuXCNetworking alloc] init];
    });
    return sing;
}

/**
 获取app版本号
 http://phabricator.bubchain.com/w/%E5%90%8E%E7%AB%AF%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3/%E6%80%BB%E7%AE%A1%E7%90%86%E5%90%8E%E5%8F%B0%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3/%E5%AE%A2%E6%88%B7%E7%AB%AF%E9%9D%A2%E5%8D%87%E7%BA%A7%E6%96%87%E6%A1%A3/
 @param parameter 参数
 @param succeedBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)getVersionInfo:(NSDictionary *) parameter
               succeed:(void(^) (AboutUsModel *result))succeedBlock
                failed:(void(^) (NSError *error)) failedBlock{
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_XC_VersionUpdate]
                                                     andType:All
                                                     andWith:parameter
                                                     success:^(NSDictionary *dic) {
                                                         AboutUsModel *model = [AboutUsModel mj_objectWithKeyValues:dic];
                                                         if ([model.errcode isEqualToString:@"1"] &&
                                                            HandleStringIsNull(model.changelog)) {
                                                             
//                                                             NSString *st = @"1.测试测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码测试代码代码\n2.测试目录\n3.测测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换测试换试换行";
                                                             
                                                             
                                                             model.changelogList = [model.changelog componentsSeparatedByString:@"\n"];
//                                                             NSMutableArray *a = [NSMutableArray array];
//                                                             [a addObjectsFromArray:[model.changelog componentsSeparatedByString:@"\n"]];
//                                                             [a addObjectsFromArray:[model.changelog componentsSeparatedByString:@"\n"]];
//                                                             [a addObjectsFromArray:[model.changelog componentsSeparatedByString:@"\n"]];
//                                                             model.changelogList = a;
                                                             
                                                             
                                                         }
                                                         succeedBlock(model);
                                                     } error:^(NSError *error) {
                                                         //        [SVProgressHUD dismiss];
                                                         //        [YKToastView showToastText:error.description];
                                                         failedBlock(error);
                                                     }];
}
@end
