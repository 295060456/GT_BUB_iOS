//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "OrdersPageModel.h"
@implementation OrdersPageModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"userOrder" : [OrderDetailModel class]
             };
}
@end
