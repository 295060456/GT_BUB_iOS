//
//  ChatTextCell.m
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ChatTextCell.h"

@implementation ChatTextCell


-(void)initSSChatCellUserInterface{
    [super initSSChatCellUserInterface];
    
    self.mTextView = [UITextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.mBackImgButton addSubview:self.mTextView];
}

-(void)setLayout:(ChatMessageLayout *)layout{
    [super setLayout:layout];
    
    UIImage *image = [UIImage imageNamed:layout.message.backImgString];

    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.mBackImgButton.frame = layout.backImgButtonRect;
    
    if ([layout.message.backImgString isEqualToString:@"icon_qipao1"]) {
        //我
        self.mBackImgButton.backgroundColor = COLOR_RGB(76, 127, 255, 1);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mBackImgButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = self.mBackImgButton.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        self.mBackImgButton.layer.mask = maskLayer;
        
        self.mTextView.textColor = [UIColor whiteColor];
        [layout.message.attTextString addAttribute:NSForegroundColorAttributeName
         
                                             value:[UIColor whiteColor]
         
                                             range:NSMakeRange(0, layout.message.attTextString.length)];
        
    }else {
        //对方
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mBackImgButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.mBackImgButton.bounds;
        maskLayer.path = maskPath.CGPath;
        self.mBackImgButton.layer.mask = maskLayer;
        self.mBackImgButton.backgroundColor = [UIColor whiteColor];
    }
    
//    [self.mBackImgButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.mTextView.frame = self.layout.textLabRect;
//    self.mTextView.attributedText = layout.message.attTextString;

    self.mTextView.attributedText =layout.message.attTextString;
    
    
}

@end
