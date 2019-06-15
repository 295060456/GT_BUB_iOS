//
//  PageVM.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageVM : NSObject
- (void)network_outlineAdRequestParams:(id)requestParams withAdID:(NSString*)adID success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_onlineAdRequestParams:(id)requestParams withAdID:(NSString*)adID withNumber:(NSString*)number success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_getAdsPageListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
