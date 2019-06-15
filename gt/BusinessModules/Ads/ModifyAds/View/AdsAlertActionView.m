//
//  AdsAlertActionView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AdsAlertActionView.h"
#import "ModifyAdsModel.h"

@interface AdsAlertActionView ()<UITextFieldDelegate>

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) UITextField* tf;
@property (nonatomic, assign) float maxNumber;

@property (nonatomic, strong) UIView *mainView;

@end

@implementation AdsAlertActionView

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(MAINSCREEN_HEIGHT - 270 -height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self removeFromSuperview];
}

- (instancetype)initWitModle:(id)myData hBlock:(ActionBlock)block{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    
        self.backgroundColor = COLOR_HEX(0x000000, 0.5);
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.block = block;
        ModifyAdsModel* myModel = myData;
        
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor  = kWhiteColor;
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(120);
            make.width.mas_equalTo(MAINSCREEN_WIDTH);
            make.height.mas_equalTo(270);
        }];
        
        UILabel *titleLa = [[UILabel alloc] init];
        titleLa.text = @"广告信息";
        titleLa.font = kFontSize(16);
        titleLa.textColor = HEXCOLOR(0x000000);
//        titleLa.textAlignment = NSTextAlignmentCenter;
        [_mainView addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self->_mainView).offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(49);
        }];
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        [_mainView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.width.mas_equalTo(MAINSCREEN_WIDTH);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *idLa = [[UILabel alloc] init];
        idLa.font = kFontSize(14);
        idLa.textColor = HEXCOLOR(0x9a9a9a);
        [_mainView addSubview:idLa];
        idLa.text = @"广告ID";
//        idLa.backgroundColor = kRedColor;
        [idLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line1).offset(15);
            make.left.mas_equalTo(self->_mainView).offset(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(16);
        }];
        
        
        UILabel *idNuberLas = [[UILabel alloc] init];
        idNuberLas.font = kFontSize(14);
        idNuberLas.textColor = HEXCOLOR(0x000000);
        [_mainView addSubview:idNuberLas];
//        idNuberLas.backgroundColor = kRedColor;
        idNuberLas.textAlignment = NSTextAlignmentRight;
        idNuberLas.text = [NSString stringWithFormat:@"%@",myModel.ugOtcAdvertId];
        [idNuberLas mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line1).offset(15);
            make.left.mas_equalTo(self->_mainView).offset(120);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
        }];
        
        
        UILabel *idLa1 = [[UILabel alloc] init];
        idLa1.font = kFontSize(14);
        idLa1.textColor = HEXCOLOR(0x9a9a9a);
        [_mainView addSubview:idLa1];
        idLa1.text = @"广告剩余数量";
//        idLa1.backgroundColor = kRedColor;
        [idLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(idLa.mas_bottom).offset(15);
            make.left.mas_equalTo(self->_mainView).offset(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(16);
        }];

        
        
        UILabel *idNuberLas1 = [[UILabel alloc] init];
        idNuberLas1.font = kFontSize(14);
        idNuberLas1.textColor = HEXCOLOR(0x000000);
        [_mainView addSubview:idNuberLas1];
//        idNuberLas1.backgroundColor = kRedColor;
        idNuberLas1.textAlignment = NSTextAlignmentRight;
        idNuberLas1.text = [NSString stringWithFormat:@"%@BUB",myModel.balance];
        [idNuberLas1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(idLa.mas_bottom).offset(15);
            make.left.mas_equalTo(self->_mainView).offset(120);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
        }];
        
        UIView *bgtf = UIView.new;
        bgtf.backgroundColor = HEXCOLOR(0xf5f5f5);
         [_mainView addSubview:bgtf];
        [bgtf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(idNuberLas1.mas_bottom).offset(17);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
        
        self.tf = [[UITextField alloc] init];
        self.tf.delegate = self;
        self.tf.placeholder = @"请输入补充数";
        self.tf.keyboardType = UIKeyboardTypeNumberPad;
        [self.tf becomeFirstResponder];
        self.tf.font = kFontSize(15);
        [bgtf addSubview:self.tf];
        self.tf.backgroundColor = kClearColor;
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.centerY.equalTo(bgtf.mas_centerY);
        }];
        
        UILabel *la = [[UILabel alloc] init];
        la.font = kFontSize(14);
        la.textColor = HEXCOLOR(0x9a9a9a);
        [_mainView addSubview:la];
//        la.backgroundColor = kRedColor;
           self.maxNumber = [myModel.usableFund floatValue];
        la.text = [NSString stringWithFormat:@"可用余额：%@ BUB",myModel.usableFund];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgtf.mas_bottom).offset(5);
            make.left.mas_equalTo(self->_mainView).offset(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(13);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = HEXCOLOR(0xe8e9ed);
        [_mainView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(la.mas_bottom).offset(15);
            make.width.mas_equalTo(MAINSCREEN_WIDTH);
            make.height.mas_equalTo(1);
        }];
        
        UIButton *leftBu = [self creatButtonWithTitle:@"取消" setTitleColor:[YBGeneralColor themeColor] setImage:nil backgroundColor:nil cornerRadius:4 borderWidth:1 borderColor:[YBGeneralColor themeColor] action:@selector(cencalAction)];
        [_mainView addSubview:leftBu];
        [leftBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(MAINSCREEN_WIDTH/2-15-7.5);
            make.top.mas_equalTo(line2.mas_bottom).offset(10);
        }];
        
        UIButton *rightBu = [self creatButtonWithTitle:@"确定上架" setTitleColor:kWhiteColor setImage:nil backgroundColor:[YBGeneralColor themeColor] cornerRadius:4 borderWidth:0 borderColor:nil action:@selector(submitAction)];
        [_mainView addSubview:rightBu];
        [rightBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBu.mas_right).offset(15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(MAINSCREEN_WIDTH/2-15-7.5);
            make.top.mas_equalTo(line2.mas_bottom).offset(10);
        }];
        
    } return self;
}


-(void)cencalAction{
    [self.tf resignFirstResponder];
    [self removeFromSuperview];
}

-(void)submitAction{
    
    NSString *s = self.tf.text;
    if ([self isNum:s]) {
        if (s.length > 0) {
            NSInteger nu = [s integerValue];
            if (nu > 0) {
                if (self.maxNumber > nu ) {
                        if (self.block) {
                            self.block(self.tf);
                        }
                        [self cencalAction];
                }else{
                    [YKToastView showToastText:@"补充数量大于可用余额"];
                }
            }else{
                [YKToastView showToastText:@"请输入有效数量"];
            }
        }else{
            [YKToastView showToastText:@"请输入有效数量"];
        }
    }else{
        [YKToastView showToastText:@"请输入纯数字"];
    }
}

- (BOOL)isNum:(NSString *)checkedNumString { // 全数字
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
