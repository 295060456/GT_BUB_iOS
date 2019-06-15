//
//  XcPostAdsXEViewModel.h
//  gt
//
//  Created by XiaoCheng on 03/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsViewModel.h"
#import "XcPostAdsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsXEViewModel : XcPostAdsViewModel
@property (nonatomic, strong) ModifyAdsModel *requestParams;//传入数据
@property (nonatomic, strong) NSString *priceLowString;
@property (nonatomic, strong) NSString *priceHighString;
@property (nonatomic, strong) NSString *sellNumberString;
@property (nonatomic, strong) UIColor *tips2Color;
@property (nonatomic, strong) UIColor *tips3Color;
@property (nonatomic, strong) NSString *minuteString;

@property (nonatomic, strong) RACSignal *jyeJudgeText;//tips1
@property (nonatomic, strong) RACSignal *mslJudge;
@property (nonatomic, strong) RACSignal *timeJudge;

@property (nonatomic, copy) IntegerBlock alertBlock;//显示alert view

@property (nonatomic, assign) BOOL  isSelectIdentity;
@property (nonatomic, assign) BOOL  isSelectVIPIdentity;

- (void) upBuyerAstrict:(UIButton *) btn1
                       :(UIImageView*) img1
                       :(UIButton *) btn2
                       :(UIImageView*) img2
                       :(BOOL) select;
@end

NS_ASSUME_NONNULL_END
