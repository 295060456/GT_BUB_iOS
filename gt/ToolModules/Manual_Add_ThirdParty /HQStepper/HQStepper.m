//
//  HQStepper.m
//  HQStepper
//
//  Created by admin on 2017/7/11.
//  Copyright © 2017年 judian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "HQStepper.h"

#import "HQStepper+UITextFieldDelegate.h"

static CGFloat const kFMStepperDefaultAutorepeatInterval = 0.35f;

@interface HQStepper ()

@end

@implementation HQStepper

-(instancetype)init{

    if (self = [super init]) {
        
    }

    return self;
}

- (void)commonInit {
    
    self.minimumValue = 0;	// All these have the same default values as a UIStepper
    
//    self.maximumValue = 100;
    
    self.stepValue = 1;
    
    self.continuous = YES;
    
    self.autorepeat = YES;
    
    self.wraps = NO;
    
    self.autorepeatInterval = kFMStepperDefaultAutorepeatInterval;	// Static value default is defined above
    
    [self setCurrentValue:[NSString stringWithFormat:@"%@",@(self.stepValue)]];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.frame;
    
    if (frame.size.width <= 0 && frame.size.height <= 0) {//frame异常的时候 处理默认值
        // The bounding rectangle for a UIStepper matches that of a UISwitch object (79 x 27)
        frame = CGRectMake(frame.origin.x, frame.origin.x, 79.0f, 27.0f);
    }
    
    CGFloat controlHeight = frame.size.height;
    
    CGFloat buttonWidth = frame.size.height;
    
    CGFloat fieldWidth = frame.size.width - (2 * buttonWidth);
    
    // Use the system font by default; calculate max size from height of frame
    // We don't actually set the title on the button, since the +/- is drawn
    // in the FMStepperButton's drawRect
    self.textFont = [UIFont systemFontOfSize:(0.95 * controlHeight)];
    
    // LHS Decreasing Stepper Button
    CGRect decreaseStepperFrame = CGRectMake(0.0f, 0.0f, buttonWidth, controlHeight);
    
    self.decreaseStepperButton = [[HQStepperButton alloc] initWithFrame:decreaseStepperFrame
                                                                  style:HQStepperButtonStyleLeftMins];
    self.decreaseStepperButton.autoresizingMask = UIViewAutoresizingNone;
    
    self.decreaseStepperButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.decreaseStepperButton addTarget:self
                                   action:@selector(longTouchDidBegin:)
                         forControlEvents:UIControlEventTouchUpInside];

    
    // Center UITextField for stepper Value
    CGRect valueFieldFrame = CGRectMake(buttonWidth, 0.0f,
                                        fieldWidth, controlHeight);
    
    self.valueTextField = [[UITextField alloc] initWithFrame:valueFieldFrame];
    
    self.valueTextField.textColor = [UIColor blackColor];
    
    self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.valueTextField.textAlignment = NSTextAlignmentCenter;
    
    self.valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.valueTextField.text = self.currentValue;
    
    self.valueTextField.layer.masksToBounds = YES;
    
    self.valueTextField.layer.borderColor = [[UIColor colorWithWhite:0.85f alpha:1.0f] CGColor];
    
    self.valueTextField.layer.borderWidth = 1.0f;
    
    // RHS Increasing Stepper Button
    CGRect increaseStepperFrame = CGRectMake(buttonWidth + fieldWidth, 0.0f,
                                             buttonWidth, controlHeight);
    
    self.increaseStepperButton = [[HQStepperButton alloc] initWithFrame:increaseStepperFrame
                                                                  style:HQStepperButtonStyleLeftPlus];
   
    self.increaseStepperButton.autoresizingMask = UIViewAutoresizingNone;
  
    self.increaseStepperButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  
    [self.increaseStepperButton addTarget:self
                                   action:@selector(longTouchDidBegin:)
                         forControlEvents:UIControlEventTouchUpInside];

    
    // Finish up
    [self setFont:[self.textFont fontName] size:0.0f]; // Important: make sure things get sized properly
    
    [self addSubview:self.decreaseStepperButton];
   
    [self addSubview:self.valueTextField];
   
    [self addSubview:self.increaseStepperButton];
    
    [self UITextFieldDelegate];
}

#pragma mark - Getting and Setting the Stepper Value

- (NSString *)valueObject {
    
    return self.currentValue;
}

- (double)value {
    
    return [self.currentValue doubleValue];
}

- (void)setValue:(double)value {
    
    self.currentValue = [NSString stringWithFormat:@"%@",@(value)];
}

- (void)setCurrentValue:(NSString *)value {
    
    // If the value is below/above the range, set the value to the min/max
    // TODO: Is this really the desired behavior?
    if ([value doubleValue] < self.minimumValue) {
        
        _currentValue = [NSString stringWithFormat:@"%@",@(self.minimumValue)];
        
        NSLog(@"[%@ %@]- Trying to set value (%@) below minimumValue (%f); using minimumValue",
              NSStringFromClass(self.class), NSStringFromSelector(_cmd), value, self.minimumValue);
        
    } else if ([value doubleValue] > self.maximumValue) {
        
        _currentValue = [NSString stringWithFormat:@"%@",@(self.maximumValue)];
        
        NSLog(@"[%@ %@]- Trying to set value (%@) above maximumValue (%f); using maximumValue",
              NSStringFromClass(self.class), NSStringFromSelector(_cmd), value, self.maximumValue);
        
    } else {
        
        // All is well.
        _currentValue = value;
    }
    
    // Disable buttons if we're at the miniumum or maximum values
    if ([_currentValue doubleValue] <= self.minimumValue) {
        
        if (!self.wraps) {
            
            [self.decreaseStepperButton setEnabled:NO];
        }
        
    } else if (![self.decreaseStepperButton isEnabled]) {
        
        [self.decreaseStepperButton setEnabled:YES];
    }
    
    if ([_currentValue doubleValue] >= self.maximumValue) {
        
        if (!self.wraps) {
            
            [self.increaseStepperButton setEnabled:NO];
        }
        
    } else if (![self.increaseStepperButton isEnabled]) {
        
        [self.increaseStepperButton setEnabled:YES];
    }
    
    self.valueTextField.text = [NSString stringWithFormat:@"%@",_currentValue];
    
    // Let targets know about change to the value so they can perform actions
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Other Setting Methods

- (void)setMinimumValue:(double)minimumValue {
    
    if (minimumValue > self.maximumValue) {
        
        NSString *reason = [NSString stringWithFormat:@"Invalid minimumValue (%f) in light of current maximumValue (%f)",
                            minimumValue, self.maximumValue];
        
        NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:reason
                                                userInfo:nil];
        @throw ex;
    }
    
    _minimumValue = minimumValue;
}

- (void)setMaximumValue:(double)maximumValue {
    
    if (maximumValue < self.minimumValue) {
        
        NSString *reason = [NSString stringWithFormat:@"Invalid maximumValue (%f) in light of current minimumValue (%f)",
                            self.minimumValue, maximumValue];
        NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:reason
                                                userInfo:nil];
        @throw ex;
    }
    
    _maximumValue = maximumValue;
}

- (void)setStepValue:(double)stepValue {
    
    NSString *reason = nil;
    
    if (stepValue <= 0) {
        
        reason = [NSString stringWithFormat:@"Invalid stepValue (%f). Cannot be zero or negative value.",
                  stepValue];
        
    } else if (stepValue > self.maximumValue) {
        
        // This is not enforced in UIStepper. Can't think of a reason *not* to enforce it, however unlikely
        // it is that the input would be this insane.
        reason = [NSString stringWithFormat:@"Invalid stepValue (%f). Cannot be greater than the maximum value (%f).",
                  stepValue, self.maximumValue];
    }
    
    if (reason) {
        
        NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:reason
                                                userInfo:nil];
        @throw ex;
    }
    
    _stepValue = stepValue;
}

- (void)setAutorepeatInterval:(double)autorepeatInterval {
    
    if (autorepeatInterval > 0) {
        
        _autorepeatInterval = autorepeatInterval;
        
        self.autorepeat = YES;
        
    } else if (autorepeatInterval <= 0) {
        
        _autorepeatInterval = autorepeatInterval;
        
        self.autorepeat = NO;
    }
}

- (void)setAccessibilityTag:(NSString *)accessibilityTag {
    
    _accessibilityTag = accessibilityTag;
    
    self.valueTextField.accessibilityLabel = [NSString stringWithFormat:@"%@ value", accessibilityTag];
    
    self.valueTextField.accessibilityHint = [NSString stringWithFormat:@"Edit value of %@", accessibilityTag];
    
    [self.decreaseStepperButton configureAccessibilityWithTag:accessibilityTag];
    
    [self.increaseStepperButton configureAccessibilityWithTag:accessibilityTag];
}

#pragma mark - Customizing Appearance
- (void)setFont:(NSString *)fontName
           size:(CGFloat)size {
    
    // This only applies to the text of the UITextField for the stepper value
    UIFont *font = [UIFont fontWithName:fontName
                                   size:size];
    
    if (!font) {
        
        NSLog(@"[%@ %@]- Could not get specified font with name: %@",
              NSStringFromClass(self.class), NSStringFromSelector(_cmd), fontName);
    }
    
    self.textFont = (font) ? font : [UIFont boldSystemFontOfSize:size];
    
    // Center UITextField for Stepper Value
    self.valueTextField.adjustsFontSizeToFitWidth = YES;
    
    if (0 < size) {
        
        self.valueTextField.font = self.textFont;
        
    } else {
        
        CGFloat maxFontSize = self.valueTextField.frame.size.height;
        
        UIFont *fieldFont = nil;
        
        NSString *textFieldString = (self.valueTextField.text) ? (self.valueTextField.text) : @"5";
        
        CGSize size = [textFieldString sizeWithFont:[UIFont fontWithName:fontName
                                                                    size:maxFontSize]];
        
//        CGSize size = [textFieldString sizeWithAttributes:(nullable NSDictionary<NSString *,id> *)];
        
        while (size.height >= self.valueTextField.frame.size.height) {
            
            maxFontSize --;
            
            fieldFont = [UIFont fontWithName:fontName
                                        size:maxFontSize];
            
            size = [textFieldString sizeWithFont:fieldFont];
        }
        
        self.valueTextField.font = [UIFont fontWithName:fontName
                                                   size:maxFontSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    
    _tintColor = tintColor;
    
    // Update the color of the buttons. They take care of setNeedsDisplay.
    self.increaseStepperButton.color = tintColor;
    
    self.decreaseStepperButton.color = tintColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.increaseStepperButton.cornerRadius = cornerRadius;
    
    self.decreaseStepperButton.cornerRadius = cornerRadius;
}

#pragma mark - User Interface Actions
- (void)longTouchDidBegin:(HQStepperButton *)sender {
    
    if (![sender isEnabled]) return;
    
    // Dismiss any current keyboard for the UITextField since we're using buttons now
    [self.valueTextField resignFirstResponder];
    
    [sender setHighlighted:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    double changeValue;
    
    if (sender == self.decreaseStepperButton) {
        
        changeValue = -1 * self.stepValue;
        
    } else if (sender == self.increaseStepperButton) {
        
        changeValue = self.stepValue;
        
    } else {
        
        NSLog(@"[%@ %@]- Unrecognized sender: %@",
              NSStringFromClass(self.class), NSStringFromSelector(_cmd), sender);
        return;
    }
    
    self.valueDuringAction = [NSString stringWithFormat:@"%@",@(changeValue)];
    
    [self performSelector:@selector(longTouchInProgress)
               withObject:nil
               afterDelay:self.autorepeatInterval];
}

- (void)longTouchInProgress {
        
    [self performSelectorOnMainThread:@selector(incrementValue:)
                               withObject:self.valueDuringAction
                            waitUntilDone:YES];
}

- (void)incrementValue:(NSNumber *)amount {
    
    double amountValue = [amount doubleValue];
    
    double newValue = [self.valueTextField.text doubleValue] + amountValue;
    
    if (amountValue > 0) {
        
        if (newValue > self.maximumValue) {
            
            if (!self.wraps) return;
            
            else newValue = self.minimumValue;
        }
        
    } else {
        
        if (newValue < self.minimumValue) {
            
            if (!self.wraps) return;
            
            else newValue = self.maximumValue;
        }
    }
    
    self.currentValue = [NSString stringWithFormat:@"%@",@(newValue)];
    
    self.valueTextField.text = [NSString stringWithFormat:@"%@",self.currentValue];
    
    [self Notification:Nil
          currentValue:self.currentValue];
}

#pragma mark —— 通知传值

-(void)Notification:(UITextField *)textField
       currentValue:(NSString *)value{

    NSMutableDictionary *mutDict;
    
    if (![NSString isEmpty:textField.text] &&
        ![NSString isEmpty:value]) return;
    
    if (![NSString isEmpty:textField.text] &&
        [NSString isEmpty:value]){
    
        mutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:textField.text,@"UserInputTextFieldInfo",
                                        @"null",@"currentValue", nil];
    }
    
    if ([NSString isEmpty:textField.text] &&
        ![NSString isEmpty:value]){
    
        mutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"null",@"UserInputTextFieldInfo",
                                        value,@"currentValue", nil];
    }

    NSLog(@"%@",mutDict);
    
    NSNotification *notification =[NSNotification notificationWithName:@"UserInputInfo"
                                                                object:nil
                                                              userInfo:mutDict];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}




@end
