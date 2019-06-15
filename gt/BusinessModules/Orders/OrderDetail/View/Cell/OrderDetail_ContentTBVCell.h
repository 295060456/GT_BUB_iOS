//
//  OrderDetail_StyleOne_ContentTBVCell.h
//  gt
//
//  Created by Administrator on 08/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail_ContentTBVCell : UITableViewCell

+(instancetype)cellWith:(UITableView *)tabelView;

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model;

- (void)richElementsInCellWithModel:(id _Nullable)dataDic;

@end

NS_ASSUME_NONNULL_END
