//
//  MsgListTableViewCell.h
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong) UILabel * nickLb;
@property (nonatomic, strong) UILabel * timeLb;
@property (nonatomic, strong) UILabel * msgLb;
@property (nonatomic, strong) UILabel * numLb;

@end

NS_ASSUME_NONNULL_END
