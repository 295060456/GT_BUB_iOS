//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAdsDetailVM.h"

@interface PostAdsDetailVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) PostAdsDetailModel* model;
@end

@implementation PostAdsDetailVM

- (void)network_getPostAdsDetailListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    WS(weakSelf);
    
    [self assembleApiData:weakSelf.model.result.data];
    success(weakSelf.listData);

}

- (void)assembleApiData:(PostAdsDetailData*)data{
    NSDictionary* dic1 = @{kType:@(PostAdsDetailTypeSuccess),kImg:@"iconSucc",kTip:@"发布成功",kSubTip:[NSString stringWithFormat:@"%@",@"请确认收到款项后再放行"], kIndexSection:@{kTip:[NSString stringWithFormat:@"%@",@"00:30"],kSubTip:[NSString stringWithFormat:@"%@",@"请在 15 分钟内处理，超时将影响卖家信誉"]},
                           kIndexRow:
                               @[
                                   @{@"币种：":@"BUB"},
                                   @{@"数量：":@"590 BUB"},
                                   @{@"单价：":@"1 CNY = 1 BUB"},
                                   @{@"首款方式：":@"支付宝"},
                                   @{@"单笔限额：":@"1000～23000"}
                                   ]
                           };
    
    
    [self.listData addObjectsFromArray:@[dic1]];
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
