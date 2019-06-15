//
//  PostAppealComleteView.h
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostAppealCompleteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostAppealComleteView : UIView
-(instancetype)initWithBlockSuccess:(DataTypeBlock)block;
-(void)layoutView:(PostAppealCompleteModel*)model;
@end

NS_ASSUME_NONNULL_END
