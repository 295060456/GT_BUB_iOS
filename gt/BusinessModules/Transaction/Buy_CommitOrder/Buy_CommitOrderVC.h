//
//  PageViewController.h
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20.
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 买币 - 提交订单
 */
@interface Buy_CommitOrderVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
 withTransactionAmountType:(NSString *)paywayType
           paywayOccurType:(PaywayOccurType)paywayOccurType
                   success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
