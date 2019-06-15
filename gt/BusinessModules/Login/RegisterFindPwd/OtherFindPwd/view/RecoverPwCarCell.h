//
//  RecoverPwCarCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecoverPwCarCell : UITableViewCell
@property (nonatomic, strong) UILabel * titleLb;
@property (nonatomic, strong) UITextField * inputTF;

+(instancetype)cellWith:(UITableView*)tabelView;

- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model
                                 WithIndexRow:(NSInteger)row;
- (void)actionBlock:(TwoDataBlock)block;
@end

NS_ASSUME_NONNULL_END
