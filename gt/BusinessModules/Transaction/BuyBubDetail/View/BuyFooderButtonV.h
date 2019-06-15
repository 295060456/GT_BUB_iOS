//
//  BuyFooderButtonV.h
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyFooderButtonV : UIView
-(instancetype)initWithActionBlock:(DataBlock)block;
-(void)addButtonViewWith:(NSArray* _Nullable)ar;
@end

NS_ASSUME_NONNULL_END
