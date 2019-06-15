//
//  AdsVC.h
//  gtp
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferRecordVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC locateIndex:(NSInteger)locateIndex;
+ (instancetype)pushFromVC:(UIViewController *)rootVC;
@end

NS_ASSUME_NONNULL_END
