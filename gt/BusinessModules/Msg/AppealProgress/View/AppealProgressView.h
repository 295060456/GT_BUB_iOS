//
//  AppealProgressView.h
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppealProgressModel.h"





NS_ASSUME_NONNULL_BEGIN

@interface AppealProgressView : UIView
-(instancetype)initWithBlockSuccess:(DataTypeBlock)block;
-(void)layoutView:(AppealProgressModel*)model;
@end

NS_ASSUME_NONNULL_END
