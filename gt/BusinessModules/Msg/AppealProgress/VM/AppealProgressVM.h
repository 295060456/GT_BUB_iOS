//
//  AppealProgressVM.h
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppealProgressVM : NSObject
+ (void)getPostAppealCompleteDataWithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
