//
//  HQStepper+UITextFieldDelegate.h
//  JinXian Finance
//
//  Created by 刘赓 on 2017/7/13.
//  Copyright © 2017年 刘赓. All rights reserved.
//

#import "HQStepper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQStepper (UITextFieldDelegate)<UITextFieldDelegate>

-(void)UITextFieldDelegate;

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string;

- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
