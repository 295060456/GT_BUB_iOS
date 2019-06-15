//
//  SPCell.h
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModifyAdsModel;
@interface PageListCell : UITableViewCell
- (void)actionBlock:(TwoDataBlock)block;
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(ModifyAdsModel*)model;
@end
