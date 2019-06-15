//
//  BuyHeaderItemView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface BuyHeaderItemView : UIView

@property (nonatomic, strong) UILabel *buttomLa;

-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type WithString:(NSString*)string andBool:(BOOL)is;
@property (nonatomic ,assign) BOOL isChooseView;
@end

NS_ASSUME_NONNULL_END
