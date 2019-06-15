//
//  GTSingLeton.m
//  gt
//
//  Created by 鱼饼 on 2019/5/21.
//  Copyright © 2019 GT. All rights reserved.
//

#import "GTSingLeton.h"

static GTSingLeton *single  = nil;

@implementation GTSingLeton

+(GTSingLeton*)singletonDefau{
    @synchronized (self) {
        if (single == nil) {
            single = [[GTSingLeton alloc] init];
        }
    }
    return single;
}

@end
