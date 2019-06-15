//
//  PostAdsPayChooseView.h
//  gt
//
//  Created by 鱼饼 on 2019/5/23.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostAdsPayChooseView : UIView
-(instancetype)initWithMydata:(id)data andType:(TransactionAmountType)type block:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
