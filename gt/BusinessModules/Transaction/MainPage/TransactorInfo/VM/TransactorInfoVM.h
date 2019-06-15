//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactorInfoModel.h"
#import "TransactionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransactorInfoVM : NSObject
- (void)network_postTransactorInfoWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
