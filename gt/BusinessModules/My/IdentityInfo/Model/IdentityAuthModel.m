//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "IdentityAuthModel.h"

@implementation IdentityAuthData

@end

@implementation IdentityAuthModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"advert" : [IdentityAuthData class]
             };
}
@end
