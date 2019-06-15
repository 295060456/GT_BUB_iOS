//
//  AccountPhoneTipsView.h
//  gt
//
//  Created by XiaoCheng on 08/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AccountPhoneTipsViewObj [[AccountPhoneTipsView alloc] initWithFrame:CGRectZero]
NS_ASSUME_NONNULL_BEGIN
@interface AccountPhoneTipsView : UIView
/*使用说明
 [AccountPhoneTipsViewObj showFailed:^{
 
 } close:^{
 
 }];
 
 [AccountPhoneTipsViewObj showSucceed:^{
 
 }];
 */



/**
 账号冻结

 @param block 关闭页面回调
 @param closeBlock 关闭页面回调
 */
- (void) showFailed:(NoResultBlock)block
               close:(NoResultBlock) closeBlock;


/**
 手机号修改成功

 @param block 关闭页面回调
 */
- (void) showSucceed:(NoResultBlock)block;
@end

NS_ASSUME_NONNULL_END
