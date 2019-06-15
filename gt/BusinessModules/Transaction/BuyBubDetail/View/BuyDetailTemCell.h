//
//  BuyDetailTemCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyDetailTemCell : UITableViewCell
+(instancetype)cellWith:(UITableView*)tabelView;
-(void)cellShowCopyButnWithDic:(NSDictionary*)myDic; // 显示后面按钮
-(void)cellDataWithDic:(NSDictionary*)myDic; // 不显示按钮

@end

NS_ASSUME_NONNULL_END
