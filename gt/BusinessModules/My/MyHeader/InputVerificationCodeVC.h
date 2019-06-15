//
//  InputVerificationCodeVC.h
//  gt
//
//  Created by Administrator on 03/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface InputVerificationCodeVC : UIViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
