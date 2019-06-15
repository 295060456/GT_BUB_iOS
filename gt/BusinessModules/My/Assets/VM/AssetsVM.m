//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "AssetsVM.h"
#import "HomeModel.h"
#import "AssetsModel.h"

@interface AssetsVM()

@property(strong,nonatomic)NSMutableArray *listData;
@property(nonatomic,strong)AssetsModel* model;
@property(nonatomic,strong)UserAssertModel* usModel;

@end

@implementation AssetsVM

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
        //        [YKToastView showToastText:weakSelf.item.msg];
        
    } error:^(NSError *error) {
        err(error);
        //        [YKToastView showToastText:error.description];
        
    }];
    //    [SVProgressHUD dismiss];
}

- (void)network_getAssetsListWithPage:(NSInteger)page
                     WithExchangeType:(ExchangeType)type
                              success:(TwoDataBlock)success
                               failed:(DataBlock)failed
                                error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
    NSString* p =  [NSString stringWithFormat:@"%ld",page];
    NSString* t =  [NSString stringWithFormat:@"%ld",type];
    NSString* pagesize =  @"10";
    NSDictionary* proDic =@{@"pageno":p,@"type":t,@"pagesize":pagesize};
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    WS(weakSelf);
    
    BOOL valueLogin = GetUserDefaultBoolWithKey(kIsLogin);
    
    if (!valueLogin) {
        
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_UserAssertList]
                                                         andType:All
                                                         andWith:proDic
                                                         success:^(NSDictionary *dic) {
                                                             
            self.model = [AssetsModel mj_objectWithKeyValues:dic];
                                                             
            [SVProgressHUD dismiss];
                                                             
            if ([NSString getDataSuccessed:dic]) {
                
                success(nil,weakSelf.model.accountChange);
//                [weakSelf assembleApiData:self.model WithUserAssert:nil WithPage:page];
//                success(weakSelf.listData);
            }else{
                
                [YKToastView showToastText:weakSelf.model.msg];
                
                failed(weakSelf.model);
            }
        } error:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            
            [YKToastView showToastText:error.description];
            
            err(error);
        }];
    }else{
        
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_UserAssertList]
                                                         andType:All
                                                         andWith:proDic
                                                         success:^(NSDictionary *dic) {
            
            self.model = [AssetsModel mj_objectWithKeyValues:dic];
            
            [self network_getUserAssertSuccess:^(id data) {
                
                UserAssertModel* item = data;
                
                [SVProgressHUD dismiss];
                
                if ([NSString getDataSuccessed:dic]) {
                    
                    success(item,weakSelf.model.accountChange);
                    
//                    [weakSelf assembleApiData:self.model WithUserAssert:item WithPage:page];
//                    SetUserDefaultKeyWithObject(kUserAssert, [item mj_keyValues]);
//                    UserDefaultSynchronize;
//                    success(weakSelf.listData);
                }else{
                    
                    [YKToastView showToastText:weakSelf.model.msg];
                    
                    failed(weakSelf.model);
                }
            } failed:^(id data) {
                
                if ([NSString getDataSuccessed:dic]) {
                    
                    success(nil,weakSelf.model.accountChange);
                    
//                    [weakSelf assembleApiData:weakSelf.model WithUserAssert:nil WithPage:page];
//                    success(weakSelf.listData);
                } else{
                    
                    [YKToastView showToastText:weakSelf.model.msg];
                    
                    failed(weakSelf.model);
                }
            } error:^(id data) {
                
                if ([NSString getDataSuccessed:dic]) {
                    
                    success(nil,weakSelf.model.accountChange);
//                    [weakSelf assembleApiData:weakSelf.model WithUserAssert:nil WithPage:page];
//                    success(weakSelf.listData);
                    
                }else{
                    
                    [YKToastView showToastText:weakSelf.model.msg];
                    failed(weakSelf.model);
                }
            }];
            
            //        [YKToastView showToastText:weakSelf.model.msg];
            
        } error:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            
            [YKToastView showToastText:error.description];
            
            err(error);
        }];
    }
}

@end
