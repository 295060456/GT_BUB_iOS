//
//  GTSingLeton.h
//  gt
//
//  Created by 鱼饼 on 2019/5/21.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTSingLeton : NSObject
+(GTSingLeton*)singletonDefau;
//@property (nonatomic ,assign) float headerHit;
@property (nonatomic ,strong) NSString *yunDunCode; // 网易一顿码
@property(nonatomic, strong,nullable)NSMutableArray *chooseModelAr1; // 限额
@property(nonatomic, strong,nullable)NSMutableArray *chooseModelAr2; // 固额
@property(nonatomic, assign) UserType myType; // 我在订单中的角色
@end

NS_ASSUME_NONNULL_END
