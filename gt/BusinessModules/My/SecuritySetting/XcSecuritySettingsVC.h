//
//  XcSecuritySettingsVC.h
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XcSecuritySettingsVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
