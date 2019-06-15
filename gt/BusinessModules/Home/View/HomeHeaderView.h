//
//  HomeHeaderView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/16.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>



#define nabarHit  (YBSystemTool.isIphoneX? 88:64)
#define headHit   366*SCALING_RATIO

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : UIView

-(instancetype)initViewBlock:(TwoDataBlock)block;
- (void)richElementsInCellWithModel:(NSDictionary*)model; // 刷新数据
@end

NS_ASSUME_NONNULL_END
