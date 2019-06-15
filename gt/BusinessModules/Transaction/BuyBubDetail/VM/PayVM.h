//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PayVM : NSObject

- (void)network_postPayListWithPage:(NSInteger)page
                  WithRequestParams:(id)requestParams
                            success:(DataBlock)success
                             failed:(DataBlock)failed
                              error:(DataBlock)err;

- (void)network_confirmPayListWithRequestParams:(id)requestParams
                                 WithPaymentWay:(NSString*)paymentWay
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err;

- (void)network_canclePayListWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
