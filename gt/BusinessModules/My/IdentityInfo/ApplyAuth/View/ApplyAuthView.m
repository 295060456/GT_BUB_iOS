//
//  CerSuccessView.m
//  OTC
//
//  Created by 王标 on 2018/12/15.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "ApplyAuthView.h"

@implementation ApplyAuthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ApplyAuthView" owner:self options:nil] lastObject];
    if (self)
    {
        self.frame = frame;
        
    }
    return self;
    
}

@end
