//
//  XcPostAdsVC.h
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XcPostAdsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsVC : UIViewController
@property (nonatomic, strong) XcPostAdsViewModel *viewModel;
+ (nullable instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
