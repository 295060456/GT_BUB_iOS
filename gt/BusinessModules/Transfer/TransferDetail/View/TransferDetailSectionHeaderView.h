//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TransferDetailSectionHeaderReuseIdentifier = @"TransferDetailSectionHeaderView";
static NSString *TransferDetailSectionFooterReuseIdentifier = @"TransferDetailSectionFooterView";


@interface TransferDetailSectionHeaderView : UITableViewHeaderFooterView

+ (CGFloat)viewHeight;
- (void)richElementsInViewWithModel:(id)model;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;

@end

@interface TransferDetailSectionFooterView : UITableViewHeaderFooterView
- (void)actionBlock:(TwoDataBlock)block;
- (void)richElementsInViewWithModel:(id)model;
+ (void)sectionFooterViewWith:(UITableView*)tableView;

+ (CGFloat)viewHeightWithType:(TransferDetailType)type;

@end
