//
//  HomeView.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OrdersPageListView;

@protocol OrdersPageListViewDelegate <NSObject>

@required

- (void)ordersPageListView:(OrdersPageListView *)view
       requestListWithPage:(NSInteger)page;

@end

@interface OrdersPageListView : UIView

@property (nonatomic, weak) id<OrdersPageListViewDelegate> delegate;

- (void)actionBlock:(TwoDataBlock)block;

- (void)scrollToTop;

- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page
                       WithUserType:(UserType)utype;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
