//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAppealVM.h"
#import "OrderDetailModel.h"

@interface PostAppealVM()

@property (nonatomic,strong) PostAppealModel* model;

@property (nonatomic,strong)OrderDetailModel *orderDetailModel;
@property (nonatomic,strong) id requestParams;

@property (nonatomic,assign)OrderType orderType;
@end

@implementation PostAppealVM

- (void)network_submitAppealWithRequestParams:(id)requestParams
                                      success:(DataBlock)success
                                       failed:(DataBlock)failed
                                        error:(DataBlock)err{
    
    NSArray *arr = requestParams;
    
    _listData = [NSMutableArray array];
    
    NSDictionary *params = nil;
    if (arr.count ==5 ) {
        params = @{
                   @"remarks": arr[0],//备注
                   @"reason": arr[1],//申诉原因
                   @"email": arr[2],//邮箱地址
                   @"orderNo": arr[3],//订单号
                   @"voucherUrl": arr[4],//凭证地址
                   };
    }else{
        params = @{
                   @"remarks": arr[0],//备注
                   @"reason": arr[1],//申诉原因
                   @"email": arr[2],//邮箱地址
                   @"orderNo": arr[3],//订单号
                   };
    }
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeNone];
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_SubmitAppeal]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         
                                                         kStrongSelf(self);
                                                         
                                                         self.orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:dic];
                                                         
                                                         if ([NSString getDataSuccessed:dic]) {
                                                             success(self.orderDetailModel);
                                                         }else{
                                                             
                                                             [YKToastView showToastText:self.orderDetailModel.msg];
                                                             failed(self.orderDetailModel);
                                                         }
                                                     } error:^(NSError *error) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                     }];
}

- (void)network_getPostAppealListWithPage:(NSInteger)page
                        WithRequestParams:(id)requestParams
                                orderType:(OrderType)orderType
                                  success:(void (^)(NSArray * _Nonnull))success
                                   failed:(void (^)(void))failed {
    
    self.requestParams = requestParams;
    
    _listData = [NSMutableArray array];
    
    self.orderType = orderType;
    
    [self assembleApiData];
    
    success(self.listData);
    
    
}

- (void)assembleApiData{
    [self removeContentWithType:IndexSectionZero];
    if (singLeton.myType == UserTypeSeller) {//卖家
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[@{kTip:self.requestParams,
                                                  kArr:@[
//                                                          @{@"0":@"请选择"},
                                                          @{@"0_S_1_2":@"其他原因"},//0_S_1_2 已支付-卖家-其他原因
                                                          @{@"1_S_1_2":@"买方未付款却标记已付款"}//1_S_1_2
                                                          ]
                                                  }
                                                ]
                                   }];
    }else{//买家
        NSArray *arr = NSArray.array;
        switch (self.orderType) {
            case BuyerOrderTypeHadPaidNotDistribute:{//买方_订单已经支付不放行 ///
                arr = @[
                        @{@"0_B_1_2":@"其他原因"},//0_B_1_5 已关闭-买家-其他原因
                        @{@"1_B_1_2":@"已转帐，卖方长时间未放行"}//1_B_1_2
                        ];
            } break;
            case BuyerOrderTypeHadPaidWaitDistribute:{//买方_订单已经支付待放行 (等待放行)
                arr = @[
                        @{@"0_B_1_2":@"其他原因"},//0_B_1_5 已关闭-买家-其他原因
                        @{@"1_B_1_2":@"已转帐，卖方长时间未放行"}//1_B_1_2
                        ];
            }  break;
            case BuyerOrderTypeCancel://买方_订单取消 (向卖家转账)
                break;
            case BuyerOrderTypeClosed:{//买方_订单关闭 (付款已超时 / 已取消)(向卖家转账)  已超时
                arr =   @[
//                          @{@"0":@"请选择"},
                          @{@"0_B_1_5":@"其他原因"},//0_B_1_2 已支付-买家-其他原因
                          @{@"1_B_1_5":@"卖家提供错误付款信息"},//1_B_1_5
                          @{@"2_B_1_5":@"已付款，但未在规定时间内点击确认付款"}
                          ];
            }break;
            default:
                break;
        }
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[@{kTip:[NSString stringWithFormat:@"%@",self.requestParams],
                                                  kArr:arr
                                                  }]
                                   }];
    }
    [self removeContentWithType:IndexSectionOne];
    [self.listData addObject:@{
                               
                               kIndexSection: @(IndexSectionOne),
                               kIndexInfo:@[@"",@""],
                               kIndexRow: @[@{@"":@""}]}
     ];
    
    [self removeContentWithType:IndexSectionTwo];
    
    [self.listData addObject:@{
                               
                               kIndexSection: @(IndexSectionTwo),
                               kIndexInfo:@[@"备注",@"如有任何问题",@"请联系客服"],
                               kIndexRow: @[@{@"":@"填写更多信息"}]}
     ];
    
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


+ (void)postAntiAppealWithRequestParams:(NSString*)appearlID
                                andData:(id)requestParams
                                success:(DataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err{
    
    NSArray *arr = requestParams;
    NSDictionary *params = nil;
    if (arr.count ==5 ) {
        params = @{
                   @"appealId":appearlID,
                   @"remarks": arr[0],//备注
                   @"reason": arr[1],//申诉原因
                   @"email": arr[2],//邮箱地址
                   @"orderNo": arr[3],//订单号
                   @"voucherUrl": arr[4],//凭证地址
                   };
    }else{
        params = @{
                   @"appealId":appearlID,
                   @"remarks": arr[0],//备注
                   @"reason": arr[1],//申诉原因
                   @"email": arr[2],//邮箱地址
                   @"orderNo": arr[3],//订单号
                   };
    }
    
    [SVProgressHUD showWithStatus:@""];
    //    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AppealAnti]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
                                                         if (dic) {
                                                             success(dic);
                                                         }
                                                     } error:^(NSError *error) {
                                                         
                                                         [SVProgressHUD dismiss];
                                                         [YKToastView showToastText:error.description];
                                                         err(error);
                                                     }];
}



@end
