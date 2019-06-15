//
//  SettingPasswordVC.h
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface SettingPasswordVC : UIViewController
+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(nullable id )requestParams  andType:(LongPwdTypes)type success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
