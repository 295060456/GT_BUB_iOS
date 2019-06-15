//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "OrderDetailVM.h"
#import "BuyBubDetailModel.h"

@interface OrderDetailVM()

@property (strong,nonatomic)NSMutableArray *listData;
@property (strong,nonatomic)NSArray *gridSectionNames;
@property (nonatomic,strong)OrderDetailModel *model;

@end

@implementation OrderDetailVM

- (void)network_submitAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err{
    NSArray* arr = requestParams;
    _listData = [NSMutableArray array];
    
    NSDictionary *params = @{
                             @"remark": arr[0],
                             @"appealReason": arr[1],
                             @"contactWay": arr[2],
                             @"orderNo": arr[3]//订单号
                             };
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SubmitAppeal]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         
                                                         self.model = [OrderDetailModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.model);
                                                             
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

- (void)network_cancelAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    if (requestParams==nil) {
        [YKToastView showToastText:@"申述ID缺失"];
    }
    NSDictionary *params = @{
                             @"appealId": requestParams
                             };
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CancelAppeal]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         
                                                         self.model = [OrderDetailModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(weakSelf.model);
                                                             
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

- (void)network_transactionOrderSureDistributeWithCodeDic:(NSDictionary *)codeDic
                                        WithRequestParams:(id)requestParams
                                                  success:(DataBlock)success
                                                   failed:(DataBlock)failed
                                                    error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    NSString *pwd = codeDic.allKeys[0];
    if(pwd.length != 32){
        pwd = [NSString MD5WithString:pwd isLowercase:YES];
    }
    NSDictionary *params =
    @{@"transactionPassword":pwd,
      @"googlecode":codeDic.allValues[0],
      @"orderNo":requestParams
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionOrderSureDistribute]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         self.model = [OrderDetailModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             
                                                             [YKToastView showToastText:weakSelf.model.msg];
                                                             success(weakSelf.model);
                                                         }
                                                         else{
                                                             [YKToastView showToastText:weakSelf.model.msg];
                                                             failed(weakSelf.model);
                                                             
                                                         }
                                                     } error:^(NSError *error) {
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                     }];
    
    [SVProgressHUD dismiss];
}

- (void)network_getOrderDetailListWithPage:(NSInteger)page
                         WithRequestParams:(id)requestParams
                                   success:(ThreeDataBlock)success
                                    failed:(DataBlock)failed
                                     error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    
    NSDictionary *params = @{
                             @"orderId": requestParams
                             };
    
    kWeakSelf(self);
    
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionOrderDetail]
                                                      andType:All
                                                      andWith:params
                                                      success:^(NSDictionary *dic) {
                                                          
                                                          kStrongSelf(self);
                                                          //                                                        [SVProgressHUD dismiss];、
                                                          
                                                          self.model = [OrderDetailModel mj_objectWithKeyValues:dic];
                                                          
                                                          OrderType orderType = [self.model getTransactionOrderType];
                                                          
                                                          //                                                         NSLog(@"%lu",orderType);
                                                          
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              
                                                              //                                                             success(weakSelf.model);
                                                              [self assembleApiData:self.model];
                                                              
                                                              success(self.listData,self.model,@(orderType));
                                                          }
                                                          else{
                                                              failed(self.model);
                                                              [YKToastView showToastText:self.model.msg];
                                                          }
                                                          
                                                      } error:^(NSError *error) {
                                                          //                                                         [SVProgressHUD dismiss];
                                                          err(error);
                                                          [YKToastView showToastText:error.description];
                                                      }];
}

- (void)assembleApiData:(OrderDetailModel*)data{
    
    [self removeContentWithType:IndexSectionOne];
    
    OrderType orderType = [data getTransactionOrderType];
    
    NSDictionary* dic1 = @{
                           kArr:@(IndexSectionOne),
                           kData:data,
                           kType:@([data getTransactionOrderType]),
                           kImg:[data getTransactionOrderTypeImageName],
                           kTip:[data getTransactionOrderTypeTitle],
                           kSubTip:[data getTransactionOrderTypeSubTitle],
                           kIndexSection:@{
                                   
                                   kTip:[NSString stringWithFormat:@"%@",data.restTime] ,
                                   //                                       [NSString stringWithFormat:@"%@",[NSString timeWithSecond:[data.restTime integerValue]]],
                                   kSubTip:[NSString stringWithFormat:@"%@",[data getTransactionOrderTypeFooterSubTitle]]
                                   },
                           
                           kIndexRow:
                               orderType == BuyerOrderTypeFinished?
                           @[
                               @{@"订单号：":[NSString stringWithFormat:@"%@",data.orderNo]},
                               @{@"订单金额：":[NSString stringWithFormat:@"%@",data.orderAmount]},
                               @{@"单价：":@"1 CNY = 1 BUB"},
                               @{@"数量：":[NSString stringWithFormat:@"%@ BUB",data.number]},
                               @{@"支付方式：":[data getPaywayAppendingString]},
                               @{@"付款参考号：":[NSString stringWithFormat:@"%@",data.paymentNumber]}
                               ]
                           :
                           @[
                               @{@"订单号：":[NSString stringWithFormat:@"%@",data.orderNo]},
                               @{@"订单金额：":[NSString stringWithFormat:@"%@",data.orderAmount]},
                               @{@"单价：":@"1 CNY = 1 BUB"},
                               @{@"数量：":[NSString stringWithFormat:@"%@ BUB",data.number]},
                               @{@"订单时间：":[NSString stringWithFormat:@"%@",data.createdTime]
                                 }
                               ]
                           
                           };
    
    [self.listData addObjectsFromArray:@[dic1]];
    
    [self sortData];
}

- (void)sortData {
    
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kArr]
                                                         integerValue]];
        
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kArr]
                                                         integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kArr] integerValue];
        
        if (contentType == type) {
            
            *stop = YES;
            
            [self.listData removeObject:obj];
        }
    }];
}


- (void)network_getOrderDetailWithRequestParams:(id)requestParams
                             appealScheduleType:(NSInteger)ty // 特殊
                                        success:(TwoDataBlock)success
                                         failed:(DataBlock)failed
                                          error:(DataBlock)err{
    _listData = [NSMutableArray array];
    NSDictionary *params = @{
                             @"orderId": requestParams
                             };
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionOrderDetail]
                                                      andType:All
                                                      andWith:params
                                                      success:^(NSDictionary *dic) {
                                                          [SVProgressHUD dismiss];
                                                          if ([NSString getDataSuccessed:dic]) {
                                                              BuyBubDetailModel *mo = [[BuyBubDetailModel alloc] initWithDic:dic  appealScheduleType:ty];
                                                              OrderDetailModel *m =[OrderDetailModel mj_objectWithKeyValues:dic];
                                                              success(mo,m);
                                                          }
                                                          else{
                                                              failed(self.model);
                                                              [YKToastView showToastText:dic[@"msg"]];
                                                          }
                                                      } error:^(NSError *error) {
                                                          [SVProgressHUD dismiss];
                                                          err(error);
                                                          [YKToastView showToastText:error.description];
                                                      }];
}


@end
