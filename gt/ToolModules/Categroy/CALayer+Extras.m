//
//  CALayer+Extras.m
//  gt
//
//  Created by GT on 2019/1/19.
//  Copyright © 2019 GT. All rights reserved.
//

#import "CALayer+Extras.h"

@implementation CALayer (Extras)
- (void)setBorderColorWithUIColor:(UIColor *)borderColorWithUIColor {
    
    self.borderColor = borderColorWithUIColor.CGColor;
    
}
@end
