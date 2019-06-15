//
//  EventListModel.m
//  OTC
//
//  Created by David on 2018/11/29.
//  Copyright © 2018年 yang peng. All rights reserved.
//


#import "EventListModel.h"
@implementation EventListTypeModel

@end

@implementation EventListPageModel

@end

@implementation EventListAllMessage

@end

@implementation EventListModel

+ (NSDictionary *)objectClassInArray {
    // value should be Class or Class name.
    return @{
             @"allMessage" : [EventListAllMessage class],
             };
}


@end
