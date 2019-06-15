//
//  PostAppealPhotoCell.h
//  gt
//
//  Created by Administrator on 23/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostAppealPhotoCell : UITableViewCell

@property(nonatomic,copy)void(^PhotoBlock)(void);

@property(nonatomic,strong)UIButton *photoBtn;

+(instancetype)cellWith:(UITableView *)tabelView;

@end

NS_ASSUME_NONNULL_END
