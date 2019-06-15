//
//  AddAccountVC.h
//  gt
//
//  Created by cookie on 2018/12/21.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAccountVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC withPaywayType:(PaywayType)paywayType paywayOccurType:(PaywayOccurType)paywayOccurType success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
