//
//  MyAccountNarrowCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/7.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MyAccountNarrowCellDelegate <NSObject>
-(void)myAccountNarrowCellActin:(id)button andModel:(id)model;
-(void)viewBigPictureModel:(id)model;
@end


@interface MyAccountNarrowCell : UITableViewCell
@property (nonatomic ,weak) id <MyAccountNarrowCellDelegate> delegate;
-(void)reloadCellDataWith:(id)model andEdit:(BOOL)isEdit showBG:(BOOL)show;
-(void)watchImageBuAction;
@end

NS_ASSUME_NONNULL_END
