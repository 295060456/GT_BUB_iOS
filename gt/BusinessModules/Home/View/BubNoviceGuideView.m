//
//  BubNoviceGuideView.m
//  gt
//
//  Created by XiaoCheng on 25/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BubNoviceGuideView.h"

@interface BubNoviceGuideView ()
@property (nonatomic, strong) UIImageView *ngImageView;
@property (nonatomic, strong) NSMutableArray *imageList1;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation BubNoviceGuideView

- (NSMutableArray *) imageList1{
    if (!_imageList1) {
        _imageList1 = [NSMutableArray array];
        [_imageList1 addObject:@"xc_BubNoviceGuideIMG_1"];
        [_imageList1 addObject:@"xc_BubNoviceGuideIMG_2"];
        [_imageList1 addObject:@"xc_BubNoviceGuideIMG_3"];
        [_imageList1 addObject:@"xc_BubNoviceGuideIMG_4"];
    }
    return _imageList1;
}

- (instancetype) initWithFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        self.backgroundColor = kClearColor;
        self.ngImageView = [[UIImageView alloc] initWithFrame:frame];
        self.ngImageView.backgroundColor = kRedColor;//kClearColor;
        self.ngImageView.userInteractionEnabled = YES;
        [self addSubview:self.ngImageView];
        @weakify(self)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            [self showNoviceGuideView];
        }];
        [self.ngImageView addGestureRecognizer:tap];
         self.window = ShowInWindowView(self);
    }
    return self;
}

- (void) showNoviceGuideView{
    if (self.imageList1.count>0 && self.index<self.imageList1.count) {
        self.ngImageView.image = kIMG(self.imageList1[self.index]);
        self.index++;
    }else{
        HideInWindowView(self);
    }
}

@end
