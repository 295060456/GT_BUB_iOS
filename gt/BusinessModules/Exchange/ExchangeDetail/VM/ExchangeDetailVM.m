//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ExchangeDetailVM.h"

@interface ExchangeDetailVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) ExchangeModel* model;
@end

@implementation ExchangeDetailVM
- (void)network_getExchangeDetailBackWithPage:(NSInteger)page WithRequestParams:(id)requestParams successuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    _listData = [NSMutableArray array];
    NSString* btcApplyId = requestParams;
    NSDictionary* proDic =@{@"btcApplyId":btcApplyId};
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_BTCBack] andType:All andWith:proDic success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        self.model = [ExchangeModel mj_objectWithKeyValues:dic];
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

- (void)network_getExchangeDetailWithPage:(NSInteger)page WithRequestParams:(id)requestParams successuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    _listData = [NSMutableArray array];
    NSString* btcApplyId = requestParams;
    NSDictionary* proDic =@{@"btcApplyId":btcApplyId};
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_BTCDetail] andType:All andWith:proDic success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        self.model = [ExchangeModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            [self assembleApiData:weakSelf.model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsBackExchangeRefresh object:nil];
            
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

- (void)assembleApiData:(ExchangeModel*)data{
    [self removeContentWithType:IndexSectionZero];
    NSDictionary* dic0 = @{
                           
                       kIndexInfo:
                           @{
                            kType:@([data getExchangeStatus])
                            
                            },
                           kIndexSection:@(IndexSectionZero),
                           kIndexRow:
                               @[
                                   @{@"兑换币种：":@"BUB/BTC"},
                                   @{@"汇率：":[NSString stringWithFormat:@"1 BUB = %@ BTC",data.btcRate]},
                                   @{@"兑换数量：":[NSString stringWithFormat:@"%@ BUB",data.number]},
                                   @{@"收到BTC数量：":[NSString stringWithFormat:@"%@ BTC",data.btcNumber]}
                                   ]
                           
                           };
    [self.listData addObject:dic0];
    
    [self removeContentWithType:IndexSectionOne];
    NSDictionary* dic1 = @{
                           
                           kIndexInfo:@{
                             kType:@([data getExchangeStatus]),
                             kTip:[data getExchangePayerAndRefusedStatusName]
                             },
                           kIndexSection:@(IndexSectionOne),
                           kIndexRow:
                               @[
                                   @{@"提交时间：":data.createdTime},
                                   @{@"兑换状态：":[data getExchangeStatusName]},
                                   @{@"BTC收币地址：":data.btcAddress},
                                   
                                   ]
                           
                           };
    
    [self.listData addObject:dic1];
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

@end
