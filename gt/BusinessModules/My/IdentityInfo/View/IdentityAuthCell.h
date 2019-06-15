//
//  SPCell.h
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IdentityAuthData;
@interface IdentityAuthCell : UITableViewCell
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(id)data andModel:(LoginModel*)dataModel;
@end
