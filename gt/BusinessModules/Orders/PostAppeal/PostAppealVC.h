//
//  PostAdsVC.h
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostAppealVC : UIViewController
+ (instancetype)pushViewController:(UIViewController * _Nullable )rootVC
                     requestParams:(id)requestParams
                         orderType:(OrderType)orderType
                      isAntiAppeal:(BOOL)antiAppeal
                            reason:(NSString*)reason
                           success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END

