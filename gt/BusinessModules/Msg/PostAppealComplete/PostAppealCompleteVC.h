//
//  PostAppealCompleteVC.h
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostAppealCompleteVC : UIViewController
+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                           success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
