//
//  BuyDetailQRFooterV.h
//  gt
//
//  Created by 鱼饼 on 2019/5/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyDetailQRFooterV : UIView
-(instancetype)initWithTitleString:(NSString*)payType andPayCode:(NSString*)payCode andQRUrlString:(NSString*)urlS actionBlock:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
