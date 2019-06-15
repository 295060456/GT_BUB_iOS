//
//  CerSuccessView.m
//  OTC
//
//  Created by 王标 on 2018/12/15.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "CerSuccessView.h"

@implementation CerSuccessView
- (IBAction)bottomUserClick:(id)sender {
    [YKToastView showToastText:@"暂未开放"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"CerSuccessView" owner:self options:nil] lastObject];
    if (self)
    {
        self.frame = frame;
    }
    return self;
    
}

@end
