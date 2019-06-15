//
//  PageVM.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PageVM.h"
#import "PageModel.h"
@interface PageVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) PageModel* model;
@end

@implementation PageVM
- (void)network_outlineAdRequestParams:(id)requestParams withAdID:(NSString*)adID success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* dic = requestParams;
    NSString *pwd = dic.allKeys[0];
    if (pwd && pwd.length == 32) { // 外面已经加过密
    }else{
        pwd = [NSString MD5WithString:pwd isLowercase:YES];
    }
    NSDictionary* proDic =
    @{@"advertId":adID,
      @"transactionPassword":pwd,
      @"googlecode":dic.allValues[0]
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_OutlineAds] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PageModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            [YKToastView showToastText:weakSelf.model.msg];
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}

- (void)network_onlineAdRequestParams:(id)requestParams withAdID:(NSString*)adID withNumber:(NSString*)number success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* dic = requestParams;
    NSString *pwd = dic.allKeys[0];
    if(pwd.length != 32 ){
        pwd = [NSString MD5WithString:pwd isLowercase:YES];
    }
    NSDictionary* proDic =
    @{@"advertId":adID,
      @"number":number,
      @"transactionPassword":pwd,
      @"googlecode":dic.allValues[0]
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_OnlineAds] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PageModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            [YKToastView showToastText:weakSelf.model.msg];
            success(weakSelf.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}


- (void)network_getAdsPageListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    NSString* p =  [NSString stringWithFormat:@"%ld",(long)page];
    NSString* t =  [NSString stringWithFormat:@"%@",requestParams];
    NSString* pagesize =  @"10";
    NSDictionary *params = @{
                             @"type":t,
                             @"pageno":p,
                             @"pagesize":pagesize
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    //    [self assembleApiData:weakSelf.model];
    //    success(weakSelf.listData);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AdsList] andType:All andWith:params success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        
        self.model = [PageModel mj_objectWithKeyValues:dic];
        
        if ([NSString getDataSuccessed:dic]) {
            //success(weakSelf.model);
            [weakSelf assembleApiData:self.model];
            success(weakSelf.listData);
        }
        else{
            [YKToastView showToastText:weakSelf.model.msg];
            failed(weakSelf.model);
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
    }];
    
}

- (void)assembleApiData:(PageModel*)data{
    if (data.merchantAdvert !=nil && data.merchantAdvert.count>0) {
        [data.merchantAdvert enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ModifyAdsModel* item = obj;
            [self.listData addObject:@[item]];
        }];
        //        [self.listData addObjectsFromArray:data.b];
    }
}
@end
