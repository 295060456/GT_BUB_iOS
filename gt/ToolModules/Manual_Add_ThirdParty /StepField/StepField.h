//
//  StepField.h
//  gt
//
//  Created by Administrator on 26/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResultBlock)(NSString *str,NSString *resultStr,NSDictionary *resultStrDic,BOOL isOK);

@interface StepField : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,assign)NSInteger fieldCount;

@property(nonatomic,copy)ResultBlock resultBlock;

@end

@class UITextFieldAddDel;

@protocol TextFieldDelegate <NSObject>

- (void)textFieldDelete:(UITextFieldAddDel *)textField;

@end

@interface UITextFieldAddDel : UITextField

@property(nonatomic,assign)id <TextFieldDelegate> delDelegate;

@end

NS_ASSUME_NONNULL_END
