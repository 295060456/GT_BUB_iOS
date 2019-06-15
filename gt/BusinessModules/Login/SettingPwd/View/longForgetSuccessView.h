//
//  longForgetSuccessView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,SuccessViewType){
    successRegistered = 0, // 注册
    successApplication, // 申请
};


@interface longForgetSuccessView : UIView
-(instancetype)initFogetGetPwViewWith:(SuccessViewType)type Bolck:(DataTypeBlock)block;
@end

NS_ASSUME_NONNULL_END
