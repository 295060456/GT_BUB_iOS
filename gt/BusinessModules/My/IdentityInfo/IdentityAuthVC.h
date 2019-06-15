//
//  PageViewController.h
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20.
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionView;
@interface IdentityAuthVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block;
@end
