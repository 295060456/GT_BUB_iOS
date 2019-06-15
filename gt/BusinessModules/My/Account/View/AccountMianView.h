//
//  AccountMianView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,AccountMianViewType){
    accountAdd = 0,   
    accountfreshHeader  ,
    accountBigPicture,
    accountDetele,
};

@interface AccountMianView : UIView
-(instancetype)initWithBlockSuccess:(DataTypeBlock)block;
-(void)reloadDataWith:(nullable id)data;
-(void)toEdit:(BOOL)isEdit;
@end

NS_ASSUME_NONNULL_END
