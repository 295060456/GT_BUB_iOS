//
//  CancelTipPopUpView.h
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CancelTipPopUpView : UIView

- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;

- (void)richElementsInViewWithModel:(nullable id)model;////????

@end

NS_ASSUME_NONNULL_END
