//
//  XcChangeTelephonePwVC.h
//  gt
//
//  Created by XiaoCheng on 10/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XcChangeTelephonePwVC : BaseTableViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
