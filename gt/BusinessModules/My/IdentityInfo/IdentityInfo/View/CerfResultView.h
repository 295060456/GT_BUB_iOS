//
//  CerfResultView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/21.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CerfResultViewType){
    ResultViewSuccess = 0 ,
    ResultViewFailure  ,
    ResultViewTomeOut  ,
};

NS_ASSUME_NONNULL_BEGIN

@interface CerfResultView : UIView
-(instancetype)initWithType:(CerfResultViewType)type block:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
