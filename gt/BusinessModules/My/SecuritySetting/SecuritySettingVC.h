//
//  SecuritySettingVC.h
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecuritySettingVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
