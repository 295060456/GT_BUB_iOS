//
//  NSData+MM.m
//  PregnancyHelper
//
//  Created by Chen Yaoqiang on 14-3-19.
//  Copyright (c) 2014年 ShengCheng. All rights reserved.
//

#import "NSData+Extras.h"

@implementation NSData (MM)

- (id)jsonValue {
    if ([NSJSONSerialization class]) {
        NSError *error = nil;
        id jsonValue = [NSJSONSerialization JSONObjectWithData:self
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
        
        if (error) {
            NSLog(@"%s", [error localizedFailureReason].description.UTF8String);
            return nil;
        }
        return jsonValue;
    }
    
    return nil;
}

@end
