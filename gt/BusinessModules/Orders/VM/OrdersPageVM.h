//
//  PageVM.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrdersPageVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrdersPageVM : NSObject

- (void)network_getOrdersPageListWithPage:(NSInteger)page
                        WithRequestParams:(id)requestParams
                                 withRole:(NSString*)role
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
