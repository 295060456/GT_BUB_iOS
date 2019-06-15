//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ModifyAdsVM.h"

@interface ModifyAdsVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) ModifyAdsModel* model;
@end

@implementation ModifyAdsVM

- (void)network_getModifyAdsListWithPage:(NSInteger)page WithRequestParams:(NSString*)requestParams success:(TwoDataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    if (requestParams==nil) {
        [YKToastView showToastText:@"缺失广告ID"];
        return;
    }
    _listData = [NSMutableArray array];
    NSDictionary *params = @{@"advertId":requestParams};
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AdsDetail] andType:All andWith:params success:^(NSDictionary *dic) {
        
        self.model = [ModifyAdsModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            
            [weakSelf assembleApiData:weakSelf.model];
            success(weakSelf.listData,weakSelf.model);
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

- (void)assembleApiData:(ModifyAdsModel*)data{
    [self removeContentWithType:IndexSectionZero];
    NSDictionary* dic0 = @{kType:@(SellerOrderTypeFinished),
                           kImg:@"iconSucc",
                           kTip:@"状态",
                           kSubTip:data.getOccurAdsTypeName,
                           kIndexSection:@(IndexSectionZero),
                           
                       
                           kIndexRow:
                               @[
                                   @{@"广告ID：":data.ugOtcAdvertId},
                                   @{@"广告类型：":@"卖出 BUB 币"},
                                   @{@"货币类型：":@"人民币 CNY"},
                                   @{@"单价：":@"1 CNY = 1 BUB"},
                                   @{@"卖出数量：":[NSString stringWithFormat:@"%@ BUB",data.number]},
                                   @{@"创建时间：":data.createdtime},@{@"付款期限：":[NSString stringWithFormat:@"%@ 分钟",data.prompt]},
                                   @{@"收款账号：":[NSString getPaywayAppendingString:data.paymentway]}
                                   
                                   ]
                           
                           };
    [self.listData addObject:dic0];
    
    [self removeContentWithType:IndexSectionOne];
    NSDictionary* dic1 = @{kImg:@"iconSucc",kTip:@"自动回复：",kSubTip:[NSString stringWithFormat:@"%@",@""], kIndexSection:@(IndexSectionOne),
                           kIndexRow:
                               @[
                                   
                                   @{[NSString stringWithFormat:@"%@",data.autoReplyContent]:@"用户下单看到的快捷回复，可填写付款要求。"}
                                   
                                   ]
                           
                           };
    [self.listData addObject:dic1];
    
    [self removeContentWithType:IndexSectionTwo];
    NSDictionary* dic2 = @{kImg:@"iconSucc",kTip:@"买家限制：",kSubTip:[NSString stringWithFormat:@"%@",@""], kIndexSection:@(IndexSectionTwo),
                       kArr:@[data.isIdNumber,data.isSeniorCertification],
                           kIndexRow:
                               @[
                                   @{@"收款账号：":@"支付宝"}
                                   ]
                           };
    
    [self.listData addObject:dic2];
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
