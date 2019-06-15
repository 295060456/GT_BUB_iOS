//
//  VicJPushManager.h
//  OTC
//
//  Created by Dodgson on 2/23/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VicJPushModel.h"

@interface VicJPushManager : NSObject

+ (VicJPushModel *)receivePushContent:(NSDictionary *)dict;

+ (UIViewController *)getJumpViewControllerWith:(VicJPushModel *)model;

+ (void)handleJump:(NSDictionary *)dict;

@end
