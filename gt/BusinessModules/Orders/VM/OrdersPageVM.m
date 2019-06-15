//
//  PageVM.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "OrdersPageVM.h"
#import "OrdersPageModel.h"
@interface OrdersPageVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) OrdersPageModel* model;
@end

@implementation OrdersPageVM

- (void)network_getOrdersPageListWithPage:(NSInteger)page
                        WithRequestParams:(id)requestParams
                                 withRole:(NSString*)role
                                  success:(DataBlock)success
                                   failed:(DataBlock)failed
                                    error:(DataBlock)err{
    
    _listData = [NSMutableArray array];
    NSString* p =  [NSString stringWithFormat:@"%ld",(long)page];
    NSString* t =  [NSString stringWithFormat:@"%@",requestParams];
    NSString* pagesize =  @"10";
    NSDictionary *params = @{
                             @"role":role?role:@"",
                             @"type":t,
                             @"pageno":p,
                             @"pagesize":pagesize
                             };
    //    [self assembleApiData:nil];
    //    success(self.listData);
    //    return;
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    WS(weakSelf);
//    [self assembleApiData:weakSelf.model];
//    success(weakSelf.listData);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionOrderList]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
        
        [SVProgressHUD dismiss];
        
        self.model = [OrdersPageModel mj_objectWithKeyValues:dic];
        
        if ([NSString getDataSuccessed:dic]) {
            //success(weakSelf.model);
            [weakSelf assembleApiData:self.model];
            success(weakSelf.listData);
        }
        else{
            failed(weakSelf.model);
            [YKToastView showToastText:weakSelf.model.msg];
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
        
    }];
}

- (void)assembleApiData:(OrdersPageModel*)data{
    if (data.userOrder !=nil && data.userOrder.count>0) {
        [data.userOrder enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderDetailModel* item = obj;
            [self.listData addObject:@[item]];
        }];
//        [self.listData addObjectsFromArray:data.b];
    }
    return;
    NSDictionary* dic0 = @{kType:@(SellerOrderTypeFinished),kImg:@"iconSucc",kTip:@"对方已确认付款",kSubTip:[NSString stringWithFormat:@"%@",@"已完成"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"订单号：":@"498653498670"},
                                   @{@"订单金额：":@"5900"},
                                   @{@"单价：":@"100 CNY = 1 AB"},
                                   @{@"数量：":@"590 AB"},
                                   @{@"订单时间：":@"2018-10-19 12:00:12"}
                                   ]
                           
                           };
    NSDictionary* dic1 = @{kType:@(SellerOrderTypeNotYetPay),kImg:@"iconSucc",kTip:@"对方已确认付款",kSubTip:[NSString stringWithFormat:@"%@",@"等待买方付款"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"订单号：":@"498653498670"},
                                   @{@"订单金额：":@"5900"},
                                   @{@"单价：":@"100 CNY = 1 AB"},
                                   @{@"数量：":@"590 AB"},
                                   @{@"订单时间：":@"2018-10-19 12:00:12"}
                                   ]
                           
                           };
    NSDictionary* dic2 = @{kType:@(SellerOrderTypeCancel),kImg:@"iconSucc",kTip:@"对方已确认付款",kSubTip:[NSString stringWithFormat:@"%@",@"已取消"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"订单号：":@"498653498670"},
                                   @{@"订单金额：":@"5900"},
                                   @{@"单价：":@"100 CNY = 1 AB"},
                                   @{@"数量：":@"590 AB"},
                                   @{@"订单时间：":@"2018-10-19 12:00:12"}
                                   ]
                           
                           };
    
    NSDictionary* dic3 = @{kType:@(SellerOrderTypeWaitDistribute),kImg:@"iconSucc",kTip:@"对方已确认付款",kSubTip:[NSString stringWithFormat:@"%@",@"待放行"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"订单号：":@"498653498670"},
                                   @{@"订单金额：":@"5900"},
                                   @{@"单价：":@"100 CNY = 1 AB"},
                                   @{@"数量：":@"590 AB"},
                                   @{@"订单时间：":@"2018-10-19 12:00:12"}
                                   ]
                           
                           };
    NSDictionary* dic4 = @{kType:@(SellerOrderTypeAppealing),kImg:@"iconSucc",kTip:@"对方已确认付款",kSubTip:[NSString stringWithFormat:@"%@",@"等待买方付款"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"订单号：":@"498653498670"},
                                   @{@"订单金额：":@"5900"},
                                   @{@"单价：":@"100 CNY = 1 AB"},
                                   @{@"数量：":@"590 AB"},
                                   @{@"订单时间：":@"2018-10-19 12:00:12"}
                                   ]
                           
                           };
    [self.listData addObjectsFromArray:@[@[dic0],@[dic1],@[dic2],@[dic3],@[dic4]]];
}
@end
