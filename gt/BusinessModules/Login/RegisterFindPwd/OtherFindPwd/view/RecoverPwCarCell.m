//
//  RecoverPwCarCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "RecoverPwCarCell.h"

@interface RecoverPwCarCell ()<UITextFieldDelegate>
@property (nonatomic, copy)TwoDataBlock block;
//@property (nonatomic, assign)NSInteger sum;
@property (nonatomic, strong)UIView * lineView;
@end

@implementation RecoverPwCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, 25*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 24*SCALING_RATIO)];
        self.titleLb.font = [UIFont systemFontOfSize:16];
        self.titleLb.textColor = HEXCOLOR(0x333333);
        [self.contentView addSubview:self.titleLb];
        
        self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 23*SCALING_RATIO)];
        self.inputTF.clearButtonMode = UITextFieldViewModeAlways;
        self.inputTF.keyboardType =  UIKeyboardTypeDefault;
        //        self.inputTF.borderStyle = UITextBorderStyleNone;
        self.inputTF.font = [UIFont systemFontOfSize:16];
        self.inputTF.textColor = HEXCOLOR(0x333333);
        self.inputTF.delegate = self;
        [self.contentView addSubview:_inputTF];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.inputTF.frame) + 10, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 1)];
        self.lineView.backgroundColor = [UIColor colorWithRed:232.0/256 green:233.0/256 blue:237.0/256 alpha:1];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    RecoverPwCarCell *cell = (RecoverPwCarCell *)[tabelView dequeueReusableCellWithIdentifier:@"RecoverPwCarCell"];
    if (!cell) {
        cell = [[RecoverPwCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecoverPwCarCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model
                                 WithIndexRow:(NSInteger)row{
    NSString *key = model.allKeys[0];
    if ([key isEqualToString:@"AA"]) { // 窄的
        self.titleLb.hidden = YES;
        self.inputTF.frame = CGRectMake(30*SCALING_RATIO, 27*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 23*SCALING_RATIO);
        self.lineView.frame = CGRectMake(30*SCALING_RATIO, 62*SCALING_RATIO, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 1);
    }else{ // 宽的
        self.titleLb.hidden = NO;
        self.titleLb.text = key;
        self.inputTF.frame = CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 23*SCALING_RATIO);
        self.lineView.frame = CGRectMake(30*SCALING_RATIO, CGRectGetMaxY(self.inputTF.frame) + 10, MAINSCREEN_WIDTH - 60*SCALING_RATIO, 1);
    }
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.block) {
        
        self.block(textField,![NSString isEmpty:textField.text]?textField.text:@"");
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
//replacementString:(NSString *)string{
//    if (self.sum>0&& textField.tag == self.sum-2) {
//        //如果是删除减少字数，都返回允许修改
//        if ([string isEqualToString:@""]) {
//            return YES;
//        }
//        if (range.location>= 15)
//        {
//            return NO;
//        }
//        else
//        {
//            return YES;
//        }
//    }
//    return YES;
//}

- (void)actionBlock:(TwoDataBlock)block{
    
    self.block = block;
}
@end
