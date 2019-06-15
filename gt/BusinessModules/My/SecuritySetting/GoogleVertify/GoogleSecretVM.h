//
//  GoogleSecretVM.h
//  gt
//
//  Created by GT on 2019/1/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleSecretVM : NSObject
- (void)network_getGoogleSecretWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_bindingGoogleWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_dismissGoogleWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_switchGoogleWithRequestParams:(id)requestParams withInputCodeDic:(NSDictionary*)codeDic success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
