//
//  ChatBaseCell.m
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ChatBaseCell.h"

@implementation ChatBaseCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = COLOR_RGB(250, 250, 250 ,1);
        self.backgroundColor = [UIColor whiteColor];
//        self.contentView.backgroundColor = COLOR_RGB(250, 250, 250 ,1);
        self.contentView.backgroundColor = COLOR_RGB(242, 241, 246, 1);

        [self initSSChatCellUserInterface];
    }
    return self;
}



-(void)initSSChatCellUserInterface{
    
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mHeaderImgBtn.backgroundColor =  [UIColor brownColor];
    _mHeaderImgBtn.tag = 10;
    _mHeaderImgBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:_mHeaderImgBtn];
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //创建时间
    _mMessageTimeLab = [UILabel new];
    _mMessageTimeLab.bounds = CGRectMake(0, 0, SSChatTimeWidth, SSChatTimeHeight);
    _mMessageTimeLab.top = SSChatTimeTop;
    _mMessageTimeLab.centerX = SCREEN_Width*0.5;
    [self.contentView addSubview:_mMessageTimeLab];
    _mMessageTimeLab.textAlignment = NSTextAlignmentCenter;
    _mMessageTimeLab.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _mMessageTimeLab.textColor = [UIColor whiteColor];
    _mMessageTimeLab.backgroundColor = COLOR_RGB(220, 220, 220 ,1);
    _mMessageTimeLab.clipsToBounds = YES;
    _mMessageTimeLab.layer.cornerRadius = 3;
    
    
    //背景按钮
    _mBackImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mBackImgButton.backgroundColor = COLOR_RGB(250, 250, 250 ,0.4);
    _mBackImgButton.tag = 50;
    [self.contentView addSubview:_mBackImgButton];
    [_mBackImgButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)setLayout:(ChatMessageLayout *)layout{
    _layout = layout;
    
    _mMessageTimeLab.hidden = !layout.message.showTime;
    _mMessageTimeLab.text = layout.message.messageTime;
    [_mMessageTimeLab sizeToFit];
    _mMessageTimeLab.height = SSChatTimeHeight;
    _mMessageTimeLab.width += 20;
    _mMessageTimeLab.centerX = SCREEN_Width*0.5;
    _mMessageTimeLab.top = SSChatTimeTop;
    
    
    self.mHeaderImgBtn.frame = layout.headerImgRect;
    [self.mHeaderImgBtn setBackgroundImage:[UIImage imageNamed:@"touxaing2"] forState:UIControlStateNormal];
    self.mHeaderImgBtn.layer.cornerRadius = self.mHeaderImgBtn.height*0.5;
    if(_layout.message.messageFrom == ChatMessageFromOther){
        [self.mHeaderImgBtn setBackgroundImage:[UIImage imageNamed:@"touxiang1"] forState:UIControlStateNormal];
    }
    
}


//消息按钮
-(void)buttonPressed:(UIButton *)sender{
    
    
    
    
}

@end
