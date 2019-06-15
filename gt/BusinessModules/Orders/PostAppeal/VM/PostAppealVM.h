//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostAppealModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostAppealVM : NSObject

@property (strong,nonatomic) NSMutableArray *listData;

- (void)network_submitAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err;

//这里也可以用代理回调网络请求
- (void)network_getPostAppealListWithPage:(NSInteger)page
                        WithRequestParams:(id)requestParams
                                orderType:(OrderType)orderType
                                  success:(void(^)(NSArray *dataArray))success
                                   failed:(void(^)(void))failed;

+ (void)postAntiAppealWithRequestParams:(NSString*)appearlID
                                andData:(id)requestParams
                                success:(DataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
