//
//  CodeInputView.m
//  JDZBorrower
//
//  Created by WangXueqi on 2018/4/20.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "CodeInputView.h"
#import "CALayer+Category.h"

#define K_W 44 * SCALING_RATIO
#define K_Screen_Width               [UIScreen mainScreen].bounds.size.width
#define K_Screen_Height              [UIScreen mainScreen].bounds.size.height

@interface CodeInputView()<UITextViewDelegate>
//@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * lines;
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;
@end
@implementation CodeInputView

- (instancetype)initWithFrame:(CGRect)frame inputType:(NSInteger)inputNum selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.CodeBlock = CodeBlock;
        self.inputNum = inputNum;
        [self initSubviews];
        UIView *v = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:v];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [v addGestureRecognizer:tap];
    }
    return self;
}

- (void)initSubviews {
    CGFloat W = CGRectGetWidth(self.frame);
    //    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat Padd = 30*SCALING_RATIO;
    [self addSubview:self.textView];
    self.textView.frame = CGRectMake(Padd, 0, W-Padd*2, K_W);
    self.textView.tag = 171342;
    //默认编辑第一个.
    [self beginEdit];
    for (int i = 0; i < _inputNum; i ++) {
        UIView *subView = [UIView new];
        subView.frame = CGRectMake(Padd+(K_W+10*SCALING_RATIO)*i, 0, K_W, K_W);
        subView.userInteractionEnabled = NO;
        
        //        [subView addGestureRecognizer:tap];
        subView.layer.borderWidth = 1.0;
        subView.layer.cornerRadius = 8*SCALING_RATIO;
        if (i==0) {
            subView.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        }else{
            subView.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        }
        [self addSubview:subView];
        UILabel *label = [[UILabel alloc]init];
        label.userInteractionEnabled = YES;
        label.frame = CGRectMake(0, 0, K_W, K_W);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x333333);
        label.font = [UIFont systemFontOfSize:24*SCALING_RATIO];
        [subView addSubview:label];
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(K_W / 2, 15*SCALING_RATIO, 2*SCALING_RATIO, K_W - 30*SCALING_RATIO)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  HEXCOLOR(0x8c96a5).CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
        //把光标对象和label对象装进数组
        [self.lines addObject:line];
        [self.labels addObject:label];
    }
    [self performSelector:@selector(showLine) withObject:nil afterDelay:.2];
}
-(void)showLine{
    [self changeViewLayerIndex:0 linesHidden:NO];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *verStr = textView.text;
    if (verStr.length > _inputNum) {
        textView.text = [textView.text substringToIndex:_inputNum];
    }
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
        [self endEdit];
    }
    if (self.CodeBlock) {
        self.CodeBlock(textView.text);
    }
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        NSLog(@"-- %@",bgLabel.text);
        UIView *v = bgLabel.superview;
        v.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        if (i == verStr.length) {
            v.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        }
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}
//设置光标显示隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    CAShapeLayer *line = self.lines[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}
//开始编辑
- (void)beginEdit{
    [self.textView becomeFirstResponder];
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
}
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
//对象初始化
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textView;
}
-(void)removeTextString{
    [self.textView becomeFirstResponder];
    [self changeViewLayerIndex:0 linesHidden: NO];
    UITextView *teX = [self viewWithTag:171342];
    teX.text = @"";
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        bgLabel.text = @"";
        UIView *v = bgLabel.superview;
        if (i==0) {
            v.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        }else{
            v.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        }
    }
}
-(void)tapAction{
    [self.textView becomeFirstResponder];
}

@end

