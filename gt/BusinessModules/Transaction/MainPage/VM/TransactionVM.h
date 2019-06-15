//
//  PageVM.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TransactionVM : NSObject


- (void)postTransactionPageListWithPage:(NSInteger)page
                      WithRequestParams:(id)requestParams
                                success:(TwoDataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
