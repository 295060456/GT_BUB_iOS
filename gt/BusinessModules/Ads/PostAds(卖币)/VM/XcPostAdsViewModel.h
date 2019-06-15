//
//  XcPostAdsViewModel.h
//  gt
//
//  Created by XiaoCheng on 28/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostAdsModel.h"
#import "ModifyAdsModel.h"
#import "HomeVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface XcPostAdsViewModel : NSObject
@property (nonatomic, strong) RACCommand *getUserAssertRequest;//查询用户资产
@property (nonatomic, strong) RACCommand *getPostAdsRequest;//获取广告限制
@property (nonatomic, strong) RACCommand *sendAdsRequest;//商家发布广告 & 商家广告修改
@property (nonatomic, strong) RACCommand *getMyAccTypeRequest;// 获取收款方式

@property (nonatomic, strong) PostAdvertisingModel *adsModel;//获取广告限制
@property (nonatomic, strong) QueryUserPropertyModel *queryUserPropertyModel;//查询用户资产
@property (nonatomic, strong) ModifyAdsModel *requestParams;//传入数据
@property (nonatomic, strong) NSArray *myAccs;//银行卡数据
@property (nonatomic, copy) NoResultBlock reloadDataView;//刷新收款方式
@property (nonatomic, assign) TransactionAmountType currentPageType;//当前页面
@property (nonatomic, copy) NoResultBlock submit;//发布
@end

NS_ASSUME_NONNULL_END
