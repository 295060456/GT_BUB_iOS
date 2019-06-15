//
//  SubmitOrderPopView.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,MoreOrLess){
    
    MoreOrLessOnce_more = 0,//大于单次购买上限
    MoreOrLessOnce_less,//小于单次购买下限
    MoreOrLessRemain//大于实际库存
};

NS_ASSUME_NONNULL_BEGIN

/**
 买币 - 提交订单 - 弹窗（由下至上弹出且悬浮在屏幕最下方）
 */
@interface SubmitOrderPopView : UIView{

}

@property(nonatomic,copy)void (^MyBlock)(void);

@property(nonatomic,assign)PaywayType paymentStyle;

@property(nonatomic,strong)UITextField *leftTextField;

@property(nonatomic,strong)UITextField *rightTextField;

@property(nonatomic,copy)NSString *quotaStr;

@property(nonatomic,copy)NSString *remainingStr;

@property(nonatomic,copy)NSString *fixedAmountStr;//固额数量

@property(nonatomic,copy)NSString *fixedAmountMsg;//固额超额提示

-(instancetype)initWithPaymentWay:(NSString *)paymentWay
                       QuotaStyle:(TransactionAmountType)quotaStyle;

- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;

//超额警告⚠️
-(void)showWarning:(MoreOrLess)moreOrLess;

-(void)disappearWarning;

- (void)disMissView;
// BUB一键购买特殊回调
-(void)noeBuyBubActionAnd:(BOOL)show block:(ActionBlock)noeBlock;
@end

NS_ASSUME_NONNULL_END
