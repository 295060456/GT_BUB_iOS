//
//  Buy_NotifyTBVCell.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Buy_NotifyTBVCell : UITableViewCell

@property(nonatomic,strong)UIButton *submitBtn;

+(instancetype)cellWith:(UITableView *)tabelView;

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model;

- (void)actionBlock:(ActionBlock)block;

- (void)richElementsInCellWithModel:(id _Nullable)dataDic;

@end

NS_ASSUME_NONNULL_END
