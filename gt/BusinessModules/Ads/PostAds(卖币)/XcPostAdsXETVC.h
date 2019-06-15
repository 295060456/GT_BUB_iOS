//
//  XcPostAdsXETVC.h
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XcPostAdsXEViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsXETVC : UITableViewController
@property (nonatomic, strong) XcPostAdsXEViewModel *viewModel;
@property (nonatomic, strong,nullable) NSDictionary *parameter1;
@end

NS_ASSUME_NONNULL_END
