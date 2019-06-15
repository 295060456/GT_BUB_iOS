//
//  SettingNicknameVC.h
//  gt
//
//  Created by Administrator on 02/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingNicknameVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
