//
//  ModifyAdsVC.h
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModifyAdsVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC  withAdId:(NSString*)adId success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
