//
//  BuyBubDetailVC.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyBubDetailVC : BaseVC

/**
    orderNo 必传
 */
+ (instancetype)pushFromVC:(UINavigationController *)naVC
             requestParams:( id )orderNO
                   success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
