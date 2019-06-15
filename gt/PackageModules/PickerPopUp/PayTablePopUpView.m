//
//  TablePopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "PayTablePopUpView.h"
#import "ExchangeDetailCell.h"
#import "LoginModel.h"
#define XHHTuanNumViewHight 430
@interface PayTablePopUpView()<UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIButton *saftBtn;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, strong) NSMutableArray* lines;
@property (nonatomic, strong) NSMutableArray* rightTfs;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isShowGoogleCodeField;

@property (nonatomic,strong)UIButton * headBtn;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger  selectedRow;
@property (nonatomic,strong)NSArray * dataSource;
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) ActionBlock successBlock;

@property (nonatomic, strong) NSMutableArray*sub_views;
@property (nonatomic, strong) UIButton *eyeStatusBtn;
@end

@implementation PayTablePopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupContent];
        
    }
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
//    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight+[YBFrameTool tabBarHeight];
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        // zhong按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saftBtn = saftBtn;
        saftBtn.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [saftBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_contentView addSubview:saftBtn];
//        [saftBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAdsAndRuleButtonClickItem:)]];
        
        // zuo上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(17);
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];//
        //        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        [_contentView addSubview:closeBtn];
        
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        _isShowGoogleCodeField = ([userInfoModel.userinfo.safeverifyswitch boolValue]==YES)?YES:NO;
        [self layoutTable];
        [self layoutAccountPublic];
        
        WS(weakSelf);
        [_contentView bottomSingleButtonInSuperView:_contentView WithButtionTitles:@"立即付款" withBottomMargin:76  isHidenLine:YES leftButtonEvent:^(id data) {
            UIButton* btn = (UIButton*)data;
            [btn setTitle:@"付款" forState:UIControlStateNormal];
            weakSelf.scrollView.hidden = NO;
            weakSelf.tableView.hidden = YES;
            [weakSelf.contentView bottomSingleButtonInSuperView:weakSelf.contentView WithButtionTitles:@"付款" withBottomMargin:76  isHidenLine:YES leftButtonEvent:^(id data) {
                [weakSelf.saftBtn setTitle:@"输入支付密码" forState:UIControlStateNormal];
                [weakSelf postAdsAndRuleButtonClickItem];
            }];
            
        }];
    }
}

-(void)layoutAccountPublic{
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    _lines = [NSMutableArray array];
    _sub_views = [NSMutableArray array];
    
    UIScrollView *scrollView = [UIScrollView new];
    _scrollView = scrollView;
    scrollView.hidden = YES;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.equalTo(self.contentView).offset(30);
        //        make.trailing.equalTo(self.contentView).offset(-30);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        //        make.top.equalTo(self.contentView).offset(47);
        //        make.height.equalTo(@178);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(self.isShowGoogleCodeField? 167.5:167.5+30, 30, 146, 30));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    //    return;
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x232630);
        leftLab.font = kFontSize(17);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(12);
            make.bottom.equalTo(sub_view).offset(-37);
        }];
        
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        //        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentLeft;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);
        
        //        tf.zw_placeHolderColor = HEXCOLOR(0xb2b2b2);
        tf.secureTextEntry = YES;
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(46);
            make.bottom.equalTo(sub_view).offset(-6);
            make.width.equalTo(@(MAINSCREEN_WIDTH));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        [_lines addObject:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(73);
            make.height.equalTo(@.5);
        }];
        [_sub_views addObject:sub_view];
        [containView addSubview:sub_view];
        
        //        sub_view.layer.cornerRadius = 4;
        //        sub_view.layer.borderWidth = 1;
        //        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(89));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(-12);//下个顶对上个底的间距=上个顶对整个视图顶的间距
                //                //上1个
                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
                
                
            }
            
        }];
        //最后一个
        //        sub_view.backgroundColor = kWhiteColor;
        //        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
    
    UITextField* rtf1 = _rightTfs[1];
    UIView* subView1 = _sub_views[1];
    _eyeStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eyeStatusBtn setTitle:@"粘贴" forState:UIControlStateNormal];
    [_eyeStatusBtn addTarget:self action:@selector(eyeRtf1Action:) forControlEvents:UIControlEventTouchUpInside];
    _eyeStatusBtn.titleLabel.font = kFontSize(15);
    [_eyeStatusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [subView1 addSubview:_eyeStatusBtn];
    [_eyeStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(subView1.mas_right).offset(-5);
        make.centerY.equalTo(rtf1);
        make.width.equalTo(@50);
        make.height.equalTo(@21);
    }];
    
    [self richElementsInViewWithModel];
    
}

-(void)eyeRtf1Action:(UIButton*)sender{
    UITextView* rtf1 = _rightTfs[1];
    if (![NSString isEmpty:[[UIPasteboard generalPasteboard]string]]) {
        rtf1.text = [NSString stringWithFormat:@"%@",[[UIPasteboard generalPasteboard]string]];
    }
}

- (void)richElementsInViewWithModel{
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"支付密码";
    
    
    UITextField* rtf0 = _rightTfs[0];
    rtf0.placeholder = @"请输入支付密码";
    //    [self textViewDidBeginEditing:rtf0];
    
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"谷歌验证码";
    
    UIImageView* line1 = _lines[1];
    
    UITextField* rtf1 = _rightTfs[1];
    rtf1.placeholder = @"请输入谷歌验证码";
    
    if (_isShowGoogleCodeField) {
        lab1.hidden = NO;
        line1.hidden = NO;
        rtf1.hidden = NO;
        _eyeStatusBtn.hidden = NO;
    }else{
        lab1.hidden = YES;
        line1.hidden = YES;
        rtf1.hidden = YES;
        _eyeStatusBtn.hidden = YES;
    }
    
}


-(void)layoutTable{
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBtn.titleLabel.numberOfLines = 0;
    self.headBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:self.headBtn];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.line1.mas_bottom).offset(38);
//        make.bottom.equalTo(self.contentView).offset(-48);
                make.height.equalTo(@(81));
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
//    self.tableView.layer.masksToBounds = YES;
//    self.tableView.layer.cornerRadius = 4;
    self.tableView.backgroundColor = kWhiteColor;
    
    [self.contentView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
                make.top.equalTo(self.headBtn.mas_bottom).offset(38);
//        make.bottom.equalTo(self.contentView).offset(-48);
        make.height.equalTo(@(91));
    }];
}

- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}

- (void)richElementsInViewWithModel:(NSArray*)model WithAmount:(NSString*)amount{
    [self.headBtn setAttributedTitle:[NSString attributedReverseStringWithString:[NSString stringWithFormat:@"\n   需消耗 %@ BUB",amount] stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(14) subString:[NSString stringWithFormat:@"￥ %@",amount] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(20) numInSubColor:HEXCOLOR(0x333333) numInSubFont:kFontSize(40)] forState:UIControlStateNormal];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataSource = model ;
    [self.tableView reloadData];
}
- (void)cancelAction{
    
    [self disMissView];
    
    [[YBNaviagtionViewController rootNavigationController] popToRootViewControllerAnimated:YES];
}
- (void)postAdsAndRuleButtonClickItem{
    
    UITextField* rtf0 = _rightTfs[0];
    UITextField* rtf1 = _rightTfs[1];
    if (_isShowGoogleCodeField) {
        if ([NSString isEmpty:rtf0.text]
            &&[NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入支付密码和谷歌验证码"];
            return;
        }
        else if (![NSString isEmpty:rtf0.text]
                 &&[NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入谷歌验证码"];
            return;
        }
        else if ([NSString isEmpty:rtf0.text]
                 &&![NSString isEmpty:rtf1.text]) {
            [YKToastView showToastText:@"请输入支付密码"];
            return;
        }
        
        if (self.block) {
            
            self.block(@{rtf0.text:rtf1.text});
        }
    }else{
        if ([NSString isEmpty:rtf0.text]) {
            [YKToastView showToastText:@"请输入支付密码"];
            return;
        }
        
        if (self.block) {
            
            self.block(@{rtf0.text:@""});
        }
    }
//    [self disMissView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
- (void)showInApplicationKeyWindow{
    [self showInView:[UIApplication sharedApplication].keyWindow];
    
    //    [popupView showInView:self.view];
    //
    //    [popupView showInView:[UIApplication sharedApplication].keyWindow];
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, _contentViewHeigth)];
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth),MAINSCREEN_WIDTH,weakSelf.contentViewHeigth)];
        
    } completion:nil];
}

- (void)showSuccessView:(ActionBlock)successBlock{
    self.successBlock = successBlock;
    [self.saftBtn setTitle:@"支付成功" forState:UIControlStateNormal];
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
         make.top.equalTo(self.line1.mas_bottom).offset(38);
        make.bottom.equalTo(self.contentView);
        
    }];
    UILabel* lab = [UILabel new];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = HEXCOLOR(0x184dd0);
    lab.font = kFontSize(30);
    lab.text = @"支付成功！";
    [whiteView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        
        make.top.equalTo(whiteView).offset(120);
        make.height.equalTo(@42);
        
    }];
    
    _timeLab = [[UILabel alloc]init];
    _timeLab.font = kFontSize(14);
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = HEXCOLOR(0x9b9b9b);
    [whiteView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        
        make.top.equalTo(lab.mas_bottom).offset(47.6);
        make.height.equalTo(@20);
        
    }];
    [self startTimeCount:@"3"];
    
    UILabel* textLab = [[UILabel alloc]init];
    textLab.font = kFontSize(14);
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = HEXCOLOR(0x9b9b9b);
    [whiteView addSubview:textLab];
    textLab.text = @"正在返回 我的资产 页面";
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        
        make.top.equalTo(self.timeLab.mas_bottom).offset(4);
        make.height.equalTo(@20);
        
    }];
    
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
    //    self.timeLab.enabled = false;//grey
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    NSString *title = [NSString stringWithFormat:@"%ld s",(long)self.timeCount];
    self.timeLab.text = title;
//    self.timeLab.text = [NSString timeWithSecond:self.timeCount];
    self.timeLab.textColor = HEXCOLOR(0x9b9b9b);
    //    [self.timeBtn setTitle:[NSString timeWithSecond:self.timeCount] forState:UIControlStateNormal];
    //    [self.timeBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
    if(self.timeCount < 0)
    {
        [self distoryTimer];
        //        self.timeLab.enabled = false;//grey
        self.timeLab.text = @"0 s";
        //        [self.timeBtn setTitle:@"已停止" forState:UIControlStateNormal];
        //        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        
        if (self.successBlock) {
            self.successBlock(@(EnumActionTag3));
        }
        
    }
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [self distoryTimer];
}
//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WS(weakSelf);
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.alpha = 0.0;
                         [weakSelf.contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                     }];
    
}
#pragma mark UITableView DataSource Method 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* model = _dataSource[indexPath.row];
    return [ExchangeDetailCell cellHeightWithModel:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExchangeDetailCell *cell = [ExchangeDetailCell cellWith:tableView];
    NSDictionary* model = _dataSource[indexPath.row];
    [cell richElementsInCellWithModel:model withExchangeType:ExchangeTypeAll];
    
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int offset = self.contentView.frame.origin.y -(YBSystemTool.isIphoneX? 80: 33.0);//216iPhone键盘高
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -offset);
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}
@end

