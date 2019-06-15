//
//  PageVM.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface IdentityAuthVM : NSObject
- (void)postIdentitySaveFacePlusResultWithRequestParams:(id)requestParams
                                                success:(DataBlock)success
                                                 failed:(DataBlock)failed
                                                  error:(DataBlock)err;

- (void)postIdentityApplyWithidCardFont:(NSString *)idCardFont
                    idCardReverse:(NSString *)idCardReverse
                          success:(DataBlock)success
                           failed:(DataBlock)failed
                            error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
