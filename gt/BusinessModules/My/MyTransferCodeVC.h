//
//  AboutUsVC.h
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//  关于我们

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTransferCodeVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
