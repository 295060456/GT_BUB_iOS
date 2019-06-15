//
//  AccountPhoneTipsView.m
//  gt
//
//  Created by XiaoCheng on 08/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AccountPhoneTipsView.h"

@interface AccountPhoneTipsView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AccountPhoneTipsView

- (instancetype) initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self = GetXibObject(@"AccountPhoneTipsView", 0);
        self.mj_h = frame.size.height;
        self.mj_w = frame.size.width;
        self.mj_x = frame.origin.x;
        self.mj_y = frame.origin.y;
    }
    return self;
}

- (void) showFailed:(NoResultBlock)block
               close:(NoResultBlock) closeBlock{
    @weakify(self)
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        HideInWindowView(self);
        if (block)block();
    }];
    
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        HideInWindowView(self);
        if (closeBlock)closeBlock();
    }];
    self.window = ShowInWindowView(self);
}

- (void) showSucceed:(NoResultBlock)block{
    self.closeBtn.hidden    = YES;
    self.iconImg.image      = kIMG(@"xc_AP_img_1");
    self.title.text         = @"手机号修改成功！";
    self.content.text       = @"您的登录手机号已修改，请重新登录";
    [self.btn setTitle:@"我知道了" forState:UIControlStateNormal];
    @weakify(self)
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        HideInWindowView(self);
        if (block)block();
    }];
    self.window = ShowInWindowView(self);
}

@end
