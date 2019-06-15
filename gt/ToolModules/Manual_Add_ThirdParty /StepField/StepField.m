//
//  StepField.m
//  gt
//
//  Created by Administrator on 26/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "StepField.h"

@interface StepField ()<TextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *textFieldArr;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger fildTextLength;

@end

@implementation StepField

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]){
        
//        self.backgroundColor = KGreenColor;
    }
    
    return self;
}

-(void)setFieldCount:(NSInteger)fieldCount{
    
    _fieldCount = fieldCount;
    
    [self initUI];
}

-(void)initUI{
    
    for (UIView *view in self.subviews){
        
        [view removeFromSuperview];
    }
    
    _fildTextLength = 1;
    
    self.textFieldArr = [self addMenuButton:_fieldCount];
}

-(NSMutableArray *)addMenuButton:(NSInteger)count{
    
    NSMutableArray *arrReturn = [NSMutableArray array];
    
    CGFloat screenW =  CGRectGetWidth(self.bounds);
    
    CGFloat space = 15;
    
    CGFloat y = 0;
    
    CGFloat w = (screenW - space * (count - 1)) / count;
    
    CGFloat h = self.frame.size.height;
    
    for (int i = 0;  i < count ; i++){
        
        UITextFieldAddDel *textField = [[UITextFieldAddDel alloc]init];
        
        textField.userInteractionEnabled = YES;
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        textField.borderStyle = UITextBorderStyleLine;
        
        [textField addTarget:self
                      action:@selector(valueChange:)
            forControlEvents:(UIControlEventEditingChanged)];
        
        textField.delDelegate = self;
        
        textField.frame = CGRectMake((w + space) * i, y, w, h);
        
        [NSObject cornerCutToCircleWithView:textField
                            AndCornerRadius:8];
        
        [NSObject colourToLayerOfView:textField
                           WithColour:HEXCOLOR(0xdddddd)
                       AndBorderWidth:1];
        
        [textField setTextAlignment:(NSTextAlignmentCenter)];
        
        [self addSubview:textField];
        
        [arrReturn addObject:textField];
    }
    
    return arrReturn;
}

-(void)valueChange:(UITextField *)textfield{
  
    // 当前输入框的下标
    NSInteger currentIndex = 0;
    
    for (NSInteger i = 0; i < self.textFieldArr.count; i++){
        
        UITextField *fild = self.textFieldArr[i];
        
        if (fild == textfield){
            
            currentIndex = i;
        }
        
        // 以下标为key 输入框内容为value 做键对存储
        NSString *key = [NSString stringWithFormat:@"%zd",i];
        
        NSString *value = Nil;
        
        if (fild.text.length > 0){
            
            value = fild.text;
        } else{
            
            value = @" ";
        }
        
        [self.dic setValue:value
                    forKey:key];
    }
    
    // 从字典中取数所有的输入框内容
    NSString *strAll = [NSString string];
    
    for (NSInteger i = 0; i < self.textFieldArr.count - 1; i++){
        
        NSString *key = [NSString stringWithFormat:@"%zd",i];
        
        NSString *value = [_dic valueForKey:key];
        
        strAll = [strAll stringByAppendingString:value];
    }
    
    // 判断输入内容 如果当前输入框内容为空用空格代替 更新对应的字典
    NSString *key = [NSString stringWithFormat:@"%zd",currentIndex];
    
    if (textfield.text.length > 0){
        
        if (textfield.text.length > _fildTextLength){
            
            NSRange range = NSMakeRange(textfield.text.length - _fildTextLength, _fildTextLength);
            
            textfield.text = [textfield.text substringWithRange:range];
        }
        
        [self.dic setObject:textfield.text
                     forKey:key];
    }else{
        
        [self.dic setObject:@" "
                     forKey:key];
    }
    
    self.text = strAll;
    // 更新当前需要编辑的输入框
    UITextField *fild;
    if (currentIndex + 1 > self.textFieldArr.count - 1){
        
        fild = self.textFieldArr.lastObject;
    }else{
        
        if (self.text.length > strAll.length){
            
            if (currentIndex >= self.textFieldArr.count - 1){
                
                fild  = self.textFieldArr[currentIndex];
            }else{
                
                fild  = self.textFieldArr[currentIndex + 1];
            }
        }else{
            
            if (currentIndex < 0){
                
                fild  = self.textFieldArr[0];
            }else{
                fild  = self.textFieldArr[currentIndex + 1];
            }
        }
    }
    [fild becomeFirstResponder];
    
    if (self.resultBlock){
        
        NSArray *arr = [_dic allValues];
        
        BOOL isOK = [arr containsObject:@" "];
        
        isOK = !isOK;
        
        NSString *resultStr = @"";
        
        for (int t = 0; t < self.dic.count; t++) {
            
            NSString *indexStr = [NSString stringWithFormat:@"%d",t];
            
            NSString *tempStr = self.dic[indexStr];
            
            resultStr = [resultStr stringByAppendingString:tempStr];
        }
        
        self.resultBlock(self.text,resultStr,self.dic,isOK);
    }
}

- (void)textFieldDelete:(UITextFieldAddDel *)textField{
    
    //    NSLog(@"删除 = %@",textField.text);
    if (textField.text.length == 0){
        // 找到当前编辑的输入框的下标
        NSInteger currentIndex = 0;
        
        for (int i = 0;  i < self.textFieldArr.count; i++){
            
            UITextFieldAddDel *fild = self.textFieldArr[i];
            
            if (fild == textField){
                
                currentIndex = i;
                
                break;
            }
        }
        
        if (currentIndex <= 0){
            
            UITextFieldAddDel *fild = self.textFieldArr.firstObject;
            
            [fild becomeFirstResponder];
        }else{
            
            UITextFieldAddDel *fild = self.textFieldArr[currentIndex - 1];
            
            [fild becomeFirstResponder];
        }
    }
    
    // 当前输入框的下标
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.textFieldArr.count; i++){
        
        UITextField *fild = self.textFieldArr[i];
        
        if (fild == textField){
            
            currentIndex = i;
        }
        
        // 以下标未key 输入框内容为value 做键对存储
        NSString *key = [NSString stringWithFormat:@"%zd",i];
        NSString *value ;
        
        if (fild.text.length > 0){
            
            value = fild.text;
        }else{
            
            value = @" ";
        }
        
        [self.dic setValue:value
                    forKey:key];
    }
    
    // 从字典中取数所有的输入框内容
    NSString *strAll = [NSString string];
    
    for (NSInteger i = 0; i< self.textFieldArr.count-1; i++){
        
        NSString *key = [NSString stringWithFormat:@"%zd",i];
        
        NSString *value = [_dic valueForKey:key];
        
        strAll = [strAll stringByAppendingString:value];
    }
    
    // 判断输入内容 如果当前输入框内容为空用空格代替 更新对应的字典
    NSString *key = [NSString stringWithFormat:@"%zd",currentIndex];
    
    if (textField.text.length > 0){
        
        if (textField.text.length > _fildTextLength){
            
            NSRange range = NSMakeRange(textField.text.length - _fildTextLength, _fildTextLength);
            
            textField.text = [textField.text substringWithRange:range];
        }

        [self.dic setObject:textField.text
                     forKey:key];
    }else{
        
        [self.dic setObject:@" "
                     forKey:key];
        
    }
    
    self.text = strAll;
    
    if (self.resultBlock){
        
        NSArray *arr = [_dic allValues];
        
        BOOL isOK = [arr containsObject:@" "];
        
        isOK = !isOK;
        
        NSString *resultStr = @"";
        
        for (int t = 0; t < self.dic.count; t++) {
            
            NSString *indexStr = [NSString stringWithFormat:@"%d",t];
            
            NSString *tempStr = self.dic[indexStr];
            
            resultStr = [resultStr stringByAppendingString:tempStr];
        }
        
        self.resultBlock(self.text,resultStr,self.dic,isOK);
    }
}

-(NSMutableDictionary *)dic{
    
    if (!_dic){
        
        _dic = [NSMutableDictionary dictionary];
    }
    
    return _dic;
}

-(NSString *)text{
    
    if (!_text) {
        
        _text = [NSString string];
    }
    
    return _text;
}

@end

@implementation UITextFieldAddDel

- (void)deleteBackward {
    
    [super deleteBackward];
    
    //    ！！！这里要调用super方法，要不然删不了东西
    if ([self.delDelegate respondsToSelector:@selector(textFieldDelete:)]){
        
        [self.delDelegate textFieldDelete:self];
    }
    
}

@end
