//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModifyAdsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyAdsVM : NSObject

- (void)network_getModifyAdsListWithPage:(NSInteger)page WithRequestParams:(NSString*)requestParams success:(TwoDataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
