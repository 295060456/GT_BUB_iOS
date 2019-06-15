//
//  AddAccountCell.h
//  gt
//
//  Created by 钢镚儿 on 2018/12/20.
//  Copyright © 2018年 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAccountCell : UITableViewCell

+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row SelectedRow:(NSInteger)selectedRow;
- (void)actionBlock:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
