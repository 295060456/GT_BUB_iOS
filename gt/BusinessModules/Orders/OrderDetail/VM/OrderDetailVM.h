//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailVM : NSObject

- (void)network_getOrderDetailListWithPage:(NSInteger)page
                         WithRequestParams:(id)requestParams
                                   success:(ThreeDataBlock)success
                                    failed:(DataBlock)failed
                                     error:(DataBlock)err;

- (void)network_submitAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err;

- (void)network_transactionOrderSureDistributeWithCodeDic:(NSDictionary*)codeDic
                                        WithRequestParams:(id)requestParams
                                                  success:(DataBlock)success
                                                   failed:(DataBlock)failed
                                                    error:(DataBlock)err;

- (void)network_cancelAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err;

// 获取订单详情 XiRan
- (void)network_getOrderDetailWithRequestParams:(id)requestParams
                             appealScheduleType:(NSInteger)ty
                                        success:(TwoDataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
