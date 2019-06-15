//
//  TablePopUpView.h
//  gtp
//
//  Created by Aalto on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayTablePopUpView : UIView
- (void)richElementsInViewWithModel:(NSArray*)model WithAmount:(NSString*)amount;//:(id)paysDic
- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;
- (void)disMissView;
- (void)showSuccessView:(ActionBlock)successBlock;
@end

NS_ASSUME_NONNULL_END
