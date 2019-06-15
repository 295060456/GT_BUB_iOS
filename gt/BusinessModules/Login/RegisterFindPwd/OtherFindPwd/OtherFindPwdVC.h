//
//  RecoverPwCarVC.h
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,RecoverPwCarVCType){
    recoverPwCar = 0, // 实名身份证
    recoverPwBUBP, // bub密码找回
    recoverPwGoogleCode, // 谷歌
};

@interface OtherFindPwdVC : UIViewController
+ (instancetype)presentViewController:(UIViewController *)rootVC requestParams:(nullable id )requestParams  withType:(RecoverPwCarVCType)type success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
