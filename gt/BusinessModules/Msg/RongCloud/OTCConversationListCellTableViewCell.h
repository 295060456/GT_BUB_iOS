//
//  OTCConversationListCellTableViewCell.h
//  gt
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTCConversationListCellTableViewCell : RCConversationBaseCell

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIImageView *photoImgV;
@property (nonatomic,strong) UILabel *numL;

-(void)setConvM:(RCConversationModel *)convM
    withIsFirst:(BOOL)isF
   withUserInfo:(RCUserInfo *)info;

@end

NS_ASSUME_NONNULL_END
