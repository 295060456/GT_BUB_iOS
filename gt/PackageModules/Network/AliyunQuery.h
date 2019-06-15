//
//  AliyunQuery.h
//  AegisGood
//
//  Created by Terry.c on 19/09/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliyunQuery : NSObject

+ (void)uploadImageToAlyun:(UIImage *)img title:(NSString *)title completion:(void(^)(NSString *imgUrl))completion;

@end
