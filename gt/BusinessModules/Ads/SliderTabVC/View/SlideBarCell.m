//
//  SlideBarCell.m
//  SlideTabBar
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "SlideBarCell.h"
#import "FixedRectTagView.h"
@interface SlideBarCell ()<UITextFieldDelegate>
@property (nonatomic, strong)UILabel* numberTipLab;
@property (nonatomic, strong)UILabel* timeTipLab;
@property (nonatomic,assign) NSInteger accountType;
@property (nonatomic, strong)NSArray* model;
@property (nonatomic, strong) NSMutableArray* tflabs;
@property (nonatomic, strong) NSMutableArray* tfs;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, strong) NSMutableArray* rightLabs;
@property (nonatomic, strong) NSMutableArray* rightTfs;

@property (nonatomic, strong)UIImageView* rangeLine;
@property (nonatomic, strong)UILabel* decLab;

@property (nonatomic, strong)FixedRectTagView* tagView;
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong)UITextField* tf0;
@property (nonatomic, strong)UITextField* tf1;

@property (nonatomic, copy)NSString* tf0String;
@property (nonatomic, copy)NSString* tf1String;

@property (nonatomic, strong)UITextField* rtf0;
@property (nonatomic, strong)UITextField* rtf1;

@property (nonatomic, copy)NSString* rtf0String;
@property (nonatomic, copy)NSString* rtf1String;

@property (nonatomic, copy)NSString* btnTit;
@end

@implementation SlideBarCell
+(instancetype)cellWith:(UITableView*)tabelView{
    SlideBarCell *cell = (SlideBarCell *)[tabelView dequeueReusableCellWithIdentifier:@"SlideBarCell"];
    if (!cell) {
        cell = [[SlideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SlideBarCell"];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _tfs = [NSMutableArray array];
    _tflabs = [NSMutableArray array];
    
    _leftLabs = [NSMutableArray array];
    _rightLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    [self layoutAccountType0];

    [self layoutAccountType1];
    
    NSArray* limitAccounts = GetUserDefaultWithKey(kLimitAccountsInPostAds);//data
    UITextField* tf0 = _tfs[0];
    UITextField* tf1 = _tfs[1];
    
    _tf0 = tf0;
    _tf1 = tf1;
    
    _tf0.text = limitAccounts[0];
    _tf1.text = limitAccounts[1];
    
    _tf0String = ![NSString isEmpty:_tf0.text]?_tf0.text:@"";
    _tf1String = ![NSString isEmpty:_tf1.text]?_tf1.text:@"";
    
    
    
    UILabel* tflab0 = _tflabs[0];
    tflab0.text = @"最小限额";
    UILabel* tflab1 = _tflabs[1];
    tflab1.text = @"最大限额";
    _rangeLine.backgroundColor = HEXCOLOR(0x394368);
    
    NSArray* controlTimes = GetUserDefaultWithKey(kControlTimeInPostAds);
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    
    NSArray  *optionPrices = GetUserDefaultWithKey(kLimitAccountsInPostAds);
    NSString* maxlim = @"";
//    if ([GetUserDefaultWithKey(kControlNumberInPostAds) intValue]>[optionPrices[1] intValue]) {
        maxlim = optionPrices[1];
//    }else{
//        maxlim = GetUserDefaultWithKey(kControlNumberInPostAds);
//    }
    
    rtf0.placeholder =[NSString stringWithFormat:@"  请输入卖出数量%@ - %@",optionPrices[0],maxlim];
    
    rtf1.placeholder = [NSString stringWithFormat:@"  请输入付款期限%@ - %@",controlTimes[0],controlTimes[1]];
    [_rightTfs[1] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-57);
    }];
    
    _rtf0 = rtf0;
    _rtf1 = rtf1;
    
    NSArray* nts = GetUserDefaultWithKey(kNumberAndTimeInPostAds);
    _rtf0.text = nts[0];
    _rtf1.text = nts[1];
    _rtf0String = ![NSString isEmpty:_rtf0.text]?_rtf0.text:@"";
    _rtf1String = ![NSString isEmpty:_rtf1.text]?_rtf1.text:@"";
    
}

- (void)richElementsInCellWithType:(NSInteger)accountType WithModel:(NSArray*)model{
    _model = model;
    _accountType = accountType;
    UITextField* tf0 = _tfs[0];
    
    UITextField* tf1 = _tfs[1];
    
    
    
    
    UILabel* tflab0 = _tflabs[0];
    
    UILabel* tflab1 = _tflabs[1];
    
//    if (_tagView) {
//        [_tagView removeAllSubViews];
//    }
//    _tagView = [[FixedRectTagView alloc ]initBtnWithFrame:CGRectMake(40, 49, MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:@[@"10",@"100",@"1000",@"11999"]];
//    _tagView.clickSectionBlock = ^(NSInteger sec, NSString *btnTit) {
//        NSLog(@"%ld,.....%@",(long)sec,btnTit);
//    };
//    [self addSubview:_tagView];
    
    if (accountType ==0) {
        tf0.hidden = NO;
        tf1.hidden = NO;
        tflab0.hidden = NO;
        tflab1.hidden = NO;
        _rangeLine.hidden = NO;
        
        _tagView.hidden = YES;
    }else{
        tf0.hidden = YES;
        tf1.hidden = YES;
        tflab0.hidden = YES;
        tflab1.hidden = YES;
        _rangeLine.hidden = YES;
        
        _tagView.hidden = NO;
        
    }
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"卖出数量";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"付款期限";
    
    UILabel* rlab0 = _rightLabs[0];
//    rlab0.text = [NSString stringWithFormat:@"%@",accountType ==0?@"2349875690":@"23"];
    rlab0.textColor = kClearColor;//[YBGeneralColor themeColor];
    
    UILabel* rlab1 = _rightLabs[1];
    rlab1.text = @"分钟";
    rlab1.textColor = HEXCOLOR(0x394368);
//    rlab1.attributedText = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@   ",accountType ==0?@"28":@"29"] stringColor:[YBGeneralColor themeColor] stringFont:kFontSize(15) subString:@"分钟" subStringColor:HEXCOLOR(0x394368) subStringFont:kFontSize(13)];

    
    _decLab.text = @"买家需要在付款期限内转账并点击确认付款，超过时限该笔交易将自动取消，您可以依据不同的交易方式来调整时限。";
    
    
    if (_accountType ==0) {
        if (self.block) {
            self.block(@(_accountType+1), @[_tf0String,_tf1String,_rtf0String,_rtf1String]);
        }
    }else{
        if (self.block) {
            self.block(@(_accountType+1), @[![NSString isEmpty:_btnTit]? _btnTit:@"",_rtf0String,_rtf1String]);
        }
    }
    
    
}
-(void)textField1TextChange:(UITextField *)textField{
    if ([_tf0 isEqual:textField]
        ||[_tf1 isEqual:textField]
        ||[_rtf0 isEqual:textField]) {
        _numberTipLab.text = @"";
    }else if ([_rtf1 isEqual:textField]){
        _timeTipLab.text = @"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    NSArray  *optionPrices = GetUserDefaultWithKey(kLimitAccountsInPostAds);
    NSString* maxlim = @"";
//    if ([GetUserDefaultWithKey(kControlNumberInPostAds) intValue]>[optionPrices[1] intValue]) {
        maxlim = optionPrices[1];
//    }else{
//        maxlim = GetUserDefaultWithKey(kControlNumberInPostAds);
//    }
    NSString* minlim = optionPrices[0];
    
    NSString* number = GetUserDefaultWithKey(kControlNumberInPostAds);
    if ([_tf0 isEqual:textField]) {
        if (![NSString isEmpty:textField.text]) {
            int i = [textField.text intValue];
            if (i>0) {
                if (!(i<[maxlim intValue])) {
                    _numberTipLab.text = @"*最大限额必须大于最小限额";
                }
                if (i<[minlim intValue]) {
                     _numberTipLab.text = [NSString stringWithFormat:@"*最小限额不可小于%@",minlim];
                }
            }else{
                _numberTipLab.text = @"*最小限额不能为0";
                
            }
            _tf0String = [NSString stringWithFormat:@"%d",i];
            textField.text = _tf0String;
        }else{
            _tf0String = @"";
            _numberTipLab.text = @"*最小限额不能为空";
        }
    }
    
    
    if ([_tf1 isEqual:textField]) {
        if (![NSString isEmpty:textField.text]) {
            int i = [textField.text intValue];
            if (i>0) {
                if (i<[minlim intValue]) {
                    _numberTipLab.text = [NSString stringWithFormat:@"*最大限额不可小于%@",minlim];
                }
                if (i>[maxlim intValue]) {
                    _numberTipLab.text = [NSString stringWithFormat:@"*最大限额不可大于%@",maxlim];
                }
                if (i>[number intValue]) {
                    _numberTipLab.text = [NSString stringWithFormat:@"*您当前可用余额不足"];
                }
            }else{
                _numberTipLab.text = @"*最大限额不能为0";
            }
            _tf1String = [NSString stringWithFormat:@"%d",i];
            textField.text = _tf1String;
        }else{
            _tf1String = @"";
            _numberTipLab.text = @"*最大限额不能为空";
        }
    }
    
    
    if ([_rtf0 isEqual:textField]) {
        if (![NSString isEmpty:textField.text]) {
            int i = [textField.text intValue];
            if (i>0) {
                if (_accountType ==0) {
                    if (i>[number intValue]) {
                        _numberTipLab.text = [NSString stringWithFormat:@"*卖出数量已超过您当前的可用余额（%@）",number];
                    }
                    if (i<[minlim intValue]) {
                        _numberTipLab.text = [NSString stringWithFormat:@"*卖出数量不可小于最小限额"];
                    }
                }else{
                    if (![NSString isEmpty:self.btnTit]){
                        BOOL isDouble = [NSString judgeIsDoubleStr:self.btnTit with:[NSString stringWithFormat:@"%i",i]];
                        if (!isDouble)_numberTipLab.text = @"*固额卖出数量必须为所选额度的整数倍";
                    }
                }
                
            }else{
                
                _numberTipLab.text = @"*卖出数量不能0";
            }
            _rtf0String = [NSString stringWithFormat:@"%d",i];
            textField.text = _rtf0String;
            
        }else{
            _rtf0String = @"";
            _numberTipLab.text = @"*卖出数量不能空";
        }
        
    }
    
    NSArray* prompt =  GetUserDefaultWithKey(kControlTimeInPostAds);
    if ([_rtf1 isEqual:textField]) {
        
        if (![NSString isEmpty:textField.text]) {
            int i = [textField.text intValue];
            if (i>0) {
                if (i<[prompt[0] intValue]) {
                    _timeTipLab.text = [NSString stringWithFormat:@"*最短期限不得小于%@分钟",prompt[0]];
                    
                }
                if (i>[prompt[1] intValue]) {
                    _timeTipLab.text = [NSString stringWithFormat:@"*最长期限不得大于%@分钟",prompt[1]];
                    
                }
            }else{
                _timeTipLab.text = @"*付款期限不能0";
            }
            _rtf1String = [NSString stringWithFormat:@"%d",i];
            textField.text = _rtf1String;
            
        }else{
            _rtf1String = @"";
            _timeTipLab.text = @"*付款期限不能空";
        }
        
    }
    if (_accountType ==0) {
        if (self.block) {
            self.block(@(_accountType+1), @[_tf0String,_tf1String,_rtf0String,_rtf1String]);
        }
    }else{
        if (self.block) {
            self.block(@(_accountType+1), @[![NSString isEmpty:_btnTit]? _btnTit:@"",_rtf0String,_rtf1String]);
        }
    }
}
-(void)layoutAccountType0{
    for (int i=0; i<2; i++) {
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
        [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
        tf.textAlignment = NSTextAlignmentCenter;
        tf.layer.cornerRadius = 17.5;
        tf.layer.borderWidth = 1;
        tf.layer.masksToBounds = YES;
        tf.backgroundColor = HEXCOLOR(0xf2f1f6);
        tf.textColor = HEXCOLOR(0x394368);
        tf.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        [self addSubview:tf];
        [_tfs  addObject:tf];
        
        UILabel* tfLab = [[UILabel alloc]init];
        tfLab.text = @"A";
        tfLab.tag = i;
        tfLab.textAlignment = NSTextAlignmentCenter;
        tfLab.textColor = HEXCOLOR(0x333333);
        tfLab.font = kFontSize(15);
        [self addSubview:tfLab];
        [_tflabs addObject:tfLab];
    }
    
    
    [_tfs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:120 leadSpacing:40 tailSpacing:40];
    
    [_tfs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(49);
        make.height.mas_equalTo(@35);
    }];
    
    WS(weakSelf);
    [_tflabs[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tfs[0]);
        make.top.offset(20);
        make.height.mas_equalTo(@21);
    }];
    [_tflabs[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tfs[1]);
        make.top.offset(20);
        make.height.mas_equalTo(@21);
    }];
    _rangeLine = [[UIImageView alloc]init];
    [self.contentView addSubview:_rangeLine];
    [_rangeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.tfs[0]);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@2);
    }];
//    [_tfs[0]  layoutIfNeeded];
    
    [self layoutAccountPublic];
}

-(void)layoutAccountType1{
    NSArray  *optionPrices = GetUserDefaultWithKey(kLimitAccountsInPostAds);
//    if (_tagView) {
//        [_tagView removeAllSubViews];
//    }
    _tagView = [[FixedRectTagView alloc ]initBtnWithFrame:CGRectMake(20, -5, MAINSCREEN_WIDTH-40, 0) isFixedBtnWidth:YES withTitleArray:
                GetUserDefaultWithKey(kFixedAccountsInPostAds)];
    [_tagView selecedBtn:GetUserDefaultWithKey(kFixedAccountsSelectedItemInPostAds)];
    self.btnTit = ![NSString isEmpty:GetUserDefaultWithKey(kFixedAccountsSelectedItemInPostAds)]? GetUserDefaultWithKey(kFixedAccountsSelectedItemInPostAds):@"";
    kWeakSelf(self);
    _tagView.clickSectionBlock = ^(UIButton* btn, NSString *btnTit) {
        kStrongSelf(self);
        NSLog(@"%ld,.....%@",(long)btn.tag,btnTit);
        self.numberTipLab.text = @"";
        if (![NSString isEmpty:btnTit]) {
            if ([btnTit intValue]>[GetUserDefaultWithKey(kControlNumberInPostAds) intValue]
                ||
                [btnTit intValue]<[optionPrices[0] intValue]) {
                
//                [YKToastView showToastText:@"请选择正确的固定额度"];
            }
            self.btnTit = btnTit;
        }else{
            self.btnTit = @"";
            
        }
        
        
        if (self.block) {
            self.block(@(self.accountType+1), @[![NSString isEmpty: self.btnTit]?  self.btnTit:@"",self.rtf0String,self.rtf1String]);
        }
    };
    [self addSubview:_tagView];
    
}

-(void)layoutAccountPublic{
    self.numberTipLab = [[UILabel alloc]init];
    self.numberTipLab.textAlignment = NSTextAlignmentRight;
    self.numberTipLab.textColor = [UIColor redColor];
    self.numberTipLab.font = kFontSize(11);
    self.numberTipLab.text = @"";
    [self addSubview:self.numberTipLab];
    [self.numberTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@24);
        make.trailing.equalTo(@-24);
        make.top.equalTo(self.mas_bottom).offset(-218);
        make.height.equalTo(@11);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(49+34+scrollUpView.frame.size.height);
        
        
        make.leading.equalTo(self).offset(24);
        make.trailing.equalTo(self).offset(-24);
        make.bottom.equalTo(self).offset(-110);
        make.height.equalTo(@95);
        //        make.top.equalTo(scrollBeforeView.mas_bottom).offset(34);
        //        make.leading.equalTo(self).offset(24);
        //       make.trailing.equalTo(self).offset(-24);
//        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(118, 24, 110, 24));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x94368);
        leftLab.font = kFontSize(15);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        
        UILabel* rightLab = [[UILabel alloc]init];
        rightLab.text = @"B";
        rightLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = HEXCOLOR(0x94368);
        rightLab.font = kFontSize(15);
        [sub_view addSubview:rightLab];
        [_rightLabs addObject:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentRight;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);
        [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
//        tf.scrollEnabled = NO;

//        tf.zw_placeHolderColor = HEXCOLOR(0x999999);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
//            make.width.equalTo(@160);
//            make.height.equalTo(@40);
        }];
        
        
        [containView addSubview:sub_view];
        
        
        
        sub_view.layer.cornerRadius = 4;
        sub_view.layer.borderWidth = 1;
        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(40));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                //                //上1个
                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
                
                
            }
            
        }];
        //最后一个
        sub_view.backgroundColor = kWhiteColor;
        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        
        
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(15);
    }];
    
    _decLab = [[UILabel alloc]init];
    _decLab.text = @"A";
    _decLab.textAlignment = NSTextAlignmentLeft;
    _decLab.textColor = HEXCOLOR(0x000000);
    _decLab.font = kFontSize(14);
    _decLab.numberOfLines = 0;
    [self addSubview:_decLab];
    [_decLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(24);
        make.trailing.equalTo(self).offset(-24);
        
        make.top.equalTo(scrollView.mas_bottom).offset(26);
    }];
    
    self.timeTipLab = [[UILabel alloc]init];
    self.timeTipLab.textAlignment = NSTextAlignmentRight;
    self.timeTipLab.textColor = [UIColor redColor];
    self.timeTipLab.font = kFontSize(11);
    self.timeTipLab.text = @"";
    [self addSubview:self.timeTipLab];
    [self.timeTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@24);
        make.trailing.equalTo(@-24);
        make.bottom.equalTo(self.decLab.mas_top).offset(-14);
        make.height.equalTo(@11);
    }];
    
}

+(CGFloat)cellHeightWithModelWithType:(NSInteger)accountType WithModel:(NSArray*)model{
//    UIView* tagView0 = [FixedRectTagView creatBtnWithFrame:CGRectMake(20,29, MAINSCREEN_WIDTH-40, 0) isFixedBtnWidth:YES withTitleArray:GetUserDefaultWithKey(kFixedAccountsInPostAds)];
//    return  accountType==0? 323:49+239+tagView0.size.height;
    return 323;
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.rtf0||textField == self.rtf1) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 13)
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
@end
