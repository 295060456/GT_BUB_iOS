//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferDetailCell : UITableViewCell

+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInCellWithModel:(id)model;
@end
