//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailSubDataItem;
@interface OrderDetailCell : UITableViewCell
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(id)paysDic WithArr:(NSArray*)arr WithIndexPath:(NSIndexPath*)indexPath;
@end
