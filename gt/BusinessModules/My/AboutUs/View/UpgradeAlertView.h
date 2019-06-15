//
//  UpgradeAlertView.h
//  gt
//
//  Created by bub chain on 16/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsModel.h"

#define XcUpgradeAlertViewObj [[UpgradeAlertView alloc] initWithFrame:CGRectZero]

NS_ASSUME_NONNULL_BEGIN

@interface UpgradeAlertView : UIView
@property (nonatomic, strong) AboutUsModel *model;
@end

NS_ASSUME_NONNULL_END
