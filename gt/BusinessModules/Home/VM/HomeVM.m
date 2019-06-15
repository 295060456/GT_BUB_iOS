//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeVM.h"

@interface HomeVM()

@property(strong,nonatomic)NSMutableArray *listData;
@property(nonatomic,strong)HomeModel* model;
@property(nonatomic,strong)UserAssertModel* usModel;

@end

@implementation HomeVM

//收款方式列表
- (void)network_accountListRequestParams:(id _Nullable)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err{
    
    NSDictionary* proDic = @{};
    
    [SVProgressHUD showWithStatus:@"加载中..."
                         maskType:SVProgressHUDMaskTypeNone];
    
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PayMentAccountList]
                                                      andType:All
                                                      andWith:proDic
                                                      success:^(NSDictionary *dic) {
                                                          
                                                          AccountListModel *accountListModel = [AccountListModel mj_objectWithKeyValues:dic];
                                                          
                                                          NSMutableArray *dataMutArr= NSMutableArray.array;
                                                          
                                                          // 修改数据完毕以后，装数据
                                                          for (int i = 0; i < accountListModel.paymentWay.count; i++) {
                                                              
                                                              AccountPaymentWayModel *accountPaymentWayModel = accountListModel.paymentWay[i];
                                                              
                                                              [dataMutArr addObject:accountPaymentWayModel];
                                                          }
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayCellInPostAdsRefresh
                                                                                                                  object:nil];
                                                              
                                                              success(dataMutArr);
                                                          }
                                                          else{
                                                              
                                                              [YKToastView showToastText:accountListModel.msg];
                                                              
                                                              failed(dataMutArr);
                                                          }
                                                      } error:^(NSError *error) {
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                          [YKToastView showToastText:error.description];
                                                          
                                                          err(error);
                                                      }];
}

- (void)network_getTrendsListWithPage:(NSInteger)page
                              success:(void (^)(NSArray * _Nonnull))success
                               failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    NSArray* gridSectionNames = @[@"Location",@"Quickening",@"CircleAnimation",@"TagRun",@"ModelFilter"];
    
    NSMutableArray* gridParams = [NSMutableArray array];
    for (int i=0; i < gridSectionNames.count; i++) {
        NSDictionary * param = @{kArr:gridSectionNames[i],
                                 kImg:[NSString stringWithFormat:@"home_grid_%i",i],
                                 kUrl:@""};
        [gridParams addObject:param];
    }
    [self removeContentWithType:IndexSectionTwo];
    [self.listData addObject: gridParams];
    success(self.listData);
}

- (void)network_checkFixedPricesSuccess:(DataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err {
    NSDictionary* proDic =@{};
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionsOptionsCheck]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         HomeModel* pricemodel  = [HomeModel mj_objectWithKeyValues:dic];
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             if (pricemodel.price != nil) {
                                                                 [self setPriceData:pricemodel.price];
                                                             }
                                                         }
                                                         else{
                                                             failed(weakSelf.model);
                                                         }
                                                     } error:^(NSError *error) {
                                                         err(error);
                                                     }];
}

- (void)setPriceData:(NSString*)priceOptions{
    if (priceOptions!=nil) {
        
        NSArray  *prices = [NSArray array];
        if ([priceOptions containsString:@","]) {
            prices = [priceOptions componentsSeparatedByString:@","];
        }else{
            prices = @[priceOptions];
        }
        SetUserDefaultKeyWithObject(kFixedAccountsInTransactions,prices);
        UserDefaultSynchronize;
    }
}

- (void)network_getBannerSuccess:(DataBlock)success
                          failed:(DataBlock)failed
                           error:(DataBlock)err{
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_HomeBanner]
                                                     andType:All
                                                     andWith:@{}
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         self.model = [HomeModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             // 数据缓存
                                                             NSArray *banneAr = dic[@"banner"];
                                                             
                                                             if (banneAr && banneAr.count > 0) {
                                                                 
                                                                 [self entDataWith:kHomeBannerDataKey
                                                                              data:banneAr];
                                                             }
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             success(weakSelf.model);
                                                         }
                                                         
                                                     } error:^(NSError *error) {
                                                         err(error);
                                                     }];
    //    [SVProgressHUD dismiss];
}
- (void)network_getUserAssertSuccess:(DataBlock)success
                              failed:(DataBlock)failed
                               error:(DataBlock)err{
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_UserAssert]
                                                     andType:All
                                                     andWith:@{}
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         self.usModel = [UserAssertModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             success(weakSelf.usModel);
                                                         }
                                                         else{
                                                             failed(weakSelf.usModel);
                                                         }
                                                     } error:^(NSError *error) {
                                                         err(error);
                                                     }];
}

- (void)network_getHomeListWithPage:(NSInteger)page
                            success:(DataBlock)success
                             failed:(DataBlock)failed
                              error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
    [self removeContentWithType:IndexSectionZero];
    
    
    NSArray *bannerDicAr = (NSArray*)[self getOldeDataAndKey:kHomeBannerDataKey];
    if (bannerDicAr && bannerDicAr.count > 0 && page==1) {
        NSMutableArray *banners = [NSMutableArray array];
        for (NSDictionary *bannerDic in bannerDicAr) {
            HomeBannerData *bannerData = [HomeBannerData mj_objectWithKeyValues:bannerDic];
            [banners addObject:bannerData];
        }
        NSDictionary* dic = @{kIndexInfo:@"",
                              kTip:@"BUB",
                              kArr:banners!=nil?banners:
                                  @[]
                              };
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[dic]}];
    }else{
        NSDictionary* dic = @{kIndexInfo:@"",
                              kTip:@"BUB",
                              kArr:
                                  @[
                                      //                                 @{kImg:@"banner1",kTit:@"https://www.baidu.com"},
                                      //                                  @{kImg:@"banner2",kTit:@"https://news.baidu.com"},
                                      //                                 @{kImg:@"banner3",kTit:@"http://music.taihe.com"}
                                      ]
                              };
        
        if (page==1) {
            [self.listData addObject:@{
                                       kIndexSection: @(IndexSectionZero),
                                       kIndexRow: @[dic]}];
        }
    }
    
    [self removeContentWithType:IndexSectionOne];
    if (page == 1){
        [self.listData addObject:@{kIndexSection: @(IndexSectionOne),
                                   kIndexInfo:@[@"待处理订单",@"icon_bank"],
                                   /* kIndexRow: @[gridParams] */}];
    }
    
    NSArray *coinDicAr = (NSArray*)[self getOldeDataAndKey:kHomeCoinListDataKey];
    
    if (coinDicAr &&
        coinDicAr.count > 0 &&
        page == 1) {
        
        [self removeContentWithType:IndexSectionTwo];
        
        NSMutableArray *coins = [NSMutableArray array];
        
        for (NSDictionary *coinDic in coinDicAr) {
            
            HomeData *bannerData = [HomeData mj_objectWithKeyValues:coinDic];
            
            [coins addObject:bannerData];
        }
        NSLog(@"---- %@",@{
                           kIndexSection: @(IndexSectionTwo),
                           kIndexRow: coins});
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionTwo),
                                   kIndexRow: coins}//data.t.arr
         ];
    }
    
    success(self.listData);
    
    [self sortData];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    WS(weakSelf);
    BOOL valueLogin = GetUserDefaultBoolWithKey(kIsLogin);
    if (!valueLogin) {
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Home]
                                                         andType:All
                                                         andWith:@{}
                                                         success:^(NSDictionary *dic) {
                                                             [self network_getBannerSuccess:^(id data) {
                                                                 
                                                                 NSArray *banneAr = dic[@"marketList"];
                                                                 
                                                                 if (banneAr && banneAr.count > 0 && page == 1) {
                                                                     
                                                                     [self entDataWith:kHomeCoinListDataKey data:banneAr];
                                                                 }
                                                                 
                                                                 self.model = [HomeModel mj_objectWithKeyValues:dic];
                                                                 
                                                                 if ([NSString getDataSuccessed:dic]) {
                                                                     //success(weakSelf.model);
                                                                     HomeModel* bannerModel = data;
                                                                     
                                                                     [weakSelf assembleApiData:self.model
                                                                                WithUserAssert:nil
                                                                                   WithBanners:bannerModel.banner
                                                                                      WithPage:page];
                                                                     success(weakSelf.listData);
                                                                 }
                                                                 else{
                                                                     
                                                                     //                    [YKToastView showToastText:weakSelf.model.msg];
                                                                     failed(weakSelf.model);
                                                                 }
                                                             } failed:^(id data) {
                                                                 if ([NSString getDataSuccessed:dic]) {
                                                                     //success(weakSelf.model);
                                                                     //                    HomeModel* bannerModel = data;
                                                                     [weakSelf assembleApiData:self.model WithUserAssert:nil WithBanners:nil  WithPage:page];
                                                                     success(weakSelf.listData);
                                                                 }
                                                                 else{
                                                                     
                                                                     //                    [YKToastView showToastText:weakSelf.model.msg];
                                                                     failed(weakSelf.model);
                                                                 }
                                                             } error:^(id data) {
                                                                 NSLog(@"dd");
                                                             }];
                                                             
                                                         } error:^(NSError *error) {
                                                             //            [YKToastView showToastText:error.description];
                                                             err(error);
                                                         }];
        [SVProgressHUD dismiss];
    }else{
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Home]
                                                         andType:All
                                                         andWith:@{}
                                                         success:^(NSDictionary *dic) {
                                                             
                                                             
                                                             [self network_getBannerSuccess:^(id data) {
                                                                 
                                                                 NSArray *banneAr = dic[@"marketList"];
                                                                 
                                                                 if (banneAr && banneAr.count > 0 && page == 1) {
                                                                     
                                                                     [self entDataWith:kHomeCoinListDataKey data:banneAr];
                                                                 }
                                                                 
                                                                 HomeModel* bannerM = data;
                                                                 
                                                                 [self network_getUserAssertSuccess:^(id data) {
                                                                     
                                                                     UserAssertModel* item = data;
                                                                     
                                                                     self.model = [HomeModel mj_objectWithKeyValues:dic];
                                                                     
                                                                     HomeModel* bannerModel = bannerM;
                                                                     
                                                                     if ([NSString getDataSuccessed:dic]) {
                                                                         //success(weakSelf.model);
                                                                         [weakSelf assembleApiData:self.model
                                                                                    WithUserAssert:item
                                                                                       WithBanners:bannerModel.banner
                                                                                          WithPage:page];
                                                                         
                                                                         SetUserDefaultKeyWithObject(kUserAssert, [item mj_keyValues]);
                                                                         
                                                                         UserDefaultSynchronize;
                                                                         
                                                                         success(weakSelf.listData);
                                                                     }
                                                                     else{
                                                                         //                        [YKToastView showToastText:weakSelf.model.msg];
                                                                         failed(weakSelf.model);
                                                                     }
                                                                     
                                                                 } failed:^(id data) {
                                                                     
                                                                     UserAssertModel* item = data;
                                                                     
                                                                     NSInteger errorI = [item.errcode integerValue];
                                                                     
                                                                     if (errorI != 1) {
                                                                         
                                                                         SetUserBoolKeyWithObject(kIsLogin, NO);
                                                                         
                                                                         DeleUserDefaultWithKey(kUserInfo);
                                                                         
                                                                         UserDefaultSynchronize;
                                                                         
                                                                         if ([NSString getDataSuccessed:dic]) {
                                                                             //                    success(weakSelf.model);
                                                                             //                        [weakSelf assembleApiData:weakSelf.model WithUserAssert:nil WithPage:page];
                                                                             //                        success(weakSelf.listData);
                                                                             success(@(errorI));
                                                                         }
                                                                         else{
                                                                             //                            [YKToastView showToastText:weakSelf.model.msg];
                                                                             failed(weakSelf.model);
                                                                         }
                                                                     }
                                                                 } error:^(id data) {
                                                                     
                                                                     self.model = [HomeModel mj_objectWithKeyValues:dic];
                                                                     
                                                                     if ([NSString getDataSuccessed:dic]) {
                                                                         //success(weakSelf.model);
                                                                         [weakSelf assembleApiData:weakSelf.model
                                                                                    WithUserAssert:nil
                                                                                       WithBanners:bannerM.banner
                                                                                          WithPage:page];
                                                                         
                                                                         success(weakSelf.listData);
                                                                     }
                                                                     else{
                                                                         //                        [YKToastView showToastText:weakSelf.model.msg];
                                                                         failed(weakSelf.model);
                                                                     }
                                                                 }];} failed:^(id data) {} error:^(id data) {}]; } error:^(NSError *error) {
                                                                     err(error);
                                                         }];
        
        [SVProgressHUD dismiss];
    }
}

- (void)assembleApiData:(HomeModel*)data
         WithUserAssert:(UserAssertModel*)usModel
            WithBanners:(NSArray*)banners
               WithPage:(NSInteger)page{
    
    [self removeContentWithType:IndexSectionZero];
    
    NSDictionary* dic = @{kIndexInfo:usModel!=nil?usModel:@"",
                          kTip:@"BUB",
                          kArr:banners!=nil?banners:
                              @[
                                  //                                 @{kImg:@"banner1",kTit:@"https://www.baidu.com"},
                                  //                                  @{kImg:@"banner2",kTit:@"https://news.baidu.com"},
                                  //                                 @{kImg:@"banner3",kTit:@"http://music.taihe.com"}
                                  ]
                          };
    
    if (page == 1) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[dic]}];
    }
    
    [self removeContentWithType:IndexSectionTwo];
    
    if (data.marketList !=nil &&
        data.marketList.count > 0) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionTwo),
                                   kIndexRow: data.marketList}//data.t.arr
         ];
    }
    
    [self sortData];
}

- (void)sortData {
    
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        
        if (contentType == type) {
            
            *stop = YES;
            
            [self.listData removeObject:obj];
        }
    }];
}

-(id)getOldeDataAndKey:(NSString*)key{
    
    NSString *filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
    
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    return data;
}

-(void)entDataWith:(NSString*)key
              data:(id)data{
    
    if (data) {
        
        NSString *filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
        
        [NSKeyedArchiver archiveRootObject:data
                                    toFile:filename];
    }
}

// 一键购买
- (void)networkNoeBuyBubPostDataWith:(NSDictionary*)postDic
                           esSuccess:(DataBlock)success
                              failed:(DataBlock)failed
                               error:(DataBlock)err {
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_NoeBuyBubType]
                                                     andType:All
                                                     andWith:postDic
                                                     success:^(NSDictionary *dic) {
                                                         [SVProgressHUD dismiss];
                                                         NSString *s = dic[@"errcode"];
                                                         if ([s isEqualToString:@"1"]) {
                                                             NSString *orerNo = dic[@"orderNo"] ? dic[@"orderNo"]: dic[@"orderId"];
                                                             success(orerNo);
                                                         }else{
                                                             [YKToastView showToastText:dic[@"msg"]];
                                                         }
                                                     } error:^(NSError *error) {
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                     }];
}

@end





