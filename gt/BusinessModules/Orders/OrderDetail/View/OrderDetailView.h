//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OrderDetailView;

@protocol OrderDetailViewDelegate <NSObject>

@required

- (void)orderDetailView:(OrderDetailView *)view requestListWithPage:(NSInteger)page;

@end

@interface OrderDetailView : UIView

@property (nonatomic, weak) id<OrderDetailViewDelegate> delegate;

- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page;

- (void)requestListFailed;
- (void)actionBlock:(TwoDataBlock)block;
@end

NS_ASSUME_NONNULL_END
