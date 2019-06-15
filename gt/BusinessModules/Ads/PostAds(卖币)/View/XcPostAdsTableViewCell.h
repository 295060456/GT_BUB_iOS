//
//  XcPostAdsTableViewCell.h
//  gt
//
//  Created by XiaoCheng on 28/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XcPostAdsTableViewCell_GE_HEIGHT    46.0f
NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *fixedAmount;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) ActionBlock block;


@property (nonatomic, assign) TransactionAmountType type;
@property (nonatomic, strong) NSArray *datas;

- (void) reloadDataView;
@end

NS_ASSUME_NONNULL_END
