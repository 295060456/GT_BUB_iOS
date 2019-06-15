//
//  AssetsCell.h
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AssetsData;
@interface AssetsCell : UITableViewCell
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(AssetsData*)model;

@end

NS_ASSUME_NONNULL_END
