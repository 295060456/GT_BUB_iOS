//
//  HomeInfoTableViewCell.h
//  OTC
//
//  Created by David on 2018/11/21.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HomeData;
@interface HomeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *homeCoinLab;
@property (weak, nonatomic) IBOutlet UILabel *homeUpDownLab;
@property (weak, nonatomic) IBOutlet UILabel *homeRMBLab;
@property (weak, nonatomic) IBOutlet UIImageView *homeTypeImage;
@property (nonatomic, strong) UIView *views;
+(CGFloat)cellHeightWithModel:(HomeData*)data;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(HomeData*)data;
@end

NS_ASSUME_NONNULL_END
