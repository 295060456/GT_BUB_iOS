//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostAppealPhotoCell.h"

NS_ASSUME_NONNULL_BEGIN

@class PostAppealView;

@protocol PostAppealViewDelegate <NSObject>

@required

- (void)postAppealView:(PostAppealView *)view
   requestListWithPage:(NSInteger)page;

@end

@interface PostAppealView : UIView


@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);

@property (nonatomic, weak) id<PostAppealViewDelegate> delegate;

//@property (nonatomic, weak) void(^MyBlock)(void);///xxxxxxxx

@property (nonatomic, strong)PostAppealPhotoCell *postAppealPhotoCell;

- (void)actionBlock:(TwoDataBlock)block;

- (void)requestListSuccessWithArray:(NSArray *)array andIsAntiAppeal:(BOOL)isantiAppeal andResonString:(NSString*)reason;

- (void)requestListFailed;

- (instancetype)initWithFrame:(CGRect)frame
                requestParams:(id)requestParams;

@end

NS_ASSUME_NONNULL_END
