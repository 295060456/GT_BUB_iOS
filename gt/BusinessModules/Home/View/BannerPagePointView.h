//
//  BannerPageView.h
//  gt
//
//  Created by 鱼饼 on 2019/6/12.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PositionType){
    PositionCenter  = 0 ,
    PositionLetft,
    PositionRight,
};

NS_ASSUME_NONNULL_BEGIN
@interface BannerPagePointView : UIView

/**
 @param frame 整个view 位置
 @param position 点在View 的位置 居中 = PositionCenter ，靠左= PositionLetft， 靠右 = PositionRight
 @param pointColor 点的颜色
 */
-(instancetype)initWithFrame:(CGRect)frame andPosition:(PositionType)position andPointColor:(UIColor*)pointColor;

// 显示点的个数
@property(nonatomic ,assign) NSInteger pointCount;

// 当前选中的是第几个点 （ 从 0..... 开始)
@property(nonatomic ,assign) NSInteger choosePointCount;

@end
NS_ASSUME_NONNULL_END
