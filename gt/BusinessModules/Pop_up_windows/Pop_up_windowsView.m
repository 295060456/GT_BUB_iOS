//
//  Pop_up_windowsView.m
//  gt
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Pop_up_windowsView.h"

@interface Pop_up_windowsView ()

@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIImageView *contentView;

@end

@implementation Pop_up_windowsView

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self initView];
    }
    
    return self;
}

-(void)initView{
    
    self.backgroundColor = COLOR_RGB(0, 0, 0, 0.7);

    [self content];
}

-(void)content{
    
    _contentView = UIImageView.new;
    _contentView.image = kIMG(@"content");
    [NSObject cornerCutToCircleWithView:_contentView AndCornerRadius:8];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(291, 387));
    }];
    
    _closeBtn = UIButton.new;
    [_closeBtn setBackgroundImage:kIMG(@"invalidName") forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(self.contentView.mas_bottom).offset(39);
        make.centerX.equalTo(self);
    }];
}

-(void)close:(UIButton *)sender{
    
    [self removeFromSuperview];
}



@end
