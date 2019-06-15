//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
@interface OrdersPageModel : NSObject
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, copy) NSString*  msg;

@property (nonatomic, strong) NSArray * userOrder;
+(NSDictionary *)objectClassInArray;
@end
