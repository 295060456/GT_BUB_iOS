//
//  XcSafetySetView.h
//  gt
//
//  Created by XiaoCheng on 24/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/* 使用说明
 XcSafetySetView *vc = [[XcSafetySetView alloc] initWithFrame:CGRectZero];
 [vc setPayPwd:<#bool#> :^{
 
 }];
 [vc setBindPayee:<#bool#> :^{
 
 }];
 
 [vc setAutonym:<#bool#> :^{
 
 }];
 [vc setSeniorAutonym:<#bool#> :^{
 
 }];
 */
@interface XcSafetySetView : UIView

/**
 是否设置支付密码

 @param value YES:设置了  NO：未设置
 @param block 如果未设置，这是点击去设置的回调
 */
- (void) setPayPwd:(BOOL) value
                  :(NoResultBlock)block;

/**
 是否绑定收款方式
 
 @param value YES:设置了  NO：未设置
 @param block 如果未设置，这是点击去设置的回调
 */
- (void) setBindPayee:(BOOL) value
                  :(NoResultBlock)block;

/**
 是否完成实名认证
 
 @param value YES:设置了  NO：未设置
 @param block 如果未设置，这是点击去设置的回调
 */
- (void) setAutonym:(BOOL) value
                  :(NoResultBlock)block;

/**
 是否完成高级认证
 
 @param value YES:设置了  NO：未设置
 @param block 如果未设置，这是点击去设置的回调
 */
- (void) setSeniorAutonym:(BOOL) value
                  :(NoResultBlock)block;
@end

NS_ASSUME_NONNULL_END
