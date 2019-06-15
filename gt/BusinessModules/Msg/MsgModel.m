//
//  MsgModel.m
//  OTC
//
//  Created by 王标 on 2018/12/15.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "MsgModel.h"
@implementation MsgModelPage

@end

@implementation MsgData

@end

@implementation MsgModel
+ (NSDictionary *)objectClassInArray {
    // value should be Class or Class name.
    return @{
             @"messageList" : [MsgData class],
             };
}


@end
