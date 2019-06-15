//
//  LoginView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/13.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,LoginViewType){
    loginRegister = 0 , // 注册
    loginforgetPwd ,    // 忘记密码
    loginToService ,    // 联系客服
    loginToLogin ,      // 登录
};



NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView
-(instancetype)initViewSuccess:(DataTypeBlock)block;
@end

NS_ASSUME_NONNULL_END
