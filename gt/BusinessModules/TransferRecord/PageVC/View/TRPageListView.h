//
//  HomeView.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TRPageListView;

@protocol TRPageListViewDelegate <NSObject>

@required

- (void)trpageListView:(TRPageListView *)view requestListWithPage:(NSInteger)page;

@end

@interface TRPageListView : UIView

@property (nonatomic, weak) id<TRPageListViewDelegate> delegate;
- (void)actionBlock:(ActionBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
