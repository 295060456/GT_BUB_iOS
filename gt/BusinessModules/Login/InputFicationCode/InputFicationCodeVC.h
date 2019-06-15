//
//  InputFicationCodeVC.h
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface InputFicationCodeVC : UIViewController
+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(NSString *)phone andInputCodeVCType:(NSString*)countryCode anVCType:(LongPwdTypes)type success:(DataBlock)block;
//-(void)showLine;
@end

NS_ASSUME_NONNULL_END
