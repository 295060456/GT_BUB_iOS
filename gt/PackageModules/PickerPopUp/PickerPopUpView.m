//
//  TablePopUpView.m
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "PickerPopUpView.h"
#define XHHTuanNumViewHight 288//347 //283+64
@interface PickerPopUpView()<UIGestureRecognizerDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//遵循协议
@property (nonatomic,strong)UIPickerView * pickerView;
@property (nonatomic,strong)NSArray * letter;
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;
@end

@implementation PickerPopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
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
        
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(17);
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"确定" forState:UIControlStateNormal];//取消
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(30, 0, 90, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        [saftBtn setTitle:@"确定" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentView addSubview:saftBtn];
        [saftBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAdsAndRuleButtonClickItem:)]];
        saftBtn.hidden = YES;
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        [self layoutPicker];
        
    }
}

-(void)layoutPicker{
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.layer.masksToBounds = YES;
    self.pickerView.layer.cornerRadius = 4;
    self.pickerView.backgroundColor = HEXCOLOR(0xf2f1f6);//0xf2f1f6
    [self.contentView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
                make.top.equalTo(self.line1.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView).offset(8);
//        make.height.equalTo(@(240));
    }];
    
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)richElementsInViewWithModel:(NSArray*)model{
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.letter = model ;
}

- (void)postAdsAndRuleButtonClickItem:(UITapGestureRecognizer*)sender{
    
//    if (self.block) {
//        self.block(@(sender.view.tag));
//    }
    [self disMissView];
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

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.letter.count;//根据数组的元素个数返回几行数据
            break;
            //        case 1:
            //            result = self.number.count;
            //            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40.0f;
    
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  MAINSCREEN_WIDTH;
}
// 自定义指定列的每行的视图，即指定列的每行的视图行为一致

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *pickerLabel = [[UILabel alloc]init];
    pickerLabel.origin = CGPointMake(0, 0);
    pickerLabel.size = CGSizeMake(MAINSCREEN_WIDTH, 40);
    //    pickerLabel.adjustsFontSizeToFitWidth = YES;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.font = kFontSize(20);
    pickerLabel.textColor = HEXCOLOR(0x394368);
    //    pickerLabel.text = [_letter objectAtIndex:row];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    [view addSubview:pickerLabel];
    
    
    //    UILabel* pickerLabel = (UILabel*)view;
    //    if (!pickerLabel)
    //    {
    //        pickerLabel = [[UILabel alloc] init];
    //        pickerLabel.adjustsFontSizeToFitWidth = YES;
    //
    //        pickerLabel.textAlignment = NSTextAlignmentLeft;
    //        pickerLabel.textColor =HEXCOLOR(0x394368);
    //        pickerLabel.font = kFontSize(15);
    //    }
    //
    //    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    
    //隐藏上下直线
    
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    
    return view;
    
}
//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
        {
            NSDictionary* dic = self.letter[row];
            title = dic.allValues[0];
        }
            break;
            //        case 1:
            //            title = self.number[row];
            //            break;
        default:
            break;
    }
    
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"data[%li]--Select%@",(long)row,[_letter objectAtIndex:row]);
//    [YKToastView showToastText:[NSString stringWithFormat:@"%@",[_letter objectAtIndex:row]]];
    if (self.block) {
//        NSDictionary* dic = self.letter[row];
        self.block(self.letter[row]);
    }
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic = [_letter objectAtIndex:row];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:dic.allValues[0]];
    
    [attributedString addAttributes:@{NSFontAttributeName:kFontSize(15), NSForegroundColorAttributeName:HEXCOLOR(0x394368)} range:NSMakeRange(0, [attributedString  length])];
    return attributedString;
}
@end

