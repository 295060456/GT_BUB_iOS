//
//  SPCell.h
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailModel;
@interface OrdersPageListCell : UITableViewCell
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel:(OrderDetailModel*)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(OrderDetailModel*)model;
@end
