//
//  HQStepper+UITextFieldDelegate.m
//  JinXian Finance
//
//  Created by 刘赓 on 2017/7/13.
//  Copyright © 2017年 刘赓. All rights reserved.
//

#import "HQStepper+UITextFieldDelegate.h"

@implementation HQStepper (UITextFieldDelegate)

-(void)UITextFieldDelegate{

    self.valueTextField.delegate = self;

}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"%@",textField.text);
    
    if ([textField.text doubleValue] < self.maximumValue &&
        [textField.text doubleValue] > self.minimumValue) {
        
        //发通知传值
        
        [self Notification:textField
              currentValue:Nil];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if ([textField isFirstResponder]) [self endEditing:YES];
    
    return YES;
}


@end
