//
//  TablePopUpView.h
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerPopUpView : UIView
- (void)richElementsInViewWithModel:(NSArray*)model;//:(id)paysDic
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
