//
//  XcPostAdsGETVC.h
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XcPostAdsGEViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsGETVC : UITableViewController
@property (nonatomic, strong) XcPostAdsGEViewModel *viewModel;
@property (nonatomic, strong,nullable) NSDictionary *parameter2;
@end

NS_ASSUME_NONNULL_END
