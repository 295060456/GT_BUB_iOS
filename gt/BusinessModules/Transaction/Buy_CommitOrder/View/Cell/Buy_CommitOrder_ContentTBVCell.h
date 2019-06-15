//
//  Buy_ContentTBVCell.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
    买币 -  提交订单
 */
@interface Buy_CommitOrder_ContentTBVCell : UITableViewCell

+(instancetype)cellWith:(UITableView *)tabelView;

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model;

- (void)actionBlock:(ActionBlock)block;

- (void)richElementsInCellWithModel:(id _Nullable)dataDic;


@end

NS_ASSUME_NONNULL_END
