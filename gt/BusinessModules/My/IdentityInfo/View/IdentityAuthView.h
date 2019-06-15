//
//  HomeView.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class IdentityAuthView;

@protocol IdentityAuthViewDelegate <NSObject>

@required

- (void)identityAuthView:(IdentityAuthView *)view requestListWithPage:(NSInteger)page;

@end

@interface IdentityAuthView : UIView

@property (nonatomic, weak) id<IdentityAuthViewDelegate> delegate;
- (void)actionBlock:(DataBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array  andDataModel:(LoginModel*)model WithPage:(NSInteger)page;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
