//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeDetailVM.h"
static NSString *ExchangeDetailSectionHeaderReuseIdentifier = @"ExchangeDetailSectionHeaderView";
static NSString *ExchangeDetailSectionFooterReuseIdentifier = @"ExchangeDetailSectionFooterView";

@interface ExchangeDetailSectionHeaderView : UITableViewHeaderFooterView
+ (CGFloat)viewHeight;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;
@end

@interface ExchangeDetailSectionFooterView : UITableViewHeaderFooterView

- (void)richElementsInFooterView:(NSDictionary*)itemData;
+ (void)sectionFooterViewWith:(UITableView*)tableView;

- (void)moreActionBlock:(DataBlock)block;
+ (CGFloat)viewHeightWithType:(ExchangeType)type;

@end
