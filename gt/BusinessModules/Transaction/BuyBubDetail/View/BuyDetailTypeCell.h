//
//  BuyDetailTypeCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyBubDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface BuyDetailTypeCell : UITableViewCell
+(instancetype)cellWith:(UITableView*)tabelView;
@property(nonatomic ,strong) BuyBubDetailModel *myData;
@end

NS_ASSUME_NONNULL_END
