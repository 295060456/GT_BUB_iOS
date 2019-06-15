//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TransferDetailView;

@protocol TransferDetailViewDelegate <NSObject>

@required

- (void)transferDetailView:(TransferDetailView *)view requestListWithPage:(NSInteger)page;

@end

@interface TransferDetailView : UIView

@property (nonatomic, weak) id<TransferDetailViewDelegate> delegate;

- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;
- (void)actionBlock:(TwoDataBlock)block;
@end

NS_ASSUME_NONNULL_END
