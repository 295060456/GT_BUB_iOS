//
//  XcSafetySetView.m
//  gt
//
//  Created by XiaoCheng on 24/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcSafetySetView.h"
#import "DXRadianLayerView.h"

@interface XcSafetySetView()
@property (weak, nonatomic) IBOutlet UIImageView *img_szzfmm;
@property (weak, nonatomic) IBOutlet UIButton *btn_szzfmm;

@property (weak, nonatomic) IBOutlet UIImageView *img_bdskfs;
@property (weak, nonatomic) IBOutlet UIButton *btn_bdskfs;

@property (weak, nonatomic) IBOutlet UIImageView *img_wcsmrz;
@property (weak, nonatomic) IBOutlet UIButton *btn_wcsmrz;

@property (weak, nonatomic) IBOutlet UIImageView *img_wcgjrz;
@property (weak, nonatomic) IBOutlet UIButton *btn_wcgjrz;

@property (weak, nonatomic) IBOutlet DXRadianLayerView *radianView;

@property (nonatomic, strong) UIWindow *nWindow;
@end

@implementation XcSafetySetView

- (instancetype) initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, -80, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT+80);
    self = [super initWithFrame:frame];
    if (self) {
        self = GetXibObject(@"XcSafetySetView", 0);
        self.mj_h = frame.size.height;
        self.mj_w = frame.size.width;
        self.mj_x = frame.origin.x;
        self.mj_y = frame.origin.y;
        [self show];
    }
    return self;
}

- (IBAction)clickEvent:(UIButton *)sender {
    HideInWindowView(self);
}

- (void) setPayPwd:(BOOL)value :(NoResultBlock)block{
    self.img_szzfmm.hidden = !value;
    self.btn_szzfmm.hidden = value;
    @weakify(self)
    if (!value && block) {
        [[self.btn_szzfmm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block();
            @strongify(self)
            [self clickEvent:nil];
        }];
    }
}

- (void) setBindPayee:(BOOL)value :(NoResultBlock)block{
    self.img_bdskfs.hidden = !value;
    self.btn_bdskfs.hidden = value;
    @weakify(self)
    if (!value && block) {
        [[self.btn_bdskfs rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block();
            @strongify(self)
            [self clickEvent:nil];
        }];
    }
}

- (void) setAutonym:(BOOL)value :(NoResultBlock)block{
    self.img_wcsmrz.hidden = !value;
    self.btn_wcsmrz.hidden = value;
    @weakify(self)
    if (!value && block) {
        [[self.btn_wcsmrz rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block();
            @strongify(self)
            [self clickEvent:nil];
        }];
    }
}

- (void) setSeniorAutonym:(BOOL)value :(NoResultBlock)block{
    self.img_wcgjrz.hidden = !value;
    self.btn_wcgjrz.hidden = value;
    
    if (!value) {
        self.btn_wcgjrz.enabled = self.btn_wcsmrz.hidden;
    }
    @weakify(self)
    if (!value && block) {
        [[self.btn_wcgjrz rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block();
            @strongify(self)
            [self clickEvent:nil];
        }];
    }
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    @weakify(self)
    [[RACScheduler mainThreadScheduler]afterDelay:.01 schedule:^{
        @strongify(self)
        self.radianView.radian = 13.0f;
    }];
}


/**
 显示View
 */
- (void) show{
//    [[RACScheduler mainThreadScheduler]afterDelay:.5 schedule:^{
        self.nWindow = ShowInWindowView(self);
//    }];
}

@end
