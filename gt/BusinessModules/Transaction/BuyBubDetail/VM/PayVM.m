//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PayVM.h"
#import "OrderDetailModel.h"

@interface PayVM()

@property(nonatomic,strong)NSMutableArray *listData;

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

@end

@implementation PayVM

- (void)network_canclePayListWithRequestParams:(id)requestParams
                                       success:(DataBlock)success
                                        failed:(DataBlock)failed
                                         error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    
    NSDictionary *params = @{
                             @"orderNo": requestParams
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionCancelPay]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
        
                                                         [SVProgressHUD dismiss];
        
                                                         PayModel *model = [PayModel mj_objectWithKeyValues:dic];
                                                         
        
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(model);
                                                         }
                                                         else{
                                                             failed(model);
                                                             [YKToastView showToastText:model.msg];
                                                         }
        
    } error:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        err(error);
        
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_confirmPayListWithRequestParams:(id)requestParams
                                 WithPaymentWay:(NSString*)paymentWay
                                        success:(DataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    if (paymentWay.length != 32) {
        
        paymentWay = [NSString MD5WithString:paymentWay isLowercase:YES];
    }
    NSDictionary *params = @{
                             @"orderNo": requestParams,
                             @"transactionPassword": paymentWay
                             };

    [SVProgressHUD showWithStatus:@"加载中..."];

    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionComfirmPay]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
        
                                                         [SVProgressHUD dismiss];
        
                                                         PayModel *model = [PayModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
            
                                                             success(model);
                                                         }
                                                         else{
            
                                                             failed(model);
            
                                                             [YKToastView showToastText:model.msg];
                                                         }
    } error:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        err(error);
        
        [YKToastView showToastText:error.description];
    }];
}

- (void)network_postPayListWithPage:(NSInteger)page
                  WithRequestParams:(id)requestParams
                            success:(DataBlock)success
                             failed:(DataBlock)failed
                              error:(DataBlock)err{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionPay]
                                                     andType:All
                                                     andWith:requestParams
                                                     success:^(NSDictionary *dic) {
    
//                                                         NSLog(@"%@",dic);
                                                         
                                                         [SVProgressHUD dismiss];
        
                                                         OrderDetailModel *model =  [OrderDetailModel mj_objectWithKeyValues:dic];
                                      
                                                         if ([NSString getDataSuccessed:dic]) {
            
                                                             success(model);

                                                         }else{
            
                                                             failed(dic);
                                                         }
        
    } error:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        err(error);
        
        [YKToastView showToastText:error.description];
    }];
}


@end
