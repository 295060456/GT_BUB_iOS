//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "PostAdsModel.h"

@implementation PostAdsSubDataItem : NSObject

@end

@implementation PostAdsSubData : NSObject

+(NSDictionary *)objectClassInArray
{
    return @{
             @"arr" : [PostAdsSubDataItem class]
             
             };
}
@end

@implementation PostAdsData

+(NSDictionary *)objectClassInArray
{
    return @{
             @"b" : [PostAdsSubDataItem class]
             
             };
}

@end

@implementation PostAdsResult

@end

@implementation PostAdsModel

@end

@implementation QueryUserPropertyModel
- (void) setTodaysaleablebalance:(NSString *)todaysaleablebalance{
    _todaysaleablebalance = [todaysaleablebalance stringByReplacingOccurrencesOfString:@".00" withString:@""];
}
@end


@implementation PostAdvertisingModel 

@end


