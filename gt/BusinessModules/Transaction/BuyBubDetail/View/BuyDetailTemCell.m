//
//  BuyDetailTemCell.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyDetailTemCell.h"

@interface BuyDetailTemCell ()
@property (nonatomic, strong) UILabel  *la1;
@property (nonatomic, strong) UILabel  *la2;
@property (nonatomic, strong) UIButton *copBut;
@end

@implementation BuyDetailTemCell

+(instancetype)cellWith:(UITableView*)tabelView{
    BuyDetailTemCell *cell = (BuyDetailTemCell *)[tabelView dequeueReusableCellWithIdentifier:@"BuyDetailTemCell"];
    if (!cell) {
        cell = [[BuyDetailTemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BuyDetailTemCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.la1 = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 0, 100*SCALING_RATIO, 28*SCALING_RATIO)];
        self.la1.textColor = HEXCOLOR(0x9a9a9a);
        self.la1.font = kFontSize(13*SCALING_RATIO);
        [self.contentView addSubview:self.la1];
        
        self.la2 = [[UILabel alloc] initWithFrame:CGRectMake(125*SCALING_RATIO, 0, MAINSCREEN_WIDTH - 140*SCALING_RATIO, 28*SCALING_RATIO)];
        self.la2.textColor = HEXCOLOR(0x333333);
        self.la2.textAlignment = NSTextAlignmentRight;
        self.la2.font = kFontSize(13*SCALING_RATIO);
        [self.contentView addSubview:self.la2];
        self.copBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.copBut setImage:kIMG(@"copy_blue_rightup") forState:(UIControlStateNormal)];
        self.copBut.frame = CGRectMake(MAINSCREEN_WIDTH - 15*SCALING_RATIO - 13*SCALING_RATIO, 7*SCALING_RATIO, 13*SCALING_RATIO, 15*SCALING_RATIO);
        [self.contentView addSubview:self.copBut];
        self.copBut.hidden = YES;
        kWeakSelf(self);
        [[self.copBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = weakself.la2.text;
            if (pasteboard.string.length > 0) {
                [YKToastView showToastText:[NSString stringWithFormat:@"“%@” 复制成功",weakself.la2.text]];
            }
        }];
    }
    return self;
}

-(void)cellShowCopyButnWithDic:(NSDictionary*)myDic{ // 显示按钮
    
    NSArray *kAr = myDic.allKeys;
    NSArray *vAr = myDic.allValues;
    self.copBut.hidden = NO;
    self.la2.frame = CGRectMake(125*SCALING_RATIO, 0, MAINSCREEN_WIDTH - 140*SCALING_RATIO - 18*SCALING_RATIO, 28*SCALING_RATIO);
    self.la1.text = kAr[0];
    self.la2.text = vAr[0];
    
}

-(void)cellDataWithDic:(NSDictionary*)myDic{ // 不显示按钮
    
    NSArray *kAr = myDic.allKeys;
    NSArray *vAr = myDic.allValues;
    NSString *s = kAr[0];
    if (s && [s isEqualToString:@"订单号"]) {
        self.copBut.hidden = NO;
        self.la2.frame = CGRectMake(125*SCALING_RATIO, 0, MAINSCREEN_WIDTH - 140*SCALING_RATIO - 18*SCALING_RATIO, 28*SCALING_RATIO);
    }else{
        self.copBut.hidden = YES;
        self.la2.frame = CGRectMake(125*SCALING_RATIO, 0, MAINSCREEN_WIDTH - 140*SCALING_RATIO, 28*SCALING_RATIO);
    }
    self.la1.text = s;
    self.la2.text = vAr[0];
    
}







@end
