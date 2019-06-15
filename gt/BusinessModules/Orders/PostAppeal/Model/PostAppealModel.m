//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "PostAppealModel.h"


@implementation PostAppealSubDataItem : NSObject

@end

@implementation PostAppealSubData : NSObject
+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [PostAppealSubDataItem class]
             
             };
}
@end

@implementation PostAppealData
+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PostAppealSubDataItem class]
             
             };
}
@end

@implementation PostAppealResult

@end

@implementation PostAppealModel

@end
