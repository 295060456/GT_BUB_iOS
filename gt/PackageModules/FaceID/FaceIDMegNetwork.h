//
//  FaceIDMegNetwork.h
//  gt
//
//  Created by 鱼饼 on 2019/5/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FaceIDMegNetwork : NSObject

+(void)getFaceIDTokenSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

+(void)postFaceIDWithBizTonken:(NSString*)token Success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
