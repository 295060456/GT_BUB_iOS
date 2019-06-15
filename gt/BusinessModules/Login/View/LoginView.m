//
//  LoginView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/13.
//  Copyright © 2019 GT. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()<UITextFieldDelegate>
@property (nonatomic, copy)   DataTypeBlock block;
@property (nonatomic, strong) NSMutableArray* tipLabs;
@property (nonatomic, strong) NSMutableArray* lines;
@property (nonatomic, strong) NSMutableArray*sub_views;
@property (nonatomic, strong) UIButton *eyeStatusBtn;
@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *forgetPWBtn;
@property (nonatomic, strong) UIButton *toRegisteredBtn;
@property (nonatomic, strong) UIButton *onlineCustomerServiceBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) NSMutableArray *caveatImArrary;
@end


@implementation LoginView
-(instancetype)initViewSuccess:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = kWhiteColor;
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    } return self;
}

-(void)dealloc{
       [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initView {
    
    UIImage* decorImage = kIMG(@"logo");
    UIImageView *decorIv = [[UIImageView alloc]init];
    [self addSubview:decorIv];
    [decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YBSystemTool.isIphoneX?100:90);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(102, 39));
    }];
    [decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    decorIv.clipsToBounds = YES;
    decorIv.image = decorImage;
    decorIv.userInteractionEnabled = YES;
    
    UILabel *accLab = [[UILabel alloc]init];
    [self addSubview:accLab];
    accLab.text = @"欢迎来到币友";
    accLab.textAlignment = NSTextAlignmentCenter;
    accLab.textColor = HEXCOLOR(0x8c96a5);
    accLab.font = kFontSize(16);
    [accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(decorIv.mas_bottom).offset(10);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(102, 17));
    }];
    [self layoutAccountPublic];
}

-(void)layoutAccountPublic{
    _rightTfs = [NSMutableArray array];
    _lines = [NSMutableArray array];
    _tipLabs = [NSMutableArray array];
    _sub_views = [NSMutableArray array];
    _caveatImArrary = [NSMutableArray array];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = NO;
    scrollView.userInteractionEnabled = YES;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(180, 38, 255, 38));//255-2*（34-12）
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
        [_sub_views addObject:sub_view];
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        if(i==0){
            tf.keyboardType = UIKeyboardTypeNumberPad;
        }
        [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
        tf.textAlignment = NSTextAlignmentLeft;
//        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.textColor = HEXCOLOR(0x333333);
        tf.font = kFontSize(15);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.trailing.equalTo(sub_view).offset(-60);
            make.top.equalTo(sub_view).offset(20);
            make.bottom.equalTo(sub_view).offset(-10);
        }];
        UIImageView *itemIM = [UIImageView new];
        [sub_view addSubview:itemIM];
        itemIM.hidden = YES;
        itemIM.image = kIMG(@"invalidNamexiRan");
        [itemIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tf.mas_right).offset(6);
            make.top.mas_equalTo(sub_view.mas_top).offset(33);
            make.width.height.mas_equalTo(16);
        }];
        [_caveatImArrary addObject:itemIM];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [_lines addObject:line1];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xdddddd);
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(65);
            make.height.equalTo(@1);
        }];
        
        UILabel* tipLab = [[UILabel alloc]init];
        tipLab.textAlignment = NSTextAlignmentLeft;
        tipLab.textColor = [UIColor redColor];
        tipLab.font = kFontSize(11);
        [_tipLabs addObject:tipLab];
        [sub_view addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(75);
            make.height.equalTo(@11);
        }];
        [containView addSubview:sub_view];
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(containView);
            make.height.mas_equalTo(@(72));//*i
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).offset(12);//下个顶对上个底的间距=上个顶对整个视图顶的间距
            }else{
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
            }
        }];
        lastView = sub_view;
        
    }
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.tag = EnumActionTag0;
    _loginBtn.titleLabel.font = kFontSize(16);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 25;
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _loginBtn.multipleTouchEnabled = YES;
    [self addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(YBSystemTool.isIphoneX?-30:-15);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(@48);
        make.width.mas_equalTo(@118);
    }];
    
    _forgetPWBtn = [UIButton new];
    _forgetPWBtn.tag = EnumActionTag1;
    _forgetPWBtn.titleLabel.font = kFontSize(15);
    [_forgetPWBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPWBtn setTitleColor:HEXCOLOR(0x8c96a5) forState:UIControlStateNormal];
    [_forgetPWBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_forgetPWBtn];
    [_forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(350);
        make.right.mas_equalTo(self).offset(-35);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(@36);
    }];
    
    UIView *forgetPWlin = [UIView new];
    [_forgetPWBtn addSubview:forgetPWlin];
    forgetPWlin.backgroundColor = HEXCOLOR(0x979797);
    [forgetPWlin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1);
    }];
    
    
    _toRegisteredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toRegisteredBtn.adjustsImageWhenHighlighted = NO;
    [_toRegisteredBtn addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_toRegisteredBtn];
    [_toRegisteredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(350);
        make.left.mas_equalTo(4);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(@36);
    }];
    
    _onlineCustomerServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _onlineCustomerServiceBtn.tag = EnumActionTag2;
    _onlineCustomerServiceBtn.adjustsImageWhenHighlighted = NO;
    _onlineCustomerServiceBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [_onlineCustomerServiceBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_onlineCustomerServiceBtn];
    
    [_onlineCustomerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(YBSystemTool.isIphoneX?-45:-25);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(@48);
        make.width.mas_equalTo(@130);
    }];
    UIView* v0 = _sub_views[0];
    UITextField* rtf0 = _rightTfs[0];
    UIButton *eraseBtn = [[UIButton alloc] init];
    [eraseBtn setImage:kIMG(@"icon_erase") forState:UIControlStateNormal];
    [eraseBtn addTarget:self action:@selector(eraseRtf0Action) forControlEvents:UIControlEventTouchUpInside];
    [v0 addSubview:eraseBtn];
    [eraseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v0.mas_right).offset(-8);
        make.centerY.equalTo(rtf0);
        make.width.height.equalTo(@19);
        //            make.width.equalTo(@(MAINSCREEN_WIDTH));
    }];
    UIView* v1 = _sub_views[1];
    UITextField* rtf1 = _rightTfs[1];
    _eyeStatusBtn = [[UIButton alloc] init];
    [_eyeStatusBtn setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
    [_eyeStatusBtn addTarget:self action:@selector(eyeRtf1Action:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:_eyeStatusBtn];
    [_eyeStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(v1.mas_right).offset(-5);
        make.centerY.equalTo(rtf1);
        make.width.equalTo(@25);
        make.height.equalTo(@21);
    }]; 
    [self richElementsInViewWithModel];
    
    rtf0.text = @"13399990002";
    rtf1.text = @"Bub123456";
}

-(void)eraseRtf0Action{
    UITextField* rtf0 = _rightTfs[0];
    rtf0.text = @"";
}

-(void)eyeRtf1Action:(UIButton*)sender{
    UITextField* rtf1 = _rightTfs[1];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_eyeStatusBtn setImage:kIMG(@"icon_eyeopen") forState:UIControlStateNormal];
        [_eyeStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@14);
        }];
        rtf1.secureTextEntry = NO;
    }else{
        [_eyeStatusBtn setImage:kIMG(@"icon_eyeclose") forState:UIControlStateNormal];
        [_eyeStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@21);
        }];
        rtf1.secureTextEntry = YES;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     UITextField* rtf1 = _rightTfs[1];
    NSString * textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == rtf1 && textField.isSecureTextEntry ) {
        textField.text = textfieldContent;
        return NO;
    }
    return YES;
}

- (void)richElementsInViewWithModel{
    UITextField* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"请输入手机号码";
    UITextField* rtf1 = _rightTfs[1];
    rtf1.secureTextEntry = YES;
    rtf1.placeholder = @"请输入密码";
    
    [_toRegisteredBtn setAttributedTitle:[NSString attributedStringWithString:@"现在加入?  " stringColor:HEXCOLOR(0x8c96a5) stringFont:kFontSize(15) subString:@"注册" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
    [_onlineCustomerServiceBtn setAttributedTitle:[NSString attributedStringWithString:@"如有问题 " stringColor:HEXCOLOR(0x8c96a5) stringFont:kFontSize(15) subString:@"联系客服" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
}


#pragma mark -TextFieldDelegate
-(void)textField1TextChange:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    UIImageView *im0 = _caveatImArrary[0];
    UIImageView *im1 = _caveatImArrary[1];
    if (textField == rtf0) {
        line0.backgroundColor = HEXCOLOR(0x4c7fff);
          line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab0.text = @"";
         im0.hidden = YES;
    }else if (textField == rtf1){
        line1.backgroundColor = HEXCOLOR(0x4c7fff);
        line0.backgroundColor = HEXCOLOR(0xe8e9ed);
        tipLab1.text = @"";
        im1.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [self returnLoginfrime:textField WithBool:NO];
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    UILabel* tipLab0 = _tipLabs[0];
    UILabel* tipLab1 = _tipLabs[1];
    UIImageView *im0 = _caveatImArrary[0];
    UIImageView *im1 = _caveatImArrary[1];
    if (textField == rtf0) {
        if (rtf0.text == nil || rtf0.text.length < 0.5 ) {
             line0.backgroundColor = [UIColor redColor];
             tipLab0.text =@"输入的手机号不能为空哦";
             im0.hidden = NO;
            return;
        }
        if (rtf0.text.length<5) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text = @"*您输入的手机号码过短，至少5位数哦";
            im0.hidden = NO;
            return;
        }
        if (rtf0.text.length>20) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text =  @"*您输入的手机号码过长，最长不超过20位哦";
            im0.hidden = NO;
            return;
        }
        if (![NSString judgeiphoneNumberInt:rtf0.text]) {
            line0.backgroundColor = [UIColor redColor];
            tipLab0.text =  @"*输入手机号码必须是整数哦";
            im0.hidden = NO;
            return;
        }
        
    }else if (textField == rtf1){
        if (rtf1.text == nil || rtf1.text.length < 0.5 ) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text =@"输入的密码不能为空";
            im1.hidden = NO;
            return;
        }
        if (rtf1.text.length<8) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*您输入的密码过短，至少8位数哦";
            im1.hidden = NO;
            return;
        }
        if (rtf1.text.length>16) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*您输入的密码过长，最长不超过16位哦";
             im1.hidden = NO;
            return;
        }
        if (![NSString isContainAllCharType:rtf1.text]) {
            line1.backgroundColor = [UIColor redColor];
            tipLab1.text = @"*请重新输入密码：必须要包含大写及小写字母与数字";
             im1.hidden = NO;
            return;
        }
    }
}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    [self endEditing:YES];
    switch (type) {
        case EnumActionTag0: // 登录
        {
            [self toLogin];
        } break;
        case EnumActionTag1:
            if (self.block) {
                self.block(loginforgetPwd, nil);
            }break;
        case EnumActionTag2:
            if (self.block) {
                self.block(loginToService, nil);
            }break;
        default:
            break;
    }
}

-(void)registerEvent{
    if (self.block) {
        self.block(loginRegister, nil);
    }
}

-(void)toLogin{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    
    if (rtf0.text == nil || rtf0.text.length < 0.5 ) {
        [YKToastView showToastText:@"输入的手机号不能为空哦"];
        return;
    }
    if (rtf0.text.length<5) {
        [YKToastView showToastText:@"输入的手机号过短，至少5位数哦"];
        return;
    }
    if (rtf0.text.length>20) {
        [YKToastView showToastText:@"输入的手机号过长，最长不超过20位哦"];
        return;
    }
    if (![NSString judgeiphoneNumberInt:rtf0.text]) {
        [YKToastView showToastText:@"输入手机号码必须是整数哦"];
        return;
    }
    if (rtf1.text == nil || rtf1.text.length < 0.5 ) {
        [YKToastView showToastText:@"输入的密码不能为空哦"];
        return;
    }
    if (rtf1.text.length<8) {
        [YKToastView showToastText:@"输入的密码过短，至少8位数哦"];
        return;
    }
    if (rtf1.text.length>16) {
        [YKToastView showToastText:@"输入的密码过长，最长不超过16位哦"];
        return;
    }
    if (![NSString isContainAllCharType:rtf1.text]) {
        [YKToastView showToastText:@"请重新输入密码：必须要包含大写及小写字母与数字"];
        return;
    }
    
    if (self.block) {
        NSArray *ar = @[rtf0.text,rtf1.text];
        self.block(loginToLogin, ar);
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    UIView* line0 = _lines[0];
    UIView* line1 = _lines[1];
    if (textField == rtf0) {
        line0.backgroundColor = HEXCOLOR(0x4c7fff);
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
    }else if (textField == rtf1){
        line1.backgroundColor = HEXCOLOR(0x4c7fff);
        line0.backgroundColor = HEXCOLOR(0xe8e9ed);
    }
}

#pragma mark ---- 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self->_loginBtn.mj_y = MAINSCREEN_HEIGHT-self->_loginBtn.mj_h-kbHeight-15*SCALING_RATIO;
    }];
}

#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    [UIView animateWithDuration:0.2 animations:^{
        self->_loginBtn.frame = CGRectMake(MAINSCREEN_WIDTH-148, self.bounds.size.height - (YBSystemTool.isIphoneX?83:63), 118, 48);
    }];
}

@end
