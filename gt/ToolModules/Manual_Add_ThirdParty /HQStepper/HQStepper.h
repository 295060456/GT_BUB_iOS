//
//  HQStepper.h
//  HQStepper
//
//  Created by admin on 2017/7/11.
//  Copyright © 2017年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HQStepperButton.h"

/**
 样式为：输入框(UITextField居中,左“-”按钮,右“+”按钮)
 */

NS_ASSUME_NONNULL_BEGIN

@interface HQStepper : UIControl

@property(nonatomic,strong)UIColor *tintColor;

@property(nonatomic,assign)double minimumValue;

@property(nonatomic,assign)double maximumValue;

@property(nonatomic,assign)double stepValue;

@property(nonatomic,assign,getter = isContinuous) BOOL continuous;

@property(nonatomic,assign)BOOL wraps;

@property(nonatomic,assign)BOOL autorepeat;

@property(nonatomic,assign)double autorepeatInterval;

@property(nonatomic,copy)NSString *accessibilityTag;

@property(nonatomic,strong)HQStepperButton *decreaseStepperButton;// Left HQStepperButton

@property(nonatomic,strong)UITextField *valueTextField;// Center UITextField

@property(nonatomic,strong)HQStepperButton *increaseStepperButton;// Right HQStepperButton

@property(nonatomic,strong)NSString *currentValue;

@property(nonatomic,strong)UIFont *textFont;

@property(nonatomic,strong)NSString *valueDuringAction;

- (void)commonInit;

- (void)setValue:(double)value;

- (double)value;

- (NSString *)valueObject;

- (void)setFont:(NSString *)fontName size:(CGFloat)size;

- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setCurrentValue:(NSString *)value;

-(void)Notification:(UITextField *)textField
       currentValue:(NSString * __nullable)value;//通知传值

@end

NS_ASSUME_NONNULL_END
