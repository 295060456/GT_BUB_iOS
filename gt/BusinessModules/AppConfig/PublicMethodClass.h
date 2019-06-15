//
//  PublicMethodClass.h
//  gt
//
//  Created by XiaoCheng on 23/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#ifndef PublicMethodClass_h
#define PublicMethodClass_h

#define NEWWINDOWSTAGVALUE   1008611
/**
 处理字符串

 @param string 字符串
 @return 处理好的字符串
 */
NS_INLINE NSString* HandleStringNull(NSString *string){
    if (string && [string isKindOfClass:[NSString class]] && string.length>0) {
        return string;
    }else{
        return @"";
    }
}


/**
 处理字符串是否为空

 @param string 字符串
 @return YES-是，NO-不是
 */
NS_INLINE BOOL HandleStringIsNull(NSString *string){
    if (string && [string isKindOfClass:[NSString class]] && string.length>0) {
        return YES;
    }else{
        return NO;
    }
}


/**
 创建XIB

 @param xibName xib文件名
 @param index 索引
 @return xib对象
 */
NS_INLINE id GetXibObject(NSString *xibName, NSInteger index){
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] objectAtIndex:index];
}


/**
 创建UILabel

 @param frame 坐标
 @param text 内容
 @param font 字体
 @param textColor 字体颜色
 @param backgroundColor 背景颜色
 @param textAlinment 位置
 @param supView supView
 @return label
 */
NS_INLINE UILabel* CreateLabelWith(CGRect frame,
                                   NSString* text,
                                   UIFont* font,
                                   UIColor* textColor,
                                   UIColor* backgroundColor,
                                   NSTextAlignment textAlinment,
                                   UIView *supView)
{
    UILabel *label      = [[UILabel alloc] init];
    label.frame         = frame;
    label.text          = HandleStringNull(text);
    label.textAlignment = textAlinment;
    
    if (font) {
        label.font = font;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    
    
    if (supView) {
        [supView addSubview:label];
    }
    
    return label;
}


/**
 获取字符串高度

 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 字符串高度
 */
NS_INLINE CGFloat calculateStringHeightWithStr(NSString* str,
                                            UIFont* font,
                                            CGFloat width){
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return ceil(textRect.size.height);
}


/**
 获取字符串宽度

 @param str 字符串
 @param font 字体
 @return 字符串宽度
 */
NS_INLINE CGFloat calculateStringWidthWithStr(NSString* str,
                                               UIFont* font){
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return ceil(textRect.size.width);
}


NS_INLINE UIWindow * ShowInWindowView(UIView *view){
    UIWindow *nWindow   = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    nWindow.windowLevel = UIWindowLevelStatusBar + 100;
    nWindow.tag         = NEWWINDOWSTAGVALUE;
    [nWindow addSubview:view];
    [nWindow makeKeyAndVisible];
    return nWindow;
}

NS_INLINE void HideInWindowView(UIView *view){
    UIWindow *nWindow;
    for (UIWindow*w in [UIApplication sharedApplication].windows) {
        if ([w isKindOfClass:[UIWindow class]]) {
            if (w.tag == MAINWINDOWSTAGVALUE) {
                [w makeKeyAndVisible];
            }else if (w.tag == NEWWINDOWSTAGVALUE){
                nWindow = w;
            }
        }
    }
    view.window.windowLevel = UIWindowLevelNormal - 1;
    [view removeFromSuperview];
    if (nWindow) {
        [nWindow removeFromSuperview];
        nWindow = nil;
    }
}

NS_INLINE UIViewController* GetStoryboardObj(NSString *name){
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateInitialViewController];
}



#endif /* PublicMethodClass_h */
