//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "PageModel.h"

@implementation PageModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"merchantAdvert" : [ModifyAdsModel class]
             };
}
@end
