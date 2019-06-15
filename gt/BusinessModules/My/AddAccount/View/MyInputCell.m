//
//  MyInputCell.m
//  gt
//
//  Created by cookie on 2018/12/21.
//  Copyright © 2018 GT. All rights reserved.
//

#import "MyInputCell.h"
#import "LoginVM.h"
@interface MyInputCell()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * rmbLa;
@property (nonatomic, copy)TwoDataBlock block;
@property (nonatomic, assign)NSInteger sum;
@property (nonatomic ,strong) UIButton *getCodeBu;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger count;
@end
@implementation MyInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, MAINSCREEN_WIDTH - 40, 24)];
        self.titleLb.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.titleLb];
        
        self.rmbLa = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 90, CGRectGetMaxY(self.titleLb.frame) + 7, 70, 23)];
        self.rmbLa.textAlignment = NSTextAlignmentRight;
        self.rmbLa.font = [UIFont systemFontOfSize:16];
        self.rmbLa.text = @"CNY";
        self.rmbLa.hidden = YES;
        [self.contentView addSubview:self.rmbLa];
        
        self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 40, 23)];
        
        self.inputTF.clearButtonMode = UITextFieldViewModeAlways;
        self.inputTF.keyboardType =  UIKeyboardTypeDefault;
//        self.inputTF.borderStyle = UITextBorderStyleNone;
        self.inputTF.font = [UIFont systemFontOfSize:15];
        self.inputTF.delegate = self;
        [self.contentView addSubview:_inputTF];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.inputTF.frame) + 10, MAINSCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:232.0/256 green:233.0/256 blue:237.0/256 alpha:1];
        [self.contentView addSubview:lineView];
        
        
//        make.top.mas_equalTo(codeLab.mas_bottom).offset(152);
//        make.right.mas_equalTo(-30);
//        make.width.mas_equalTo(118);
//        make.height.mas_equalTo(48);
        self.getCodeBu = [UIButton buttonWithType:UIButtonTypeCustom];
        self.getCodeBu.frame = CGRectMake(MAINSCREEN_WIDTH- 100 - 15, 50, 100, 30);
        [self.getCodeBu setTitle:@"获取验证码"
                        forState:UIControlStateNormal];
        self.getCodeBu.titleLabel.font = kFontSize(15);
        
        [self.contentView addSubview:self.getCodeBu];
        [self.getCodeBu setTintColor:HEXCOLOR(0xf7f9fa)];
        self.getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
        self.getCodeBu.layer.masksToBounds = YES;
        self.getCodeBu.layer.cornerRadius = 15*SCALING_RATIO;
        [self.getCodeBu addTarget:self
                           action:@selector(getCodeButClick)
                 forControlEvents:UIControlEventTouchUpInside];
        self.getCodeBu.hidden = YES;
    }
    return self;
}

+(CGFloat)cellHeightWithModel{
    return 85;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    MyInputCell *cell = (MyInputCell *)[tabelView dequeueReusableCellWithIdentifier:@"MyInputCell"];
    if (!cell) {
        cell = [[MyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model
                       WithIndexRow:(NSInteger)row{
    
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
    self.inputTF.secureTextEntry = YES;
    
    if (model.allKeys[0] && [model.allKeys[0] isEqualToString:@"手机短信验证码"]) {
        self.getCodeBu.hidden = NO;
        self.getCodeBu.userInteractionEnabled = YES;
        self.inputTF.frame = CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 110, 23);
    }else{
        self.getCodeBu.hidden = YES;
        self.getCodeBu.userInteractionEnabled = NO;
        self.inputTF.frame = CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 40, 23);
    }
}

- (void)richElementsInNotYetVertifyCellWithModel:(NSDictionary*)model
                                    WithIndexRow:(NSInteger)row{
    
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
}

- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model
                                 WithIndexRow:(NSInteger)row
                             WithAllSourceSum:(NSInteger)sum{
    
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
    self.sum = sum;
    if ([self.titleLb.text isEqualToString:accountS]) {
        self.rmbLa.hidden = NO;
        self.inputTF.frame = CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 110, 23);
    }else{
        self.rmbLa.hidden = YES;
        self.inputTF.frame = CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 40, 23);
    }
    if(row  == sum-1)self.inputTF.secureTextEntry = YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.block) {
        
        self.block(textField,![NSString isEmpty:textField.text]?textField.text:@"");
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{

//}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
    if (self.sum>0&& textField.tag == self.sum-2) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 15)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (void)actionBlock:(TwoDataBlock)block{
    
    self.block = block;
}

-(void)getCodeButClick{
    [self getpPhoneCode:@""];
}


-(void)startTime{
    [self stopTime];
    self.count = 60;
    [self.getCodeBu setTitle:[NSString stringWithFormat:@"%ld s",self.count]
                    forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)timerAction{
    self.count --;
    if (self.count < 0) {
        [self stopTime];
        self.getCodeBu.userInteractionEnabled = YES;
        self.getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
    }else{
        self.getCodeBu.userInteractionEnabled = NO;
        self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
        [self.getCodeBu setTitle:[NSString stringWithFormat:@"%ld s",self.count]
                        forState:UIControlStateNormal];
    }
}

-(void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.getCodeBu.userInteractionEnabled = YES;
    [self.getCodeBu setTitle:@"重新发送"
                    forState:UIControlStateNormal];
}

-(void)getpPhoneCode:(NSString*)phone{
    
//    if (phone == nil || phone.length < 2  || [phone  isEqualToString:@"*null*"] || [phone  isEqualToString:@"null"] ) {
//        [YKToastView showToastText:@"暂未获取到手机号码 !"];
//        return;
//    }
    NSArray *ar = @[phone,@"2"];
    self.getCodeBu.userInteractionEnabled = NO;
    self.getCodeBu.backgroundColor = HEXCOLOR(0xcccccc);
    [LoginVM getCodeWithPhoneParams:ar success:^(id data) {
        [YKToastView showToastText:@"验证码发送出成功"];
        [self startTime];
    } failed:^(id data) {
        self.getCodeBu.userInteractionEnabled = YES;
        self.getCodeBu.backgroundColor = HEXCOLOR(0x4c7fff);
        [self stopTime];
    } error:^(id data) {}];
}
-(void)dealloc{
    [self stopTime];
}

@end
