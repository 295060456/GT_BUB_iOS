//
//  MyInputCell.h
//  gt
//
//  Created by cookie on 2018/12/21.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString  * _Nullable accountS = @"账号单日收款上限 (选填)";


NS_ASSUME_NONNULL_BEGIN

@interface MyInputCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLb;

@property (nonatomic, strong) UITextField * inputTF;

+(CGFloat)cellHeightWithModel;

+(instancetype)cellWith:(UITableView*)tabelView;

- (void)richElementsInCellWithModel:(NSDictionary*)model
                       WithIndexRow:(NSInteger)row;

- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model
                                 WithIndexRow:(NSInteger)row WithAllSourceSum:(NSInteger)sum;

- (void)richElementsInNotYetVertifyCellWithModel:(NSDictionary*)model
                                    WithIndexRow:(NSInteger)row;

- (void)actionBlock:(TwoDataBlock)block;

@end

NS_ASSUME_NONNULL_END
