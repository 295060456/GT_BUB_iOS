//
//  HomeView.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TransactionView;

@protocol TransactionViewDelegate <NSObject>

@required

- (void)transactionView:(TransactionView *)view
    requestListWithPage:(NSInteger)page
          WithFilterArr:(NSArray*)fliterArr;

@end

@interface TransactionView : UIView

@property (nonatomic, weak) id<TransactionViewDelegate> delegate;
- (void)actionBlock:(TwoDataBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array
                           WithPage:(NSInteger)page
                            WithSum:(NSInteger)sum;

- (void)requestListServiceErrorFailed;

- (void)requestListNetworkErrorFailed;
- (void)getInitFliterStatus;
@end

NS_ASSUME_NONNULL_END
