//
//  LoginVC.h
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RegisterVC : UIViewController
- (void)actionBlock:(ActionBlock)block;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams andRegisterVCType:(LongPwdTypes)type success:(DataBlock)block;
@end


NS_ASSUME_NONNULL_END
