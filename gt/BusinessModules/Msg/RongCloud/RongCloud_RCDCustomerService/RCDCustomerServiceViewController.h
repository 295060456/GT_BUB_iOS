//
//  RCDCustomerServiceViewController.h
//  RCloudMessage
//
//  Created by litao on 16/2/23.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDCustomerServiceViewController : RCConversationViewController

@property (nonatomic, strong) id requestParams;


+ (instancetype)presentFromVC:(UIViewController *)rootVC
                requestParams:(id)requestParams
               andServiceData:(NSArray*)dataArray
                      success:(DataBlock)block;

@end
