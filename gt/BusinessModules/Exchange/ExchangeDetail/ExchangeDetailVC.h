//
//  ExchangeDetailVC.h
//  gtp
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeDetailVC : UIViewController
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
