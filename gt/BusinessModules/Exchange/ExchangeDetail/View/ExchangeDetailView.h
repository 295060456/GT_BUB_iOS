//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ExchangeDetailView;

@protocol ExchangeDetailViewDelegate <NSObject>

@required
- (void)exchangeDetailView:(ExchangeDetailView *)view requestListWithPage:(NSInteger)page;
@end

@interface ExchangeDetailView : UIView
- (void)actionBlock:(TwoDataBlock)block;
@property (nonatomic, weak) id<ExchangeDetailViewDelegate> delegate;

- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
