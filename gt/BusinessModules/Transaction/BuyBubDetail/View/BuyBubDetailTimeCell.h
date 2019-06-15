//
//  BuyBubDetailTimeCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface BuyBubDetailTimeCell : UITableViewCell
+(instancetype)cellWith:(UITableView*)tabelView;
-(void)timeReloadWeithTimeModel:(id)mo actionBlock:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
